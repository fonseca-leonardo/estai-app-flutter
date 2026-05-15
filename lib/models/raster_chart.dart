import 'package:latlong2/latlong.dart';

class RasterChart {
  final String id;
  final String name;
  final String number;
  final String type;
  final String pngPath;
  final int width;
  final int height;
  final LatLng nw;
  final LatLng ne;
  final LatLng se;
  final LatLng sw;
  final List<LatLng> polygon;
  final String projection;
  final bool projectionSupported;
  bool visible;

  RasterChart({
    required this.id,
    required this.name,
    required this.number,
    required this.type,
    required this.pngPath,
    required this.width,
    required this.height,
    required this.nw,
    required this.ne,
    required this.se,
    required this.sw,
    required this.polygon,
    required this.projection,
    required this.projectionSupported,
    this.visible = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'type': type,
    'pngPath': pngPath,
    'width': width,
    'height': height,
    'nw': [nw.latitude, nw.longitude],
    'ne': [ne.latitude, ne.longitude],
    'se': [se.latitude, se.longitude],
    'sw': [sw.latitude, sw.longitude],
    'polygon': polygon.map((p) => [p.latitude, p.longitude]).toList(),
    'projection': projection,
    'projectionSupported': projectionSupported,
    'visible': visible,
  };

  factory RasterChart.fromJson(Map<String, dynamic> json) {
    LatLng pt(dynamic v) {
      final list = v as List<dynamic>;
      return LatLng((list[0] as num).toDouble(), (list[1] as num).toDouble());
    }

    return RasterChart(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as String,
      type: json['type'] as String,
      pngPath: json['pngPath'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      nw: pt(json['nw']),
      ne: pt(json['ne']),
      se: pt(json['se']),
      sw: pt(json['sw']),
      polygon: (json['polygon'] as List<dynamic>).map(pt).toList(),
      projection: json['projection'] as String,
      projectionSupported: json['projectionSupported'] as bool,
      visible: json['visible'] as bool? ?? true,
    );
  }

  LatLng get center {
    final lat = (nw.latitude + se.latitude) / 2;
    final lon = (nw.longitude + se.longitude) / 2;
    return LatLng(lat, lon);
  }
}

class RasterChartSet {
  final String id;
  final String name;
  final String? number;
  final String directory;
  final List<RasterChart> charts;
  final DateTime importedAt;

  RasterChartSet({
    required this.id,
    required this.name,
    required this.number,
    required this.directory,
    required this.charts,
    required this.importedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'directory': directory,
    'charts': charts.map((c) => c.toJson()).toList(),
    'importedAt': importedAt.toIso8601String(),
  };

  factory RasterChartSet.fromJson(Map<String, dynamic> json) {
    return RasterChartSet(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as String?,
      directory: json['directory'] as String,
      charts: (json['charts'] as List<dynamic>)
          .map((c) => RasterChart.fromJson(c as Map<String, dynamic>))
          .toList(),
      importedAt: DateTime.parse(json['importedAt'] as String),
    );
  }
}
