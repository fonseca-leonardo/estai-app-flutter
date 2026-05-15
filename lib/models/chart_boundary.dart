class ChartBoundary {
  final String id;
  final String name;
  final String? link;
  final double minLat;
  final double maxLat;
  final double minLon;
  final double maxLon;

  const ChartBoundary({
    required this.id,
    required this.name,
    required this.link,
    required this.minLat,
    required this.maxLat,
    required this.minLon,
    required this.maxLon,
  });

  factory ChartBoundary.fromJson(Map<String, dynamic> json) {
    final bbox = json['bbox'] as Map<String, dynamic>;
    final rawLink = json['link'] as String?;
    return ChartBoundary(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      link: (rawLink == null || rawLink.isEmpty) ? null : rawLink,
      minLat: (bbox['min_lat'] as num).toDouble(),
      maxLat: (bbox['max_lat'] as num).toDouble(),
      minLon: (bbox['min_lon'] as num).toDouble(),
      maxLon: (bbox['max_lon'] as num).toDouble(),
    );
  }

  bool intersects(
    double otherMinLat,
    double otherMaxLat,
    double otherMinLon,
    double otherMaxLon,
  ) {
    return !(maxLat < otherMinLat ||
        minLat > otherMaxLat ||
        maxLon < otherMinLon ||
        minLon > otherMaxLon);
  }
}
