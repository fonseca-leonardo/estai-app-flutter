import 'package:flutter/foundation.dart';
import '../models/ramp_schedule.dart';
import '../models/ramp_schedule_status.dart';
import '../services/ramp_schedule_service.dart';

/// Agendamentos de rampa do usuário: os próximos e o histórico.
///
/// Sem push, a única forma de saber se a marina aprovou ou recusou um pedido é
/// recarregar a lista; as telas chamam [loadUpcoming] ao abrir e no
/// pull-to-refresh.
class RampScheduleViewModel extends ChangeNotifier {
  RampScheduleViewModel({RampScheduleService? rampScheduleService})
    : _rampScheduleService = rampScheduleService ?? RampScheduleService();

  final RampScheduleService _rampScheduleService;

  List<RampSchedule> _upcoming = [];
  List<RampSchedule> _history = [];
  bool _isLoadingUpcoming = false;
  bool _isLoadingHistory = false;
  String? _upcomingErrorMessage;
  String? _historyErrorMessage;

  List<RampSchedule> get upcoming => List.unmodifiable(_upcoming);
  List<RampSchedule> get history => List.unmodifiable(_history);
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get upcomingErrorMessage => _upcomingErrorMessage;
  String? get historyErrorMessage => _historyErrorMessage;

  /// Próximos que ainda contam (pendentes, confirmados ou em andamento).
  List<RampSchedule> get activeUpcoming =>
      _upcoming.where((schedule) => schedule.status.isActive).toList();

  Future<void> loadUpcoming() async {
    _isLoadingUpcoming = true;
    _upcomingErrorMessage = null;
    notifyListeners();

    try {
      final result = await _rampScheduleService.getSchedules(upcoming: true);
      _upcoming = result.items;
    } catch (e) {
      _upcomingErrorMessage = e.toString();
    }
    _isLoadingUpcoming = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    _historyErrorMessage = null;
    notifyListeners();

    try {
      final result = await _rampScheduleService.getSchedules(upcoming: false);
      _history = result.items;
    } catch (e) {
      _historyErrorMessage = e.toString();
    }
    _isLoadingHistory = false;
    notifyListeners();
  }

  /// A subida de retorno ainda cancelável de uma descida, se houver.
  RampSchedule? cancellableReturnOf(RampSchedule launch) {
    for (final schedule in [..._upcoming, ..._history]) {
      if (schedule.linkedScheduleId == launch.id && schedule.canCancel) {
        return schedule;
      }
    }
    return null;
  }

  Future<bool> cancelSchedule(String id) async {
    final previous = _replaceStatus(id, RampScheduleStatus.cancelled);

    try {
      final updated = await _rampScheduleService.cancelSchedule(id);
      _replace(updated);
      return true;
    } catch (e) {
      if (previous != null) _replace(previous);
      return false;
    }
  }

  RampSchedule? _replaceStatus(String id, RampScheduleStatus status) {
    RampSchedule? previous;
    for (final list in [_upcoming, _history]) {
      final index = list.indexWhere((schedule) => schedule.id == id);
      if (index != -1) {
        previous = list[index];
        list[index] = previous.copyWith(status: status);
      }
    }
    notifyListeners();
    return previous;
  }

  void _replace(RampSchedule schedule) {
    for (final list in [_upcoming, _history]) {
      final index = list.indexWhere((item) => item.id == schedule.id);
      if (index != -1) list[index] = schedule;
    }
    notifyListeners();
  }
}
