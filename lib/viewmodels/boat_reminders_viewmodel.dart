import 'package:flutter/foundation.dart';
import '../models/boat_reminder.dart';
import '../models/boat_reminder_status.dart';
import '../services/boat_reminder_service.dart';

/// Lembretes avulsos de uma embarcação: os pendentes e os já feitos.
///
/// Criada pela própria tela com o [boatId] (escopo de tela).
class BoatRemindersViewModel extends ChangeNotifier {
  BoatRemindersViewModel({
    required this.boatId,
    BoatReminderService? reminderService,
  }) : _reminderService = reminderService ?? BoatReminderService();

  final String boatId;
  final BoatReminderService _reminderService;

  List<BoatReminder> _pending = [];
  List<BoatReminder> _done = [];
  bool _isLoadingPending = false;
  bool _isLoadingDone = false;
  String? _pendingErrorMessage;
  String? _doneErrorMessage;

  List<BoatReminder> get pending => List.unmodifiable(_pending);
  List<BoatReminder> get done => List.unmodifiable(_done);
  bool get isLoadingPending => _isLoadingPending;
  bool get isLoadingDone => _isLoadingDone;
  String? get pendingErrorMessage => _pendingErrorMessage;
  String? get doneErrorMessage => _doneErrorMessage;

  Future<void> loadPending() async {
    _isLoadingPending = true;
    _pendingErrorMessage = null;
    notifyListeners();

    try {
      final result = await _reminderService.getReminders(
        boatId: boatId,
        status: BoatReminderStatus.pending,
      );
      _pending = result.items;
    } catch (e) {
      _pendingErrorMessage = e.toString();
    }
    _isLoadingPending = false;
    notifyListeners();
  }

  Future<void> loadDone() async {
    _isLoadingDone = true;
    _doneErrorMessage = null;
    notifyListeners();

    try {
      final result = await _reminderService.getReminders(
        boatId: boatId,
        status: BoatReminderStatus.done,
      );
      _done = result.items;
    } catch (e) {
      _doneErrorMessage = e.toString();
    }
    _isLoadingDone = false;
    notifyListeners();
  }

  Future<void> loadAll() => Future.wait([loadPending(), loadDone()]);

  /// Move o lembrete para os feitos na hora e desfaz se a API falhar. Se
  /// for recorrente, o próximo criado pelo backend entra nos pendentes.
  Future<bool> markDone(String id, {DateTime? now}) async {
    final index = _pending.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    final previous = _pending[index];
    final completedAt = now ?? DateTime.now();

    _pending.removeAt(index);
    _done.insert(
      0,
      previous.copyWith(
        status: BoatReminderStatus.done,
        completedAt: completedAt,
      ),
    );
    notifyListeners();

    try {
      final result = await _reminderService.markDone(
        id: id,
        completedAt: completedAt,
      );
      _done[0] = result.reminder;
      final next = result.next;
      if (next != null) _insertPending(next);
      notifyListeners();
      return true;
    } catch (e) {
      _done.removeAt(0);
      _pending.insert(index, previous);
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    final pendingIndex = _pending.indexWhere((item) => item.id == id);
    final doneIndex = _done.indexWhere((item) => item.id == id);
    final removedPending = pendingIndex != -1
        ? _pending.removeAt(pendingIndex)
        : null;
    final removedDone = doneIndex != -1 ? _done.removeAt(doneIndex) : null;
    notifyListeners();

    try {
      await _reminderService.deleteReminder(id);
      return true;
    } catch (e) {
      if (removedPending != null) _pending.insert(pendingIndex, removedPending);
      if (removedDone != null) _done.insert(doneIndex, removedDone);
      notifyListeners();
      return false;
    }
  }

  /// Mantém os pendentes na ordem do backend: data mais próxima primeiro.
  void _insertPending(BoatReminder reminder) {
    final index = _pending.indexWhere(
      (item) => item.dueDate.isAfter(reminder.dueDate),
    );
    if (index == -1) {
      _pending.add(reminder);
    } else {
      _pending.insert(index, reminder);
    }
  }
}
