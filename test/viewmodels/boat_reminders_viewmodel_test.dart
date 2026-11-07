import 'package:estai/models/boat_reminder.dart';
import 'package:estai/models/boat_reminder_status.dart';
import 'package:estai/models/reminder_settings.dart';
import 'package:estai/services/boat_reminder_service.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/viewmodels/boat_reminder_form_viewmodel.dart';
import 'package:estai/viewmodels/boat_reminders_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

BoatReminder reminder(
  String id, {
  DateTime? dueDate,
  BoatReminderStatus status = BoatReminderStatus.pending,
  int? recurrenceMonths,
}) => BoatReminder(
  id: id,
  boatId: 'b1',
  title: 'Lembrete $id',
  dueDate: dueDate ?? DateTime(2026, 12, 1),
  recurrenceMonths: recurrenceMonths,
  status: status,
  reminder: const ReminderSettings.defaults(),
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

class _FakeReminderService extends BoatReminderService {
  _FakeReminderService()
    : super(apiClient: EstaiApiClient(baseUrl: 'http://test'));

  List<BoatReminder> pending = [];
  BoatReminder? next;
  bool failMarkDone = false;
  BoatReminderInput? created;
  BoatReminderInput? updated;
  int? errorStatus;

  @override
  Future<BoatReminderListResult> getReminders({
    required String boatId,
    required BoatReminderStatus status,
    int page = 1,
    int limit = 50,
  }) async {
    final items = status == BoatReminderStatus.pending
        ? List.of(pending)
        : <BoatReminder>[];
    return BoatReminderListResult(
      items: items,
      total: items.length,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<MarkReminderDoneResult> markDone({
    required String id,
    required DateTime completedAt,
  }) async {
    if (failMarkDone) throw ApiException('Network error');
    final done = pending
        .firstWhere((item) => item.id == id)
        .copyWith(status: BoatReminderStatus.done, completedAt: completedAt);
    return MarkReminderDoneResult(reminder: done, next: next);
  }

  @override
  Future<BoatReminder> createReminder({
    required String boatId,
    required BoatReminderInput input,
  }) async {
    final status = errorStatus;
    if (status != null) throw ApiException('error', statusCode: status);
    created = input;
    return reminder('new');
  }

  @override
  Future<BoatReminder> updateReminder({
    required String id,
    required BoatReminderInput input,
  }) async {
    updated = input;
    return reminder(id);
  }
}

void main() {
  late _FakeReminderService service;

  setUp(() => service = _FakeReminderService());

  group('BoatRemindersViewModel', () {
    test('markDone moves to done and inserts the next by date', () async {
      service.pending = [
        reminder('r1', dueDate: DateTime(2026, 11, 10), recurrenceMonths: 12),
        reminder('r2', dueDate: DateTime(2027, 3, 1)),
      ];
      service.next = reminder('r1-next', dueDate: DateTime(2027, 11, 10));
      final viewModel = BoatRemindersViewModel(
        boatId: 'b1',
        reminderService: service,
      );
      await viewModel.loadPending();

      final success = await viewModel.markDone('r1');

      expect(success, isTrue);
      expect(viewModel.pending.map((item) => item.id), ['r2', 'r1-next']);
      expect(viewModel.done.single.id, 'r1');
      expect(viewModel.done.single.isDone, isTrue);
    });

    test('markDone rolls back when the API fails', () async {
      service.pending = [reminder('r1')];
      service.failMarkDone = true;
      final viewModel = BoatRemindersViewModel(
        boatId: 'b1',
        reminderService: service,
      );
      await viewModel.loadPending();

      final success = await viewModel.markDone('r1');

      expect(success, isFalse);
      expect(viewModel.pending.single.id, 'r1');
      expect(viewModel.done, isEmpty);
    });
  });

  group('BoatReminderFormViewModel', () {
    test('requires a date', () async {
      final viewModel = BoatReminderFormViewModel(
        boatId: 'b1',
        reminderService: service,
      );

      final success = await viewModel.save(title: 'Renovar');

      expect(success, isFalse);
      expect(viewModel.error, BoatReminderFormError.missingDate);
      expect(service.created, isNull);
    });

    test('new reminder defaults to days-only reminder', () {
      final viewModel = BoatReminderFormViewModel(
        boatId: 'b1',
        reminderService: service,
      );

      expect(viewModel.reminder.enabled, isTrue);
      expect(viewModel.reminder.hoursBefore, isNull);
    });

    test('sends recurrence only when repeating', () async {
      final viewModel = BoatReminderFormViewModel(
        boatId: 'b1',
        reminderService: service,
      )..setDueDate(DateTime(2026, 12, 1));

      await viewModel.save(title: 'Renovar', recurrenceMonths: 12);
      expect(service.created?.recurrenceMonths, isNull);

      viewModel.setRecurring(true);
      await viewModel.save(title: 'Renovar', recurrenceMonths: 12);
      expect(service.created?.recurrenceMonths, 12);
    });

    test('disabled reminder is sent as disabled settings', () async {
      final viewModel =
          BoatReminderFormViewModel(boatId: 'b1', reminderService: service)
            ..setDueDate(DateTime(2026, 12, 1))
            ..setReminderEnabled(false);

      await viewModel.save(title: 'Renovar');

      expect(service.created?.reminder.enabled, isFalse);
      expect(service.created?.reminder.channels, isEmpty);
    });

    test('editing updates instead of creating', () async {
      final viewModel = BoatReminderFormViewModel(
        boatId: 'b1',
        initial: reminder('r1'),
        reminderService: service,
      );

      await viewModel.save(title: 'Novo título');

      expect(service.updated?.title, 'Novo título');
      expect(service.created, isNull);
    });

    test('400 maps to invalid', () async {
      service.errorStatus = 400;
      final viewModel = BoatReminderFormViewModel(
        boatId: 'b1',
        reminderService: service,
      )..setDueDate(DateTime(2026, 12, 1));

      final success = await viewModel.save(title: 'Renovar');

      expect(success, isFalse);
      expect(viewModel.error, BoatReminderFormError.invalid);
    });
  });
}
