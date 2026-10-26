import 'package:estai/models/maintenance.dart';
import 'package:estai/models/maintenance_category.dart';
import 'package:estai/models/maintenance_status.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/services/maintenance_service.dart';
import 'package:estai/viewmodels/maintenance_form_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingMaintenanceService extends MaintenanceService {
  _RecordingMaintenanceService()
    : super(apiClient: EstaiApiClient(baseUrl: 'http://test'));

  MaintenanceInput? created;
  MaintenanceInput? updated;

  Maintenance _fake(String boatId) => Maintenance(
    id: 'm1',
    boatId: boatId,
    title: 't',
    category: MaintenanceCategory.engine,
    status: MaintenanceStatus.scheduled,
    reminder: const ReminderSettings.defaults(),
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  @override
  Future<Maintenance> createMaintenance({
    required String boatId,
    required MaintenanceInput input,
  }) async {
    created = input;
    return _fake(boatId);
  }

  @override
  Future<Maintenance> updateMaintenance({
    required String id,
    required MaintenanceInput input,
  }) async {
    updated = input;
    return _fake('b1');
  }
}

void main() {
  late _RecordingMaintenanceService service;

  setUp(() => service = _RecordingMaintenanceService());

  test('pending maintenance requires a due date or engine hours', () async {
    final viewModel = MaintenanceFormViewModel(
      boatId: 'b1',
      maintenanceService: service,
    );

    final success = await viewModel.save(title: 'Troca de óleo');

    expect(success, isFalse);
    expect(viewModel.error, MaintenanceFormError.missingDue);
    expect(service.created, isNull);
  });

  test('already done maintenance is sent with completion and no due', () async {
    final viewModel = MaintenanceFormViewModel(
      boatId: 'b1',
      maintenanceService: service,
    )..setCompleted(true);
    viewModel.setCompletedAt(DateTime(2026, 3, 10));

    final success = await viewModel.save(
      title: 'Troca de óleo',
      completedEngineHours: 180,
      cost: 450,
      notes: 'Filtro trocado',
    );

    expect(success, isTrue);
    final input = service.created!;
    expect(input.dueDate, isNull);
    expect(input.dueEngineHours, isNull);
    expect(input.completion?.completedAt, DateTime(2026, 3, 10));
    expect(input.completion?.engineHours, 180);
    expect(input.completion?.cost, 450);
    expect(input.completion?.notes, 'Filtro trocado');
    // Sem repetição não há próxima ocorrência para lembrar.
    expect(viewModel.showsReminder, isFalse);
    expect(input.reminder.enabled, isFalse);
  });

  test(
    'already done and recurring keeps the reminder for the next one',
    () async {
      final viewModel =
          MaintenanceFormViewModel(boatId: 'b1', maintenanceService: service)
            ..setCompleted(true)
            ..setRecurring(true);

      await viewModel.save(title: 'Troca de óleo', recurrenceMonths: 12);

      final input = service.created!;
      expect(viewModel.showsReminder, isTrue);
      expect(input.recurrenceMonths, 12);
      expect(input.reminder.enabled, isTrue);
      expect(input.completion, isNotNull);
    },
  );
}
