import 'package:latlong2/latlong.dart';

/// Resumo de uma navegação encerrada, ainda em memória. Vira uma entrada
/// `Trip` no diário de bordo se o usuário salvar.
class TripSummary {
  static const double knotsPerMeterPerSecond = 1.943844;

  final DateTime startedAt;
  final DateTime endedAt;
  final List<LatLng> track;
  final double distanceNm;
  final double? maxSpeedKn;

  TripSummary({
    required this.startedAt,
    required this.endedAt,
    required this.track,
    required this.distanceNm,
    this.maxSpeedKn,
  });

  Duration get duration => endedAt.difference(startedAt);

  int get durationMinutes => duration.inMinutes;

  /// Distância percorrida pelo tempo total (inclui paradas).
  double get avgSpeedKn {
    final hours = duration.inSeconds / 3600;
    return hours <= 0 ? 0 : distanceNm / hours;
  }

  LatLng? get startPoint => track.isEmpty ? null : track.first;
  LatLng? get endPoint => track.isEmpty ? null : track.last;
}
