class TideStation {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final String latLongText;
  final String url;

  TideStation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.latLongText,
    required this.url,
  });

  factory TideStation.fromJson(Map<String, dynamic> json) {
    return TideStation(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      latLongText: json['lat_long_text'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lon': lon,
      'lat_long_text': latLongText,
      'url': url,
    };
  }
}
