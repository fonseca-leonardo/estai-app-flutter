import 'package:flutter/foundation.dart';
import '../models/boat_document.dart';
import '../models/document_attachment.dart';
import '../models/document_type.dart';
import '../models/notification_channel.dart';
import '../models/pending_attachment.dart';
import '../models/reminder_settings.dart';
import '../services/attachment_service.dart';
import '../services/document_service.dart';
import '../services/estai_api_client.dart';

enum DocumentFormError {
  /// Emissão depois da validade.
  invalidDates,
  invalid,
  unknown,

  /// O documento foi salvo, mas algum anexo não subiu (ou não foi removido).
  attachmentsFailed,
}

enum AttachmentAddResult { added, unsupported, tooLarge, limitReached }

/// Formulário de criar/editar documento, com os anexos (excluir fica no
/// detalhe). Os textos ficam nos
/// controllers da tela; aqui ficam tipo, datas, aviso, anexos, validação e
/// envio.
///
/// Salvar grava o documento e depois envia os anexos um a um. Se um anexo
/// falhar, o documento continua salvo e salvar de novo só reenvia o que
/// faltou.
class DocumentFormViewModel extends ChangeNotifier {
  static const List<int> defaultDaysBefore = [30, 7];

  DocumentFormViewModel({
    this.boatId,
    this.initial,
    DocumentService? documentService,
    AttachmentService? attachmentService,
  }) : _documentService = documentService ?? DocumentService(),
       _attachmentService = attachmentService ?? AttachmentService(),
       _type =
           initial?.type ??
           DocumentType.forScope(
             boatId == null ? DocumentScope.personal : DocumentScope.boat,
           ).first,
       _issuedAt = initial?.issuedAt?.toLocal(),
       _expiresAt = initial?.expiresAt?.toLocal(),
       _reminder = initial != null && initial.reminder.enabled
           ? initial.reminder
           : ReminderSettings(
               enabled: true,
               daysBefore: defaultDaysBefore,
               channels: const ReminderSettings.defaults().channels,
             ),
       _attachments = [...?initial?.attachments],
       _saved = initial;

  /// Nulo: documento pessoal.
  final String? boatId;
  final BoatDocument? initial;
  final DocumentService _documentService;
  final AttachmentService _attachmentService;

  DocumentType _type;
  DateTime? _issuedAt;
  DateTime? _expiresAt;
  ReminderSettings _reminder;
  final List<DocumentAttachment> _attachments;
  final List<PendingAttachment> _pendingFiles = [];
  final Set<String> _removedAttachmentIds = {};

  /// O documento já gravado (o inicial, na edição, ou o criado num envio
  /// anterior cujos anexos falharam).
  BoatDocument? _saved;
  bool _isSubmitting = false;
  int _uploadIndex = 0;
  int _uploadTotal = 0;
  DocumentFormError? _error;

  bool get isEditing => initial != null;
  DocumentScope get scope =>
      boatId == null ? DocumentScope.personal : DocumentScope.boat;
  List<DocumentType> get availableTypes => DocumentType.forScope(scope);
  DocumentType get type => _type;
  DateTime? get issuedAt => _issuedAt;
  DateTime? get expiresAt => _expiresAt;

  /// Sem validade não há o que avisar.
  bool get showsReminder => _expiresAt != null;
  ReminderSettings get reminder => _reminder;

  List<DocumentAttachment> get attachments => _attachments
      .where((item) => !_removedAttachmentIds.contains(item.id))
      .toList();
  List<PendingAttachment> get pendingFiles => List.unmodifiable(_pendingFiles);
  int get attachmentCount => attachments.length + _pendingFiles.length;
  bool get canAddAttachment =>
      attachmentCount < PendingAttachment.maxPerOwner && !_isSubmitting;

  bool get isSubmitting => _isSubmitting;
  bool get isUploading => _isSubmitting && _uploadTotal > 0;
  int get uploadIndex => _uploadIndex;
  int get uploadTotal => _uploadTotal;
  DocumentFormError? get error => _error;

  void setType(DocumentType type) {
    _type = type;
    notifyListeners();
  }

  void setIssuedAt(DateTime? date) {
    _issuedAt = date;
    _clearDateError();
    notifyListeners();
  }

  void setExpiresAt(DateTime? date) {
    _expiresAt = date;
    _clearDateError();
    notifyListeners();
  }

  void setReminderEnabled(bool value) {
    _reminder = _reminder.copyWith(
      enabled: value,
      channels: value && _reminder.channels.isEmpty
          ? const ReminderSettings.defaults().channels
          : null,
      daysBefore: value && _reminder.daysBefore.isEmpty
          ? defaultDaysBefore
          : null,
    );
    notifyListeners();
  }

  void toggleReminderDay(int days) {
    final selected = [..._reminder.daysBefore];
    selected.contains(days) ? selected.remove(days) : selected.add(days);
    selected.sort((a, b) => b.compareTo(a));
    _reminder = _reminder.copyWith(daysBefore: selected);
    notifyListeners();
  }

  void toggleReminderChannel(NotificationChannel channel) {
    final selected = [..._reminder.channels];
    if (selected.contains(channel)) {
      // Lembrete ligado precisa de ao menos um canal.
      if (selected.length == 1) return;
      selected.remove(channel);
    } else {
      selected.add(channel);
    }
    _reminder = _reminder.copyWith(channels: selected);
    notifyListeners();
  }

  AttachmentAddResult addFile(PendingAttachment file) {
    if (attachmentCount >= PendingAttachment.maxPerOwner) {
      return AttachmentAddResult.limitReached;
    }
    if (!file.isAllowedType) return AttachmentAddResult.unsupported;
    if (file.isTooLarge) return AttachmentAddResult.tooLarge;
    _pendingFiles.add(file);
    notifyListeners();
    return AttachmentAddResult.added;
  }

  void removePendingFile(PendingAttachment file) {
    _pendingFiles.remove(file);
    notifyListeners();
  }

  /// A remoção só vai para a API ao salvar.
  void removeAttachment(DocumentAttachment attachment) {
    _removedAttachmentIds.add(attachment.id);
    notifyListeners();
  }

  void _clearDateError() {
    if (_error == DocumentFormError.invalidDates) _error = null;
  }

  Future<bool> save({
    String? title,
    String? number,
    String? issuer,
    String? notes,
  }) async {
    final issued = _issuedAt;
    final expires = _expiresAt;
    if (issued != null && expires != null && issued.isAfter(expires)) {
      _error = DocumentFormError.invalidDates;
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    final input = DocumentInput(
      type: _type,
      title: title,
      number: number,
      issuer: issuer,
      issuedAt: issued,
      expiresAt: expires,
      notes: notes,
      reminder: showsReminder && _reminder.enabled
          ? _reminder
          : const ReminderSettings.disabled(),
    );

    try {
      final existing = _saved;
      _saved = existing == null
          ? await _documentService.createDocument(boatId: boatId, input: input)
          : await _documentService.updateDocument(
              id: existing.id,
              input: input,
            );
    } on ApiException catch (e) {
      return _fail(
        e.statusCode == 400
            ? DocumentFormError.invalid
            : DocumentFormError.unknown,
      );
    } catch (e) {
      return _fail(DocumentFormError.unknown);
    }

    final syncedAll = await _syncAttachments(_saved!.id);
    _isSubmitting = false;
    _uploadTotal = 0;
    if (!syncedAll) _error = DocumentFormError.attachmentsFailed;
    notifyListeners();
    return syncedAll;
  }

  /// Remove os anexos marcados e envia os novos, um a um. O que der certo
  /// sai das listas, para que uma nova tentativa só repita o que faltou.
  Future<bool> _syncAttachments(String documentId) async {
    final ownerPath = AttachmentService.documentPath(documentId);
    var success = true;

    for (final id in [..._removedAttachmentIds]) {
      try {
        await _attachmentService.delete(ownerPath: ownerPath, attachmentId: id);
        _removedAttachmentIds.remove(id);
        _attachments.removeWhere((item) => item.id == id);
      } catch (e) {
        success = false;
      }
    }

    _uploadTotal = _pendingFiles.length;
    _uploadIndex = 0;
    for (final file in [..._pendingFiles]) {
      _uploadIndex++;
      notifyListeners();
      try {
        final uploaded = await _attachmentService.upload(
          ownerPath: ownerPath,
          file: file,
        );
        _pendingFiles.remove(file);
        _attachments.add(uploaded);
      } catch (e) {
        success = false;
      }
    }
    return success;
  }

  bool _fail(DocumentFormError error) {
    _error = error;
    _isSubmitting = false;
    notifyListeners();
    return false;
  }
}
