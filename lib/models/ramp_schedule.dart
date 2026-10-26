import 'ramp_schedule_status.dart';
import 'ramp_schedule_type.dart';

class RampSchedule {
  final String id;
  final String marinaId;
  final String rampId;
  final String? rampName;
  final String boatId;
  final String? boatName;
  final RampScheduleType type;
  final RampScheduleStatus status;
  final DateTime scheduledAt;
  final DateTime endsAt;
  final String? notes;
  final String? rejectionReason;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? linkedScheduleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  RampSchedule({
    required this.id,
    required this.marinaId,
    required this.rampId,
    this.rampName,
    required this.boatId,
    this.boatName,
    required this.type,
    required this.status,
    required this.scheduledAt,
    required this.endsAt,
    this.notes,
    this.rejectionReason,
    this.startedAt,
    this.completedAt,
    this.linkedScheduleId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isReturn => linkedScheduleId != null;

  /// Mesma regra do back: Pending/Confirmed e horário ainda não passou.
  bool get canCancel =>
      status.isCancellable && scheduledAt.isAfter(DateTime.now());

  RampSchedule copyWith({RampScheduleStatus? status}) {
    return RampSchedule(
      id: id,
      marinaId: marinaId,
      rampId: rampId,
      rampName: rampName,
      boatId: boatId,
      boatName: boatName,
      type: type,
      status: status ?? this.status,
      scheduledAt: scheduledAt,
      endsAt: endsAt,
      notes: notes,
      rejectionReason: rejectionReason,
      startedAt: startedAt,
      completedAt: completedAt,
      linkedScheduleId: linkedScheduleId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory RampSchedule.fromJson(Map<String, dynamic> json) {
    return RampSchedule(
      id: json['id'] as String,
      marinaId: json['marinaId'] as String,
      rampId: json['rampId'] as String,
      rampName: json['rampName'] as String?,
      boatId: json['boatId'] as String,
      boatName: json['boatName'] as String?,
      type: RampScheduleType.fromApiValue(json['type'] as String),
      status: RampScheduleStatus.fromApiValue(json['status'] as String),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      notes: json['notes'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
      linkedScheduleId: json['linkedScheduleId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
