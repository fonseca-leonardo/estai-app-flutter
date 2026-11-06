import 'package:latlong2/latlong.dart';

/// Algoritmo de polyline do Google (precisão 5), usado para mandar o trajeto
/// da viagem compacto para a API (`track`).
class PolylineCodec {
  PolylineCodec._();

  static const double _factor = 1e5;

  static String encode(List<LatLng> points) {
    final buffer = StringBuffer();
    var lastLat = 0;
    var lastLng = 0;
    for (final point in points) {
      final lat = (point.latitude * _factor).round();
      final lng = (point.longitude * _factor).round();
      _encodeValue(lat - lastLat, buffer);
      _encodeValue(lng - lastLng, buffer);
      lastLat = lat;
      lastLng = lng;
    }
    return buffer.toString();
  }

  static List<LatLng> decode(String encoded) {
    final points = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;
    while (index < encoded.length) {
      final latResult = _decodeValue(encoded, index);
      index = latResult.$2;
      final lngResult = _decodeValue(encoded, index);
      index = lngResult.$2;
      lat += latResult.$1;
      lng += lngResult.$1;
      points.add(LatLng(lat / _factor, lng / _factor));
    }
    return points;
  }

  static void _encodeValue(int value, StringBuffer buffer) {
    var shifted = value < 0 ? ~(value << 1) : value << 1;
    while (shifted >= 0x20) {
      buffer.writeCharCode((0x20 | (shifted & 0x1f)) + 63);
      shifted >>= 5;
    }
    buffer.writeCharCode(shifted + 63);
  }

  /// Retorna o valor e o índice seguinte.
  static (int, int) _decodeValue(String encoded, int start) {
    var index = start;
    var result = 0;
    var shift = 0;
    int byte;
    do {
      byte = encoded.codeUnitAt(index++) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20 && index < encoded.length);
    final value = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
    return (value, index);
  }
}
