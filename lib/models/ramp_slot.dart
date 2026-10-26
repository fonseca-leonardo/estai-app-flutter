class RampSlot {
  final DateTime startsAt;
  final DateTime endsAt;
  final int capacity;
  final int booked;
  final int available;
  final bool blocked;

  RampSlot({
    required this.startsAt,
    required this.endsAt,
    required this.capacity,
    required this.booked,
    required this.available,
    required this.blocked,
  });

  bool get isAvailable => available > 0 && !blocked;

  /// Lotado de verdade, e não só fora da antecedência permitida.
  bool get isFull => !blocked && booked >= capacity;

  factory RampSlot.fromJson(Map<String, dynamic> json) {
    return RampSlot(
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      capacity: json['capacity'] as int,
      booked: json['booked'] as int,
      available: json['available'] as int,
      blocked: json['blocked'] as bool? ?? false,
    );
  }
}

class RampAvailability {
  final String rampId;
  final int slotDurationMinutes;
  final List<RampSlot> slots;

  RampAvailability({
    required this.rampId,
    required this.slotDurationMinutes,
    required this.slots,
  });

  factory RampAvailability.fromJson(Map<String, dynamic> json) {
    return RampAvailability(
      rampId: json['rampId'] as String,
      slotDurationMinutes: json['slotDurationMinutes'] as int,
      slots: (json['slots'] as List<dynamic>)
          .map((item) => RampSlot.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
