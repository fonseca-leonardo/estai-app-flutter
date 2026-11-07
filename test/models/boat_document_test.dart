import 'package:estai/models/boat_document.dart';
import 'package:estai/models/document_status.dart';
import 'package:estai/models/document_type.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/viewmodels/documents_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

BoatDocument document(String id, {DateTime? expiresAt}) => BoatDocument(
  id: id,
  boatId: 'b1',
  type: DocumentType.insurance,
  expiresAt: expiresAt,
  reminder: const ReminderSettings.disabled(),
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  final now = DateTime(2026, 11, 7, 15);

  group('DocumentStatus.of', () {
    test('no expiry date', () {
      expect(DocumentStatus.of(null, now: now), DocumentStatus.noExpiry);
    });

    test('expired yesterday', () {
      expect(
        DocumentStatus.of(DateTime(2026, 11, 6), now: now),
        DocumentStatus.expired,
      );
    });

    test('expires today counts as expiring, not expired', () {
      expect(
        DocumentStatus.of(DateTime(2026, 11, 7), now: now),
        DocumentStatus.expiringSoon,
      );
    });

    test('expiring within 30 days', () {
      expect(
        DocumentStatus.of(DateTime(2026, 12, 7), now: now),
        DocumentStatus.expiringSoon,
      );
    });

    test('valid after 30 days', () {
      expect(
        DocumentStatus.of(DateTime(2026, 12, 8), now: now),
        DocumentStatus.valid,
      );
    });
  });

  test('fromJson reads a personal document with attachments', () {
    final parsed = BoatDocument.fromJson({
      'id': 'd1',
      'boatId': null,
      'type': 'NauticalLicense',
      'title': null,
      'number': '123',
      'expiresAt': '2027-01-01T03:00:00.000Z',
      'reminder': {
        'enabled': true,
        'daysBefore': [30],
        'hoursBefore': null,
        'channels': ['Email'],
      },
      'attachments': [
        {
          'id': 'a1',
          'fileName': 'cha.jpg',
          'contentType': 'image/jpeg',
          'sizeBytes': 1000,
          'url': 'https://files/cha.jpg',
          'createdAt': '2026-11-01T00:00:00.000Z',
        },
      ],
      'createdAt': '2026-11-01T00:00:00.000Z',
      'updatedAt': '2026-11-01T00:00:00.000Z',
    });

    expect(parsed.isPersonal, isTrue);
    expect(parsed.type, DocumentType.nauticalLicense);
    expect(parsed.type.scope, DocumentScope.personal);
    expect(parsed.attachments.single.isImage, isTrue);
    expect(parsed.reminder.daysBefore, [30]);
  });

  test('sortByUrgency: expired, expiring, valid, then no expiry', () {
    final sorted = DocumentsViewModel.sortByUrgency([
      document('none'),
      document('valid-late', expiresAt: DateTime(2028)),
      document('expiring', expiresAt: DateTime(2026, 11, 20)),
      document('valid-early', expiresAt: DateTime(2027, 6)),
      document('expired', expiresAt: DateTime(2026, 10)),
    ], now: now);

    expect(sorted.map((doc) => doc.id), [
      'expired',
      'expiring',
      'valid-early',
      'valid-late',
      'none',
    ]);
  });
}
