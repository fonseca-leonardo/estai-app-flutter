import 'package:estai/models/maintenance.dart';
import 'package:estai/models/maintenance_category.dart';
import 'package:estai/models/maintenance_status.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/services/maintenance_service.dart';
import 'package:estai/viewmodels/maintenance_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

Maintenance _maintenance(
  String id, {
  MaintenanceStatus status = MaintenanceStatus.scheduled,
  DateTime? dueDate,
}) {
  return Maintenance(
    id: id,
    boatId: 'b1',
    title: 'Manutenção $id',
    category: MaintenanceCategory.engine,
    status: status,
    dueDate: dueDate,
    reminder: const ReminderSettings.defaults(),
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

class _FakeMaintenanceService extends MaintenanceService {
  _FakeMaintenanceService()
    : super(apiClient: EstaiApiClient(baseUrl: 'http://test'));

  List<Maintenance> upcoming = [];
  List<Maintenance> history = [];
  CompleteMaintenanceResult? completeResult;
  bool fail = false;

  @override
  Future<MaintenanceListResult> getMaintenances({
    required String boatId,
    required bool upcoming,
    int page = 1,
    int limit = 50,
  }) async {
    final items = upcoming ? this.upcoming : history;
    return MaintenanceListResult(
      items: items,
      total: items.length,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<CompleteMaintenanceResult> completeMaintenance({
    required String id,
    required DateTime completedAt,
    double? engineHours,
    double? cost,
    String? notes,
  }) async {
    if (fail) throw ApiException('boom', statusCode: 500);
    return completeResult!;
  }

  @override
  Future<void> deleteMaintenance(String id) async {
    if (fail) throw ApiException('boom', statusCode: 500);
  }
}

void main() {
  late _FakeMaintenanceService service;
  late MaintenanceViewModel viewModel;

  setUp(() async {
    service = _FakeMaintenanceService()
      ..upcoming = [
        _maintenance('a', dueDate: DateTime(2026, 11, 1)),
        _maintenance('b', dueDate: DateTime(2026, 12, 1)),
      ]
      ..history = [_maintenance('old', status: MaintenanceStatus.done)];
    viewModel = MaintenanceViewModel(boatId: 'b1', maintenanceService: service);
    await viewModel.loadAll();
  });

  test(
    'complete moves the item to history and schedules the next one',
    () async {
      service.completeResult = CompleteMaintenanceResult(
        maintenance: _maintenance('a', status: MaintenanceStatus.done),
        next: _maintenance('a2', dueDate: DateTime(2026, 11, 15)),
      );

      final success = await viewModel.complete(
        id: 'a',
        completedAt: DateTime(2026, 10, 26),
      );

      expect(success, isTrue);
      expect(viewModel.upcoming.map((m) => m.id), ['a2', 'b']);
      expect(viewModel.history.map((m) => m.id), ['a', 'old']);
      expect(viewModel.history.first.status, MaintenanceStatus.done);
    },
  );

  test('complete rolls back when the API fails', () async {
    service.fail = true;

    final success = await viewModel.complete(
      id: 'b',
      completedAt: DateTime(2026, 10, 26),
    );

    expect(success, isFalse);
    expect(viewModel.upcoming.map((m) => m.id), ['a', 'b']);
    expect(viewModel.history.map((m) => m.id), ['old']);
  });

  test('delete rolls back when the API fails', () async {
    service.fail = true;

    final success = await viewModel.delete('a');

    expect(success, isFalse);
    expect(viewModel.upcoming.map((m) => m.id), ['a', 'b']);
  });

  test('delete removes the item', () async {
    final success = await viewModel.delete('old');

    expect(success, isTrue);
    expect(viewModel.history, isEmpty);
  });
}
