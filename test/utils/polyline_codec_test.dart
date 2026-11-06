import 'package:estai/utils/polyline_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  // Exemplo da documentação do Google Encoded Polyline Algorithm.
  const googleExample = '_p~iF~ps|U_ulLnnqC_mqNvxq`@';
  final googlePoints = [
    const LatLng(38.5, -120.2),
    const LatLng(40.7, -120.95),
    const LatLng(43.252, -126.453),
  ];

  test('encodes the Google reference example', () {
    expect(PolylineCodec.encode(googlePoints), googleExample);
  });

  test('decodes the Google reference example', () {
    final decoded = PolylineCodec.decode(googleExample);
    expect(decoded.length, 3);
    for (var i = 0; i < decoded.length; i++) {
      expect(decoded[i].latitude, closeTo(googlePoints[i].latitude, 1e-5));
      expect(decoded[i].longitude, closeTo(googlePoints[i].longitude, 1e-5));
    }
  });

  test('round-trips a southern hemisphere track', () {
    final track = [
      const LatLng(-23.98412, -46.30012),
      const LatLng(-23.98501, -46.29877),
      const LatLng(-23.99003, -46.29011),
    ];
    final decoded = PolylineCodec.decode(PolylineCodec.encode(track));
    expect(decoded.length, track.length);
    for (var i = 0; i < track.length; i++) {
      expect(decoded[i].latitude, closeTo(track[i].latitude, 1e-5));
      expect(decoded[i].longitude, closeTo(track[i].longitude, 1e-5));
    }
  });

  test('handles an empty track', () {
    expect(PolylineCodec.encode([]), '');
    expect(PolylineCodec.decode(''), isEmpty);
  });
}
