import 'dart:convert';

import 'package:estai/models/document_type.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/document_service.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> documentJson({String id = 'd1', String? boatId = 'b1'}) {
  return {
    'id': id,
    'boatId': boatId,
    'type': boatId == null ? 'NauticalLicense' : 'Insurance',
    'title': null,
    'number': 'AP-1',
    'issuer': 'Seguradora',
    'issuedAt': '2026-01-01T03:00:00.000Z',
    'expiresAt': '2027-01-01T03:00:00.000Z',
    'notes': null,
    'reminder': {
      'enabled': true,
      'daysBefore': [30, 7],
      'hoursBefore': null,
      'channels': ['Push'],
    },
    'attachments': [],
    'createdAt': '2026-11-01T00:00:00.000Z',
    'updatedAt': '2026-11-01T00:00:00.000Z',
  };
}

void main() {
  late List<http.Request> requests;

  DocumentService serviceReturning(int status, Object body) {
    requests = [];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode(body), status);
    });
    return DocumentService(
      apiClient: EstaiApiClient(client: client, baseUrl: 'http://test'),
    );
  }

  test('boat documents use the boat collection', () async {
    final service = serviceReturning(200, {
      'data': {
        'items': [documentJson()],
      },
    });

    final items = await service.getDocuments(boatId: 'b1');

    expect(requests.single.url.path, '/boats/b1/documents');
    expect(items.single.type, DocumentType.insurance);
  });

  test('personal documents use /me/documents', () async {
    final service = serviceReturning(201, {'data': documentJson(boatId: null)});

    final created = await service.createDocument(
      input: DocumentInput(
        type: DocumentType.nauticalLicense,
        number: '123',
        expiresAt: DateTime.utc(2030, 1, 1),
        reminder: const ReminderSettings.disabled(),
      ),
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(requests.single.url.path, '/me/documents');
    expect(body['type'], 'NauticalLicense');
    expect(body['expiresAt'], '2030-01-01T00:00:00.000Z');
    expect(body['issuedAt'], isNull);
    expect(created.isPersonal, isTrue);
  });

  test('update and delete go to /documents/{id}', () async {
    final service = serviceReturning(200, {'data': documentJson()});

    await service.updateDocument(
      id: 'd1',
      input: DocumentInput(
        type: DocumentType.insurance,
        reminder: const ReminderSettings.disabled(),
      ),
    );
    await service.deleteDocument('d1');

    expect(requests.map((r) => '${r.method} ${r.url.path}'), [
      'PUT /documents/d1',
      'DELETE /documents/d1',
    ]);
  });
}
