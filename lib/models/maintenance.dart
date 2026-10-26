import 'maintenance_category.dart';
import 'maintenance_status.dart';
import 'reminder_settings.dart';

/// Manutenção da embarcação registrada pelo proprietário.
///
/// O vencimento pode ser por data ([dueDate]), por horímetro
/// ([dueEngineHours]) ou pelos dois — vale o que chegar primeiro. Quando é
/// recorrente, concluir faz o backend criar a próxima ocorrência.
class Maintenance {
  final String id;
  final String boatId;
  final String title;
  final String? description;
  final MaintenanceCategory category;
  final MaintenanceStatus status;
  final DateTime? dueDate;
  final double? dueEngineHours;
  final int? recurrenceMonths;
  final double? recurrenceHours;
  final DateTime? completedAt;
  final double? completedEngineHours;
  final double? cost;
  final String? provider;
  final String? notes;
  final String? serviceOrderId;
  final ReminderSettings reminder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Maintenance({
    required this.id,
    required this.boatId,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    this.dueDate,
    this.dueEngineHours,
    this.recurrenceMonths,
    this.recurrenceHours,
    this.completedAt,
    this.completedEngineHours,
    this.cost,
    this.provider,
    this.notes,
    this.serviceOrderId,
    required this.reminder,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRecurring => recurrenceMonths != null || recurrenceHours != null;

  /// Dias de calendário até o vencimento (negativo se já passou), ou `null`
  /// se não vence por data.
  int? daysRemaining({DateTime? now}) {
    final due = dueDate;
    if (due == null) return null;
    final today = _dateOnly(now ?? DateTime.now());
    return _dateOnly(due.toLocal()).difference(today).inDays;
  }

  /// Horas de motor até o vencimento (negativo se já passou), ou `null` se
  /// não vence por horímetro ou a leitura atual é desconhecida.
  double? hoursRemaining(double? currentEngineHours) {
    final due = dueEngineHours;
    if (due == null || currentEngineHours == null) return null;
    return due - currentEngineHours;
  }

  /// Atrasada pelo backend ou, localmente, por data ou horímetro.
  bool isOverdue({double? currentEngineHours, DateTime? now}) {
    if (status == MaintenanceStatus.overdue) return true;
    if (!status.isPending) return false;
    final days = daysRemaining(now: now);
    final hours = hoursRemaining(currentEngineHours);
    return (days != null && days < 0) || (hours != null && hours < 0);
  }

  Maintenance copyWith({MaintenanceStatus? status, DateTime? completedAt}) {
    return Maintenance(
      id: id,
      boatId: boatId,
      title: title,
      description: description,
      category: category,
      status: status ?? this.status,
      dueDate: dueDate,
      dueEngineHours: dueEngineHours,
      recurrenceMonths: recurrenceMonths,
      recurrenceHours: recurrenceHours,
      completedAt: completedAt ?? this.completedAt,
      completedEngineHours: completedEngineHours,
      cost: cost,
      provider: provider,
      notes: notes,
      serviceOrderId: serviceOrderId,
      reminder: reminder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    final reminder = json['reminder'] as Map<String, dynamic>?;
    return Maintenance(
      id: json['id'] as String,
      boatId: json['boatId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: MaintenanceCategory.fromApiValue(json['category'] as String),
      status: MaintenanceStatus.fromApiValue(json['status'] as String),
      dueDate: DateTime.tryParse(json['dueDate'] as String? ?? ''),
      dueEngineHours: (json['dueEngineHours'] as num?)?.toDouble(),
      recurrenceMonths: (json['recurrenceMonths'] as num?)?.toInt(),
      recurrenceHours: (json['recurrenceHours'] as num?)?.toDouble(),
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
      completedEngineHours: (json['completedEngineHours'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      provider: json['provider'] as String?,
      notes: json['notes'] as String?,
      serviceOrderId: json['serviceOrderId'] as String?,
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
