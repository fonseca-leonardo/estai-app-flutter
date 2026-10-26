import 'engine_hours_source.dart';

/// Uma leitura do horímetro do motor.
class EngineHoursReading {
  final String id;
  final String boatId;
  final double hours;
  final DateTime readAt;
  final EngineHoursSource source;

  EngineHoursReading({
    required this.id,
    required this.boatId,
    required this.hours,
    required this.readAt,
    required this.source,
  });

  factory EngineHoursReading.fromJson(Map<String, dynamic> json) {
    return EngineHoursReading(
      id: json['id'] as String,
      boatId: json['boatId'] as String,
      hours: (json['hours'] as num).toDouble(),
      readAt: DateTime.parse(json['readAt'] as String),
      source: EngineHoursSource.fromApiValue(json['source'] as String),
    );
  }
}
