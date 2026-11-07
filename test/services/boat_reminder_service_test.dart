import 'dart:convert';

import 'package:estai/models/boat_reminder_status.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/boat_reminder_service.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> reminderJson({
  String id = 'r1',
  String status = 'Pending',
  int? recurrenceMonths = 12,
}) {
  return {
    'id': id,
    'boatId': 'b1',
    'title': 'Renovar a vaga na marina',
    'notes': null,
    'dueDate': '2026-12-01T03:00:00.000Z',
    'recurrenceMonths': recurrenceMonths,
    'status': status,
    'completedAt': status == 'Done' ? '2026-11-07T12:00:00.000Z' : null,
    'reminder': {
      'enabled': true,
      'daysBefore': [7, 1],
      'hoursBefore': null,
      'channels': ['Push', 'Email'],
    },
    'createdAt': '2026-11-01T00:00:00.000Z',
    'updatedAt': '2026-11-01T00:00:00.000Z',
  };
}

void main() {
  late List<http.Request> requests;

  BoatReminderService serviceReturning(int status, Object body) {
    requests = [];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode(body), status);
    });
    return BoatReminderService(
      apiClient: EstaiApiClient(client: client, baseUrl: 'http://test'),
    );
  }

  test('getReminders sends the status filter and parses the page', () async {
    final service = serviceReturning(200, {
      'data': {
        'items': [reminderJson()],
        'total': 1,
        'page': 1,
        'limit': 50,
      },
    });

    final result = await service.getReminders(
      boatId: 'b1',
      status: BoatReminderStatus.pending,
    );

    expect(requests.single.url.path, '/boats/b1/reminders');
    expect(requests.single.url.queryParameters['status'], 'Pending');
    expect(result.items.single.title, 'Renovar a vaga na marina');
    expect(result.items.single.recurrenceMonths, 12);
  });

  test('createReminder posts the input', () async {
    final service = serviceReturning(201, {'data': reminderJson()});

    await service.createReminder(
      boatId: 'b1',
      input: BoatReminderInput(
        title: 'Renovar a vaga na marina',
        dueDate: DateTime.utc(2026, 12, 1, 3),
        recurrenceMonths: 12,
        reminder: const ReminderSettings.disabled(),
      ),
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(requests.single.method, 'POST');
    expect(body['dueDate'], '2026-12-01T03:00:00.000Z');
    expect(body['recurrenceMonths'], 12);
    expect(body['reminder']['enabled'], false);
  });

  test('markDone returns the done reminder and the next one', () async {
    final service = serviceReturning(200, {
      'data': {
        'reminder': reminderJson(status: 'Done'),
        'next': reminderJson(id: 'r2'),
      },
    });

    final result = await service.markDone(
      id: 'r1',
      completedAt: DateTime.utc(2026, 11, 7, 12),
    );

    expect(requests.single.method, 'PATCH');
    expect(requests.single.url.path, '/reminders/r1/done');
    expect(result.reminder.isDone, isTrue);
    expect(result.next?.id, 'r2');
  });

  test('errors carry the status code and message', () async {
    final service = serviceReturning(400, {'message': 'dueDate is required'});

    expect(
      () => service.updateReminder(
        id: 'r1',
        input: BoatReminderInput(
          title: 't',
          dueDate: DateTime(2026),
          reminder: const ReminderSettings.disabled(),
        ),
      ),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.message, 'message', 'dueDate is required'),
      ),
    );
  });
}
