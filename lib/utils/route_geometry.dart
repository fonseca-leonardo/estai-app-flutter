import 'package:latlong2/latlong.dart';

/// Contas simples sobre os pontos de uma rota planejada.
abstract final class RouteGeometry {
  static const double metersPerNauticalMile = 1852.0;

  static double totalDistanceMeters(List<LatLng> points) {
    if (points.length < 2) return 0;
    const distance = Distance();
    var total = 0.0;
    for (var i = 0; i < points.length - 1; i++) {
      total += distance.as(LengthUnit.Meter, points[i], points[i + 1]);
    }
    return total;
  }

  static String formatNauticalMiles(double meters) =>
      '${(meters / metersPerNauticalMile).toStringAsFixed(2)} NM';

  /// Média simples dos pontos; serve para centralizar o mapa.
  static LatLng center(List<LatLng> points) {
    if (points.length == 1) return points.first;
    var lat = 0.0;
    var lng = 0.0;
    for (final point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }
}
