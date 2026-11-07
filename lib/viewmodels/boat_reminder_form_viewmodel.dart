import 'package:flutter/foundation.dart';
import '../models/boat_reminder.dart';
import '../models/notification_channel.dart';
import '../models/reminder_settings.dart';
import '../services/boat_reminder_service.dart';
import '../services/estai_api_client.dart';

enum BoatReminderFormError { missingDate, invalid, unknown }

/// Formulário de criar/editar lembrete avulso. Os textos ficam nos
/// controllers da tela; aqui ficam a data, a repetição, o aviso, a
/// validação e o envio.
class BoatReminderFormViewModel extends ChangeNotifier {
  BoatReminderFormViewModel({
    required this.boatId,
    this.initial,
    BoatReminderService? reminderService,
  }) : _reminderService = reminderService ?? BoatReminderService(),
       _dueDate = initial?.dueDate.toLocal(),
       _isRecurring = initial?.isRecurring ?? false,
       // Sem horímetro: só antecedência em dias.
       _reminder =
           initial?.reminder ??
           const ReminderSettings.defaults().copyWith(clearHoursBefore: true);

  final String boatId;
  final BoatReminder? initial;
  final BoatReminderService _reminderService;

  DateTime? _dueDate;
  bool _isRecurring;
  ReminderSettings _reminder;
  bool _isSubmitting = false;
  bool _isDeleting = false;
  BoatReminderFormError? _error;

  bool get isEditing => initial != null;
  DateTime? get dueDate => _dueDate;
  bool get isRecurring => _isRecurring;
  ReminderSettings get reminder => _reminder;
  bool get isSubmitting => _isSubmitting;
  bool get isDeleting => _isDeleting;
  BoatReminderFormError? get error => _error;

  void setDueDate(DateTime date) {
    _dueDate = date;
    if (_error == BoatReminderFormError.missingDate) _error = null;
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

  Future<bool> save({
    required String title,
    String? notes,
    int? recurrenceMonths,
  }) async {
    final dueDate = _dueDate;
    if (dueDate == null) {
      _error = BoatReminderFormError.missingDate;
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    final input = BoatReminderInput(
      title: title,
      notes: notes,
      dueDate: dueDate,
      recurrenceMonths: _isRecurring ? recurrenceMonths : null,
      reminder: _reminder.enabled
          ? _reminder
          : const ReminderSettings.disabled(),
    );

    try {
      final existing = initial;
      if (existing == null) {
        await _reminderService.createReminder(boatId: boatId, input: input);
      } else {
        await _reminderService.updateReminder(id: existing.id, input: input);
      }
      _isSubmitting = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.statusCode == 400
          ? BoatReminderFormError.invalid
          : BoatReminderFormError.unknown;
    } catch (e) {
      _error = BoatReminderFormError.unknown;
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
      await _reminderService.deleteReminder(existing.id);
      _isDeleting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isDeleting = false;
      _error = BoatReminderFormError.unknown;
      notifyListeners();
      return false;
    }
  }
}
