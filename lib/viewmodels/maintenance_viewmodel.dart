import 'package:flutter/foundation.dart';
import '../models/maintenance.dart';
import '../models/maintenance_status.dart';
import '../services/maintenance_service.dart';

/// Manutenções de uma embarcação: as pendentes e o histórico.
///
/// Criada pela própria tela com o [boatId] (escopo de tela).
class MaintenanceViewModel extends ChangeNotifier {
  MaintenanceViewModel({
    required this.boatId,
    MaintenanceService? maintenanceService,
  }) : _maintenanceService = maintenanceService ?? MaintenanceService();

  final String boatId;
  final MaintenanceService _maintenanceService;

  List<Maintenance> _upcoming = [];
  List<Maintenance> _history = [];
  bool _isLoadingUpcoming = false;
  bool _isLoadingHistory = false;
  String? _upcomingErrorMessage;
  String? _historyErrorMessage;

  List<Maintenance> get upcoming => List.unmodifiable(_upcoming);
  List<Maintenance> get history => List.unmodifiable(_history);
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get upcomingErrorMessage => _upcomingErrorMessage;
  String? get historyErrorMessage => _historyErrorMessage;

  Future<void> loadUpcoming() async {
    _isLoadingUpcoming = true;
    _upcomingErrorMessage = null;
    notifyListeners();

    try {
      final result = await _maintenanceService.getMaintenances(
        boatId: boatId,
        upcoming: true,
      );
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
      final result = await _maintenanceService.getMaintenances(
        boatId: boatId,
        upcoming: false,
      );
      _history = result.items;
    } catch (e) {
      _historyErrorMessage = e.toString();
    }
    _isLoadingHistory = false;
    notifyListeners();
  }

  Future<void> loadAll() => Future.wait([loadUpcoming(), loadHistory()]);

  /// Move a manutenção para o histórico na hora e desfaz se a API falhar. Se
  /// for recorrente, a próxima ocorrência criada pelo backend entra nas
  /// pendentes.
  Future<bool> complete({
    required String id,
    required DateTime completedAt,
    double? engineHours,
    double? cost,
    String? notes,
  }) async {
    final index = _upcoming.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    final previous = _upcoming[index];

    _upcoming.removeAt(index);
    _history.insert(
      0,
      previous.copyWith(
        status: MaintenanceStatus.done,
        completedAt: completedAt,
      ),
    );
    notifyListeners();

    try {
      final result = await _maintenanceService.completeMaintenance(
        id: id,
        completedAt: completedAt,
        engineHours: engineHours,
        cost: cost,
        notes: notes,
      );
      _history[0] = result.maintenance;
      final next = result.next;
      if (next != null) _insertUpcoming(next);
      notifyListeners();
      return true;
    } catch (e) {
      _history.removeAt(0);
      _upcoming.insert(index, previous);
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    final upcomingIndex = _upcoming.indexWhere((item) => item.id == id);
    final historyIndex = _history.indexWhere((item) => item.id == id);
    final removedUpcoming = upcomingIndex != -1
        ? _upcoming.removeAt(upcomingIndex)
        : null;
    final removedHistory = historyIndex != -1
        ? _history.removeAt(historyIndex)
        : null;
    notifyListeners();

    try {
      await _maintenanceService.deleteMaintenance(id);
      return true;
    } catch (e) {
      if (removedUpcoming != null) {
        _upcoming.insert(upcomingIndex, removedUpcoming);
      }
      if (removedHistory != null) {
        _history.insert(historyIndex, removedHistory);
      }
      notifyListeners();
      return false;
    }
  }

  /// Mantém as pendentes na ordem do backend: por data de vencimento, sem
  /// data por último.
  void _insertUpcoming(Maintenance maintenance) {
    final due = maintenance.dueDate;
    final index = due == null
        ? -1
        : _upcoming.indexWhere(
            (item) => item.dueDate == null || item.dueDate!.isAfter(due),
          );
    if (index == -1) {
      _upcoming.add(maintenance);
    } else {
      _upcoming.insert(index, maintenance);
    }
  }
}
