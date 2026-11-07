import 'package:estai/models/boat_document.dart';
import 'package:estai/models/document_attachment.dart';
import 'package:estai/models/document_type.dart';
import 'package:estai/models/pending_attachment.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/attachment_service.dart';
import 'package:estai/services/document_service.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/viewmodels/document_form_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

BoatDocument document({
  String id = 'd1',
  String? boatId = 'b1',
  List<DocumentAttachment> attachments = const [],
}) => BoatDocument(
  id: id,
  boatId: boatId,
  type: DocumentType.insurance,
  expiresAt: DateTime(2027),
  reminder: const ReminderSettings.defaults(),
  attachments: attachments,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

DocumentAttachment attachment(String id) => DocumentAttachment(
  id: id,
  fileName: '$id.jpg',
  contentType: 'image/jpeg',
  sizeBytes: 10,
  createdAt: DateTime(2026),
);

PendingAttachment file(String name, {int size = 10}) =>
    PendingAttachment(path: '/tmp/$name', sizeBytes: size);

class _FakeDocumentService extends DocumentService {
  _FakeDocumentService()
    : super(apiClient: EstaiApiClient(baseUrl: 'http://test'));

  final List<String> calls = [];
  DocumentInput? lastInput;
  String? lastBoatId;

  @override
  Future<BoatDocument> createDocument({
    String? boatId,
    required DocumentInput input,
  }) async {
    calls.add('create');
    lastInput = input;
    lastBoatId = boatId;
    return document(boatId: boatId);
  }

  @override
  Future<BoatDocument> updateDocument({
    required String id,
    required DocumentInput input,
  }) async {
    calls.add('update $id');
    lastInput = input;
    return document(id: id);
  }
}

class _FakeAttachmentService extends AttachmentService {
  _FakeAttachmentService()
    : super(apiClient: EstaiApiClient(baseUrl: 'http://test'));

  final Set<String> failingFiles = {};
  final List<String> uploaded = [];
  final List<String> deleted = [];

  @override
  Future<DocumentAttachment> upload({
    required String ownerPath,
    required PendingAttachment file,
  }) async {
    if (failingFiles.contains(file.fileName)) {
      throw ApiException('Network error');
    }
    uploaded.add('$ownerPath ${file.fileName}');
    return attachment('up-${file.fileName}');
  }

  @override
  Future<void> delete({
    required String ownerPath,
    required String attachmentId,
  }) async {
    deleted.add('$ownerPath $attachmentId');
  }
}

void main() {
  late _FakeDocumentService documents;
  late _FakeAttachmentService attachments;

  setUp(() {
    documents = _FakeDocumentService();
    attachments = _FakeAttachmentService();
  });

  DocumentFormViewModel create({String? boatId = 'b1', BoatDocument? initial}) {
    return DocumentFormViewModel(
      boatId: boatId,
      initial: initial,
      documentService: documents,
      attachmentService: attachments,
    );
  }

  test('types follow the scope', () {
    expect(create().availableTypes, contains(DocumentType.insurance));
    expect(
      create(boatId: null).availableTypes,
      isNot(contains(DocumentType.insurance)),
    );
    expect(create(boatId: null).type, DocumentType.nauticalLicense);
  });

  test('issue date after expiry blocks saving', () async {
    final viewModel = create()
      ..setIssuedAt(DateTime(2027, 2))
      ..setExpiresAt(DateTime(2027, 1));

    final success = await viewModel.save();

    expect(success, isFalse);
    expect(viewModel.error, DocumentFormError.invalidDates);
    expect(documents.calls, isEmpty);
  });

  test('without expiry the reminder is sent disabled', () async {
    final viewModel = create()..setExpiresAt(null);

    await viewModel.save();

    expect(viewModel.showsReminder, isFalse);
    expect(documents.lastInput?.reminder.enabled, isFalse);
  });

  test('personal document is created without boat', () async {
    final viewModel = create(boatId: null)..setExpiresAt(DateTime(2030));

    await viewModel.save(number: '123');

    expect(documents.calls, ['create']);
    expect(documents.lastBoatId, isNull);
    expect(documents.lastInput?.type, DocumentType.nauticalLicense);
  });

  test('rejects unsupported, too large and over the limit', () {
    final viewModel = create();

    expect(viewModel.addFile(file('a.docx')), AttachmentAddResult.unsupported);
    expect(
      viewModel.addFile(
        file('big.jpg', size: PendingAttachment.maxSizeBytes + 1),
      ),
      AttachmentAddResult.tooLarge,
    );
    for (var i = 0; i < PendingAttachment.maxPerOwner; i++) {
      expect(viewModel.addFile(file('$i.jpg')), AttachmentAddResult.added);
    }
    expect(viewModel.addFile(file('x.jpg')), AttachmentAddResult.limitReached);
    expect(viewModel.canAddAttachment, isFalse);
  });

  test(
    'failed upload keeps the document saved and retry only resends it',
    () async {
      final viewModel = create()
        ..addFile(file('ok.jpg'))
        ..addFile(file('fail.pdf'));
      attachments.failingFiles.add('fail.pdf');

      final first = await viewModel.save();

      expect(first, isFalse);
      expect(viewModel.error, DocumentFormError.attachmentsFailed);
      expect(documents.calls, ['create']);
      expect(attachments.uploaded, ['/documents/d1 ok.jpg']);
      expect(viewModel.pendingFiles.map((f) => f.fileName), ['fail.pdf']);

      attachments.failingFiles.clear();
      final second = await viewModel.save();

      expect(second, isTrue);
      expect(documents.calls, ['create', 'update d1']);
      expect(attachments.uploaded, [
        '/documents/d1 ok.jpg',
        '/documents/d1 fail.pdf',
      ]);
      expect(viewModel.pendingFiles, isEmpty);
    },
  );

  test('removed attachments are deleted on save', () async {
    final existing = attachment('a1');
    final viewModel = create(
      initial: document(attachments: [existing, attachment('a2')]),
    )..removeAttachment(existing);

    expect(viewModel.attachments.map((a) => a.id), ['a2']);

    final success = await viewModel.save();

    expect(success, isTrue);
    expect(documents.calls, ['update d1']);
    expect(attachments.deleted, ['/documents/d1 a1']);
  });
}
