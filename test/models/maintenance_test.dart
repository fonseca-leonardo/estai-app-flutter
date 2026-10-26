import 'package:estai/models/maintenance.dart';
import 'package:estai/models/maintenance_category.dart';
import 'package:estai/models/maintenance_status.dart';
import 'package:estai/models/notification_channel.dart';
import 'package:estai/models/push_notification_target.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:flutter_test/flutter_test.dart';

Maintenance _maintenance({
  MaintenanceStatus status = MaintenanceStatus.scheduled,
  DateTime? dueDate,
  double? dueEngineHours,
}) {
  return Maintenance(
    id: 'm1',
    boatId: 'b1',
    title: 'Troca de óleo',
    category: MaintenanceCategory.engine,
    status: status,
    dueDate: dueDate,
    dueEngineHours: dueEngineHours,
    reminder: const ReminderSettings.defaults(),
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  final now = DateTime(2026, 10, 26, 15, 30);

  group('Maintenance.daysRemaining', () {
    test('counts calendar days, ignoring the time of day', () {
      final maintenance = _maintenance(dueDate: DateTime(2026, 10, 27, 8));
      expect(maintenance.daysRemaining(now: now), 1);
    });

    test('is zero on the due day and negative after it', () {
      expect(
        _maintenance(dueDate: DateTime(2026, 10, 26)).daysRemaining(now: now),
        0,
      );
      expect(
        _maintenance(dueDate: DateTime(2026, 10, 20)).daysRemaining(now: now),
        -6,
      );
    });

    test('is null without a due date', () {
      expect(_maintenance().daysRemaining(now: now), isNull);
    });
  });

  group('Maintenance.hoursRemaining', () {
    test('subtracts the current reading from the due reading', () {
      final maintenance = _maintenance(dueEngineHours: 200);
      expect(maintenance.hoursRemaining(185), 15);
      expect(maintenance.hoursRemaining(210), -10);
    });

    test('is null when the current reading is unknown', () {
      expect(_maintenance(dueEngineHours: 200).hoursRemaining(null), isNull);
    });
  });

  group('Maintenance.isOverdue', () {
    test('trusts the backend status', () {
      expect(
        _maintenance(status: MaintenanceStatus.overdue).isOverdue(now: now),
        isTrue,
      );
    });

    test('is overdue by date or by engine hours, whichever comes first', () {
      final maintenance = _maintenance(
        dueDate: DateTime(2026, 12, 1),
        dueEngineHours: 200,
      );
      expect(maintenance.isOverdue(currentEngineHours: 150, now: now), isFalse);
      expect(maintenance.isOverdue(currentEngineHours: 201, now: now), isTrue);
      expect(
        _maintenance(
          dueDate: DateTime(2026, 10, 25),
        ).isOverdue(currentEngineHours: 0, now: now),
        isTrue,
      );
    });

    test('is never overdue once done', () {
      final maintenance = _maintenance(
        status: MaintenanceStatus.done,
        dueDate: DateTime(2026, 1, 1),
      );
      expect(maintenance.isOverdue(now: now), isFalse);
    });
  });

  group('ReminderSettings', () {
    test('round-trips through JSON', () {
      const reminder = ReminderSettings(
        enabled: true,
        daysBefore: [30, 7],
        hoursBefore: 10,
        channels: [NotificationChannel.push, NotificationChannel.email],
      );
      final parsed = ReminderSettings.fromJson(reminder.toJson());

      expect(reminder.toJson()['channels'], ['Push', 'Email']);
      expect(parsed.enabled, isTrue);
      expect(parsed.daysBefore, [30, 7]);
      expect(parsed.hoursBefore, 10);
      expect(parsed.channels, reminder.channels);
      expect(parsed.usesPush, isTrue);
    });
  });

  group('PushNotificationTarget', () {
    test('reads the push data payload', () {
      final target = PushNotificationTarget.fromData({
        'type': 'maintenance',
        'boatId': 'b1',
        'id': 'm1',
      });
      expect(target?.isMaintenance, isTrue);
      expect(target?.boatId, 'b1');
      expect(target?.id, 'm1');
    });

    test('ignores payloads without a boat', () {
      expect(PushNotificationTarget.fromData({'type': 'maintenance'}), isNull);
    });

    test('reads estai://boats/{boatId}/maintenances/{id} links', () {
      final target = PushNotificationTarget.fromUri(
        Uri.parse('estai://boats/b1/maintenances/m1'),
      );
      expect(target?.isMaintenance, isTrue);
      expect(target?.boatId, 'b1');
      expect(target?.id, 'm1');
      expect(
        PushNotificationTarget.fromUri(Uri.parse('estai://marina/x')),
        isNull,
      );
    });
  });
}
