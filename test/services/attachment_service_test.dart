import 'dart:convert';
import 'dart:io';

import 'package:estai/models/pending_attachment.dart';
import 'package:estai/services/attachment_service.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late Directory tempDir;
  late File photo;
  late List<http.Request> requests;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('attachment_test');
    photo = File('${tempDir.path}/tie.jpg')..writeAsBytesSync([1, 2, 3, 4]);
  });

  tearDown(() => tempDir.deleteSync(recursive: true));

  AttachmentService serviceReturning(int status, Object body) {
    requests = [];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode(body), status);
    });
    return AttachmentService(
      apiClient: EstaiApiClient(client: client, baseUrl: 'http://test'),
    );
  }

  test('upload sends multipart with the file field', () async {
    final service = serviceReturning(201, {
      'data': {
        'id': 'a1',
        'fileName': 'tie.jpg',
        'contentType': 'image/jpeg',
        'sizeBytes': 4,
        'url': 'https://files/tie.jpg',
        'createdAt': '2026-11-07T00:00:00.000Z',
      },
    });

    final uploaded = await service.upload(
      ownerPath: AttachmentService.documentPath('d1'),
      file: PendingAttachment(path: photo.path, sizeBytes: 4),
    );

    final request = requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, '/documents/d1/attachments');
    expect(
      request.headers['content-type'],
      startsWith('multipart/form-data; boundary='),
    );
    final body = latin1.decode(request.bodyBytes);
    expect(body, contains('name="file"; filename="tie.jpg"'));
    expect(body, contains('content-type: image/jpeg'));
    expect(uploaded.id, 'a1');
    expect(uploaded.isImage, isTrue);
  });

  test('upload error keeps the status code', () async {
    final service = serviceReturning(413, {'message': 'File too large'});

    expect(
      () => service.upload(
        ownerPath: AttachmentService.documentPath('d1'),
        file: PendingAttachment(path: photo.path, sizeBytes: 4),
      ),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 413)),
    );
  });

  test('delete accepts 404 (already gone)', () async {
    final service = serviceReturning(404, {'message': 'Not found'});

    await service.delete(
      ownerPath: AttachmentService.documentPath('d1'),
      attachmentId: 'a1',
    );

    expect(requests.single.url.path, '/documents/d1/attachments/a1');
  });

  test('pending attachment validates type and size', () {
    expect(PendingAttachment(path: '/x/a.pdf', sizeBytes: 10).isPdf, isTrue);
    expect(
      PendingAttachment(path: '/x/a.docx', sizeBytes: 10).isAllowedType,
      isFalse,
    );
    expect(
      PendingAttachment(
        path: '/x/a.jpg',
        sizeBytes: PendingAttachment.maxSizeBytes + 1,
      ).isTooLarge,
      isTrue,
    );
    expect(
      PendingAttachment(path: '/x/A.HEIC', sizeBytes: 10).contentType,
      'image/heic',
    );
  });
}
