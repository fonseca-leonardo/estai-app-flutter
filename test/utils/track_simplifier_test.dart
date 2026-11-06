import 'package:estai/utils/track_simplifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  test('removes points that lie on a straight line', () {
    // ~1 km para leste, com pontos intermediários alinhados.
    final track = [
      for (var i = 0; i <= 10; i++) LatLng(-23.98, -46.30 + i * 0.001),
    ];

    final simplified = TrackSimplifier.simplify(track);

    expect(simplified, [track.first, track.last]);
  });

  test('keeps the corner of an L-shaped track', () {
    final track = [
      const LatLng(-23.980, -46.300),
      const LatLng(-23.980, -46.295),
      const LatLng(-23.980, -46.290),
      const LatLng(-23.985, -46.290),
      const LatLng(-23.990, -46.290),
    ];

    final simplified = TrackSimplifier.simplify(track);

    expect(simplified, [track[0], track[2], track[4]]);
  });

  test('returns short tracks unchanged', () {
    final track = [const LatLng(0, 0), const LatLng(0, 1)];
    expect(TrackSimplifier.simplify(track), track);
  });
}
