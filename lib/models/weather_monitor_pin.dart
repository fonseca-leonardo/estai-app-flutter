import 'package:latlong2/latlong.dart';

class WeatherMonitorPin {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  WeatherMonitorPin({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  LatLng get position => LatLng(latitude, longitude);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WeatherMonitorPin.fromMap(Map<String, dynamic> map) {
    return WeatherMonitorPin(
      id: map['id'] as String,
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
