import 'package:estai/models/push_notification_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromData', () {
    test('maintenance needs the boat', () {
      expect(
        PushNotificationTarget.fromData({'type': 'maintenance', 'id': 'm1'}),
        isNull,
      );
      final target = PushNotificationTarget.fromData({
        'type': 'maintenance',
        'boatId': 'b1',
        'id': 'm1',
      });
      expect(target?.isMaintenance, isTrue);
    });

    test('reminder opens with boat and id', () {
      final target = PushNotificationTarget.fromData({
        'type': 'reminder',
        'boatId': 'b1',
        'id': 'r1',
      });
      expect(target?.isReminder, isTrue);
      expect(target?.id, 'r1');
    });

    test('personal document has no boat but needs the id', () {
      final target = PushNotificationTarget.fromData({
        'type': 'document',
        'boatId': '',
        'id': 'd1',
      });
      expect(target?.isDocument, isTrue);
      expect(target?.boatId, isNull);
      expect(
        PushNotificationTarget.fromData({'type': 'document', 'boatId': 'b1'}),
        isNull,
      );
    });
  });

  group('fromUri', () {
    test('boat maintenance, reminder and document links', () {
      final maintenance = PushNotificationTarget.fromUri(
        Uri.parse('estai://boats/b1/maintenances/m1'),
      );
      final reminder = PushNotificationTarget.fromUri(
        Uri.parse('estai://boats/b1/reminders/r1'),
      );
      final document = PushNotificationTarget.fromUri(
        Uri.parse('estai://boats/b1/documents/d1'),
      );

      expect(maintenance?.isMaintenance, isTrue);
      expect(reminder?.isReminder, isTrue);
      expect(reminder?.boatId, 'b1');
      expect(document?.isDocument, isTrue);
      expect(document?.id, 'd1');
    });

    test('personal document link', () {
      final target = PushNotificationTarget.fromUri(
        Uri.parse('estai://me/documents/d1'),
      );
      expect(target?.isDocument, isTrue);
      expect(target?.boatId, isNull);
    });

    test('unknown links are ignored', () {
      expect(
        PushNotificationTarget.fromUri(Uri.parse('estai://boats/b1/other/x')),
        isNull,
      );
      expect(
        PushNotificationTarget.fromUri(Uri.parse('estai://boats/b1/documents')),
        isNull,
      );
      expect(
        PushNotificationTarget.fromUri(Uri.parse('estai://marina/m1')),
        isNull,
      );
    });
  });
}
