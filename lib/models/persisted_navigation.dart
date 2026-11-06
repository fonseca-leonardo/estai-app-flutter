import 'dart:convert';

import 'package:latlong2/latlong.dart';

class PersistedNavigation {
  final DateTime startTime;
  final List<LatLng> trackedRoute;
  final List<LatLng> plannedRoute;

  /// Velocidade máxima até o último salvamento, para o resumo da viagem.
  final double? maxSpeedMps;

  const PersistedNavigation({
    required this.startTime,
    required this.trackedRoute,
    required this.plannedRoute,
    this.maxSpeedMps,
  });

  Duration elapsedSince(DateTime now) => now.difference(startTime);

  static String encodePoints(List<LatLng> points) {
    return jsonEncode(
      points.map((p) => [p.latitude, p.longitude]).toList(growable: false),
    );
  }

  static List<LatLng> decodePoints(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<List>()
        .where((e) => e.length == 2)
        .map((e) => LatLng((e[0] as num).toDouble(), (e[1] as num).toDouble()))
        .toList(growable: false);
  }
}
