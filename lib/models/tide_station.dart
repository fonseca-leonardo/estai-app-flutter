class TideStation {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final String latLongText;

  TideStation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.latLongText,
  });

  factory TideStation.fromJson(Map<String, dynamic> json) {
    return TideStation(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      latLongText: json['lat_long_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lon': lon,
      'lat_long_text': latLongText,
    };
  }
}

