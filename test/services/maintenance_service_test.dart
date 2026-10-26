import 'dart:convert';

import 'package:estai/models/maintenance_category.dart';
import 'package:estai/models/maintenance_status.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/services/maintenance_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> maintenanceJson({
  String id = 'm1',
  String status = 'Scheduled',
  String? dueDate = '2026-11-01T03:00:00.000Z',
}) {
  return {
    'id': id,
    'boatId': 'b1',
    'title': 'Troca de óleo',
    'category': 'Engine',
    'status': status,
    'dueDate': dueDate,
    'dueEngineHours': 200,
    'recurrenceMonths': 12,
    'reminder': {
      'enabled': true,
      'daysBefore': [7, 1],
      'hoursBefore': 10,
      'channels': ['Push'],
    },
    'createdAt': '2026-10-01T00:00:00.000Z',
    'updatedAt': '2026-10-01T00:00:00.000Z',
  };
}

void main() {
  late List<http.Request> requests;

  MaintenanceService serviceReturning(int status, Object body) {
    requests = [];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode(body), status);
    });
    return MaintenanceService(
      apiClient: EstaiApiClient(client: client, baseUrl: 'http://test'),
    );
  }

  test(
    'getMaintenances parses the page and sends the upcoming filter',
    () async {
      final service = serviceReturning(200, {
        'data': {
          'items': [maintenanceJson()],
          'total': 1,
          'page': 1,
          'limit': 50,
        },
      });

      final result = await service.getMaintenances(
        boatId: 'b1',
        upcoming: true,
      );

      expect(requests.single.url.path, '/boats/b1/maintenances');
      expect(requests.single.url.queryParameters['upcoming'], 'true');
      expect(result.total, 1);
      final maintenance = result.items.single;
      expect(maintenance.category, MaintenanceCategory.engine);
      expect(maintenance.status, MaintenanceStatus.scheduled);
      expect(maintenance.dueEngineHours, 200);
      expect(maintenance.isRecurring, isTrue);
      expect(maintenance.reminder.daysBefore, [7, 1]);
    },
  );

  test('createMaintenance sends the reminder settings', () async {
    final service = serviceReturning(201, {'data': maintenanceJson()});

    await service.createMaintenance(
      boatId: 'b1',
      input: MaintenanceInput(
        title: 'Troca de óleo',
        category: MaintenanceCategory.engine,
        dueEngineHours: 200,
        reminder: const ReminderSettings.defaults(),
      ),
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(requests.single.method, 'POST');
    expect(body['category'], 'Engine');
    expect(body['reminder']['channels'], ['Push', 'Email']);
    expect(body['reminder']['daysBefore'], [7, 1]);
  });

  test(
    'createMaintenance sends completion for already done maintenance',
    () async {
      final service = serviceReturning(201, {
        'data': maintenanceJson(status: 'Done', dueDate: null),
      });

      await service.createMaintenance(
        boatId: 'b1',
        input: MaintenanceInput(
          title: 'Troca de óleo',
          category: MaintenanceCategory.engine,
          reminder: const ReminderSettings.disabled(),
          completion: MaintenanceCompletionInput(
            completedAt: DateTime.utc(2026, 3, 10),
            engineHours: 180,
          ),
        ),
      );

      final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
      expect(body['dueDate'], isNull);
      expect(body['completion']['completedAt'], '2026-03-10T00:00:00.000Z');
      expect(body['completion']['engineHours'], 180);
      expect(body['completion']['cost'], isNull);
    },
  );

  test('pending maintenance is sent without completion', () async {
    final service = serviceReturning(201, {'data': maintenanceJson()});

    await service.createMaintenance(
      boatId: 'b1',
      input: MaintenanceInput(
        title: 'Troca de óleo',
        category: MaintenanceCategory.engine,
        dueEngineHours: 200,
        reminder: const ReminderSettings.defaults(),
      ),
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(body['completion'], isNull);
  });

  test('completeMaintenance returns the next occurrence', () async {
    final service = serviceReturning(200, {
      'data': {
        'maintenance': maintenanceJson(status: 'Done'),
        'next': maintenanceJson(id: 'm2'),
      },
    });

    final result = await service.completeMaintenance(
      id: 'm1',
      completedAt: DateTime.utc(2026, 10, 26),
      engineHours: 201,
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(requests.single.url.path, '/maintenances/m1/complete');
    expect(body['engineHours'], 201);
    expect(body.containsKey('cost'), isFalse);
    expect(result.maintenance.status, MaintenanceStatus.done);
    expect(result.next?.id, 'm2');
  });

  test('joins the API validation messages into the exception', () async {
    final service = serviceReturning(400, {
      'message': ['title should not be empty', 'dueDate must be a date'],
    });

    expect(
      () => service.getMaintenances(boatId: 'b1', upcoming: true),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having(
              (e) => e.message,
              'message',
              'title should not be empty\ndueDate must be a date',
            ),
      ),
    );
  });
}
