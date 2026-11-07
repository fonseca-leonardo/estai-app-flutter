import 'boat_reminder_status.dart';
import 'reminder_settings.dart';

/// Lembrete avulso do barco, que não é manutenção (ex.: "Renovar a vaga na
/// marina"). Quando é recorrente, marcar como feito faz o backend criar o
/// próximo.
class BoatReminder {
  final String id;
  final String boatId;
  final String title;
  final String? notes;
  final DateTime dueDate;
  final int? recurrenceMonths;
  final BoatReminderStatus status;
  final DateTime? completedAt;
  final ReminderSettings reminder;
  final DateTime createdAt;
  final DateTime updatedAt;

  BoatReminder({
    required this.id,
    required this.boatId,
    required this.title,
    this.notes,
    required this.dueDate,
    this.recurrenceMonths,
    required this.status,
    this.completedAt,
    required this.reminder,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRecurring => recurrenceMonths != null;
  bool get isDone => status == BoatReminderStatus.done;

  /// Dias de calendário até a data (negativo se já passou).
  int daysRemaining({DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    return _dateOnly(dueDate.toLocal()).difference(today).inDays;
  }

  bool isOverdue({DateTime? now}) => !isDone && daysRemaining(now: now) < 0;

  BoatReminder copyWith({BoatReminderStatus? status, DateTime? completedAt}) {
    return BoatReminder(
      id: id,
      boatId: boatId,
      title: title,
      notes: notes,
      dueDate: dueDate,
      recurrenceMonths: recurrenceMonths,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      reminder: reminder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory BoatReminder.fromJson(Map<String, dynamic> json) {
    final reminder = json['reminder'] as Map<String, dynamic>?;
    return BoatReminder(
      id: json['id'] as String,
      boatId: json['boatId'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      recurrenceMonths: (json['recurrenceMonths'] as num?)?.toInt(),
      status: BoatReminderStatus.fromApiValue(json['status'] as String),
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
      reminder: reminder != null
          ? ReminderSettings.fromJson(reminder)
          : const ReminderSettings.disabled(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
