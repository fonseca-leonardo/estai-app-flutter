import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Reduz os pontos do trajeto (Douglas-Peucker) mantendo o desenho: tira os
/// pontos que estão a menos de [toleranceMeters] da reta entre os vizinhos.
class TrackSimplifier {
  TrackSimplifier._();

  static const double _earthRadiusMeters = 6371000;

  static List<LatLng> simplify(
    List<LatLng> points, {
    double toleranceMeters = 10,
  }) {
    if (points.length < 3) return List.of(points);

    // Projeção equiretangular local: em trajetos de barco o erro é
    // desprezível e as distâncias ficam em metros.
    final origin = points.first;
    final cosLat = math.cos(origin.latitude * math.pi / 180);
    final projected = [
      for (final point in points)
        math.Point<double>(
          (point.longitude - origin.longitude) *
              math.pi /
              180 *
              _earthRadiusMeters *
              cosLat,
          (point.latitude - origin.latitude) *
              math.pi /
              180 *
              _earthRadiusMeters,
        ),
    ];

    final keep = List<bool>.filled(points.length, false);
    keep[0] = true;
    keep[points.length - 1] = true;

    // Iterativo para não estourar a pilha em trajetos longos.
    final stack = <(int, int)>[(0, points.length - 1)];
    while (stack.isNotEmpty) {
      final (start, end) = stack.removeLast();
      var maxDistance = 0.0;
      var maxIndex = -1;
      for (var i = start + 1; i < end; i++) {
        final distance = _distanceToSegment(
          projected[i],
          projected[start],
          projected[end],
        );
        if (distance > maxDistance) {
          maxDistance = distance;
          maxIndex = i;
        }
      }
      if (maxIndex != -1 && maxDistance > toleranceMeters) {
        keep[maxIndex] = true;
        stack
          ..add((start, maxIndex))
          ..add((maxIndex, end));
      }
    }

    return [
      for (var i = 0; i < points.length; i++)
        if (keep[i]) points[i],
    ];
  }

  static double _distanceToSegment(
    math.Point<double> p,
    math.Point<double> a,
    math.Point<double> b,
  ) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) return p.distanceTo(a);
    final t = (((p.x - a.x) * dx + (p.y - a.y) * dy) / lengthSquared).clamp(
      0.0,
      1.0,
    );
    return p.distanceTo(math.Point(a.x + t * dx, a.y + t * dy));
  }
}
