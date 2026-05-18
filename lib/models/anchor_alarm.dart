class AnchorAlarm {
  final double latitude;
  final double longitude;
  final double radiusMeters;

  const AnchorAlarm({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  Map<String, dynamic> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
    'radiusMeters': radiusMeters,
  };

  factory AnchorAlarm.fromMap(Map<String, dynamic> map) => AnchorAlarm(
    latitude: (map['latitude'] as num).toDouble(),
    longitude: (map['longitude'] as num).toDouble(),
    radiusMeters: (map['radiusMeters'] as num).toDouble(),
  );
}
