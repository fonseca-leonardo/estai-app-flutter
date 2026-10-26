import 'package:flutter/foundation.dart';
import '../models/maintenance.dart';
import '../models/maintenance_category.dart';
import '../models/notification_channel.dart';
import '../models/reminder_settings.dart';
import '../services/estai_api_client.dart';
import '../services/maintenance_service.dart';

enum MaintenanceFormError { missingDue, invalid, unknown }

/// Formulário de criar/editar manutenção. Os textos ficam nos controllers da
/// tela; aqui ficam as escolhas (categoria, vencimento, recorrência e
/// lembrete), a validação e o envio.
class MaintenanceFormViewModel extends ChangeNotifier {
  MaintenanceFormViewModel({
    required this.boatId,
    this.initial,
    MaintenanceService? maintenanceService,
  }) : _maintenanceService = maintenanceService ?? MaintenanceService(),
       _category = initial?.category ?? MaintenanceCategory.engine,
       _dueDate = initial?.dueDate?.toLocal(),
       _isRecurring = initial?.isRecurring ?? false,
       _reminder = initial?.reminder ?? const ReminderSettings.defaults(),
       _isCompleted = false,
       _completedAt = DateTime.now();

  final String boatId;
  final Maintenance? initial;
  final MaintenanceService _maintenanceService;

  MaintenanceCategory _category;
  DateTime? _dueDate;
  bool _isRecurring;
  ReminderSettings _reminder;
  bool _isCompleted;
  DateTime _completedAt;
  bool _isSubmitting = false;
  bool _isDeleting = false;
  MaintenanceFormError? _error;

  bool get isEditing => initial != null;
  MaintenanceCategory get category => _category;
  DateTime? get dueDate => _dueDate;
  bool get isRecurring => _isRecurring;
  ReminderSettings get reminder => _reminder;
  bool get isSubmitting => _isSubmitting;
  bool get isDeleting => _isDeleting;
  MaintenanceFormError? get error => _error;

  /// Registro de uma manutenção que já foi feita: pede a data de realização
  /// em vez do vencimento.
  bool get isCompleted => _isCompleted;
  DateTime get completedAt => _completedAt;

  /// Só ao criar. Uma manutenção existente é sempre pendente aqui: concluir
  /// é pela lista e concluída não se edita (abre os detalhes).
  bool get canToggleCompleted => !isEditing;

  /// Concluída e sem repetição não tem o que lembrar; recorrente avisa sobre
  /// a próxima ocorrência.
  bool get showsReminder => !_isCompleted || _isRecurring;

  void setCategory(MaintenanceCategory category) {
    _category = category;
    notifyListeners();
  }

  void setCompleted(bool value) {
    if (!canToggleCompleted) return;
    _isCompleted = value;
    _clearMissingDue();
    notifyListeners();
  }

  void setCompletedAt(DateTime date) {
    _completedAt = date;
    notifyListeners();
  }

  void setDueDate(DateTime? date) {
    _dueDate = date;
    _clearMissingDue();
    notifyListeners();
  }

  void setRecurring(bool value) {
    _isRecurring = value;
    notifyListeners();
  }

  void setReminderEnabled(bool value) {
    _reminder = _reminder.copyWith(
      enabled: value,
      channels: value && _reminder.channels.isEmpty
          ? const ReminderSettings.defaults().channels
          : null,
      daysBefore: value && _reminder.daysBefore.isEmpty ? const [7, 1] : null,
    );
    notifyListeners();
  }

  void toggleReminderDay(int days) {
    final selected = [..._reminder.daysBefore];
    selected.contains(days) ? selected.remove(days) : selected.add(days);
    selected.sort((a, b) => b.compareTo(a));
    _reminder = _reminder.copyWith(daysBefore: selected);
    notifyListeners();
  }

  void setReminderHours(int? hours) {
    _reminder = hours == null
        ? _reminder.copyWith(clearHoursBefore: true)
        : _reminder.copyWith(hoursBefore: hours);
    notifyListeners();
  }

  void toggleReminderChannel(NotificationChannel channel) {
    final selected = [..._reminder.channels];
    if (selected.contains(channel)) {
      // Lembrete ligado precisa de ao menos um canal.
      if (selected.length == 1) return;
      selected.remove(channel);
    } else {
      selected.add(channel);
    }
    _reminder = _reminder.copyWith(channels: selected);
    notifyListeners();
  }

  /// Chamado ao editar o campo de horímetro, para limpar o aviso de
  /// vencimento ausente.
  void onDueEngineHoursChanged() {
    if (_clearMissingDue()) notifyListeners();
  }

  bool _clearMissingDue() {
    if (_error != MaintenanceFormError.missingDue) return false;
    _error = null;
    return true;
  }

  Future<bool> save({
    required String title,
    String? description,
    double? dueEngineHours,
    int? recurrenceMonths,
    double? recurrenceHours,
    String? provider,
    double? completedEngineHours,
    double? cost,
    String? notes,
  }) async {
    if (!_isCompleted && _dueDate == null && dueEngineHours == null) {
      _error = MaintenanceFormError.missingDue;
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    final input = MaintenanceInput(
      title: title,
      description: description,
      category: _category,
      dueDate: _dueDate,
      dueEngineHours: dueEngineHours,
      recurrenceMonths: _isRecurring ? recurrenceMonths : null,
      recurrenceHours: _isRecurring ? recurrenceHours : null,
      provider: provider,
      reminder: showsReminder && _reminder.enabled
          ? _reminder
          : const ReminderSettings.disabled(),
      completion: _isCompleted
          ? MaintenanceCompletionInput(
              completedAt: _completedAt,
              engineHours: completedEngineHours,
              cost: cost,
              notes: notes,
            )
          : null,
    );

    try {
      final existing = initial;
      if (existing == null) {
        await _maintenanceService.createMaintenance(
          boatId: boatId,
          input: input,
        );
      } else {
        await _maintenanceService.updateMaintenance(
          id: existing.id,
          input: input,
        );
      }
      _isSubmitting = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.statusCode == 400
          ? MaintenanceFormError.invalid
          : MaintenanceFormError.unknown;
    } catch (e) {
      _error = MaintenanceFormError.unknown;
    }
    _isSubmitting = false;
    notifyListeners();
    return false;
  }

  Future<bool> delete() async {
    final existing = initial;
    if (existing == null) return false;

    _isDeleting = true;
    notifyListeners();

    try {
      await _maintenanceService.deleteMaintenance(existing.id);
      _isDeleting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isDeleting = false;
      _error = MaintenanceFormError.unknown;
      notifyListeners();
      return false;
    }
  }
}
