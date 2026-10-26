class RampOpeningHour {
  final int weekday;
  final String opensAt;
  final String closesAt;

  RampOpeningHour({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  });

  factory RampOpeningHour.fromJson(Map<String, dynamic> json) {
    return RampOpeningHour(
      weekday: json['weekday'] as int,
      opensAt: json['opensAt'] as String,
      closesAt: json['closesAt'] as String,
    );
  }
}

class Ramp {
  final String id;
  final String marinaId;
  final String marinaLocationId;
  final String? marinaLocationName;
  final String name;
  final int slotDurationMinutes;
  final int capacityPerSlot;
  final bool autoConfirmAppBookings;
  final int minAdvanceMinutes;
  final int maxAdvanceDays;
  final bool active;
  final List<RampOpeningHour> openingHours;

  Ramp({
    required this.id,
    required this.marinaId,
    required this.marinaLocationId,
    this.marinaLocationName,
    required this.name,
    required this.slotDurationMinutes,
    required this.capacityPerSlot,
    required this.autoConfirmAppBookings,
    required this.minAdvanceMinutes,
    required this.maxAdvanceDays,
    required this.active,
    required this.openingHours,
  });

  factory Ramp.fromJson(Map<String, dynamic> json) {
    return Ramp(
      id: json['id'] as String,
      marinaId: json['marinaId'] as String,
      marinaLocationId: json['marinaLocationId'] as String,
      marinaLocationName: json['marinaLocationName'] as String?,
      name: json['name'] as String,
      slotDurationMinutes: json['slotDurationMinutes'] as int,
      capacityPerSlot: json['capacityPerSlot'] as int,
      autoConfirmAppBookings: json['autoConfirmAppBookings'] as bool? ?? false,
      minAdvanceMinutes: json['minAdvanceMinutes'] as int? ?? 0,
      maxAdvanceDays: json['maxAdvanceDays'] as int? ?? 30,
      active: json['active'] as bool? ?? true,
      openingHours: (json['openingHours'] as List<dynamic>? ?? [])
          .map((item) => RampOpeningHour.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
