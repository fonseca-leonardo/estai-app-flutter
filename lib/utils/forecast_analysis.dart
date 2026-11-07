import 'dart:math' as math;
import '../models/forecast_metric.dart';
import '../viewmodels/weather_forecast_viewmodel.dart';

enum TrendDirection { rising, falling, steady }

/// Para onde a métrica vai na janela analisada.
class ForecastTrend {
  final TrendDirection direction;
  final double? current;

  /// Pico (subindo) ou vale (caindo) da janela; `null` quando estável.
  final double? target;
  final DateTime? targetAt;

  const ForecastTrend({
    required this.direction,
    this.current,
    this.target,
    this.targetAt,
  });

  static const ForecastTrend unknown = ForecastTrend(
    direction: TrendDirection.steady,
  );

  double get delta => (target ?? current ?? 0) - (current ?? 0);
}

/// Fato mais relevante das próximas horas, para virar uma frase na tela.
class ForecastHeadline {
  final ForecastMetric metric;
  final TrendDirection direction;
  final double value;
  final DateTime at;

  const ForecastHeadline({
    required this.metric,
    required this.direction,
    required this.value,
    required this.at,
  });
}

class DailyForecastSummary {
  final DateTime date;
  final double? minTemperature;
  final double? maxTemperature;
  final double? maxWind;
  final double? dominantWindDirection;
  final double? maxWaveHeight;
  final double? maxRainProbability;

  const DailyForecastSummary({
    required this.date,
    this.minTemperature,
    this.maxTemperature,
    this.maxWind,
    this.dominantWindDirection,
    this.maxWaveHeight,
    this.maxRainProbability,
  });
}

/// Pontos cardeais de 8 direções, de onde vem o vento/onda.
enum CardinalDirection { n, ne, e, se, s, sw, w, nw }

/// Contas da previsão: tendência, frase de resumo, resumo por dia e
/// direções. Funções puras para poderem ser testadas sem a tela.
abstract final class ForecastAnalysis {
  /// Chance de chuva a partir da qual a frase avisa.
  static const double rainAlertProbability = 50;

  /// Hora vigente: a última que já começou (até 1 h atrás) ou, se não
  /// houver, a primeira.
  static ForecastHourData? currentHour(
    List<ForecastHourData> hours,
    DateTime now,
  ) {
    if (hours.isEmpty) return null;
    ForecastHourData? current;
    for (final hour in hours) {
      if (!hour.timeLocal.isAfter(now)) current = hour;
    }
    if (current != null &&
        now.difference(current.timeLocal) <= const Duration(hours: 1)) {
      return current;
    }
    return hours.firstWhere(
      (hour) => hour.timeLocal.isAfter(now),
      orElse: () => hours.last,
    );
  }

  /// Compara o valor atual com o pico e o vale da [window] seguinte.
  static ForecastTrend trend(
    List<ForecastHourData> hours,
    ForecastMetric metric, {
    required DateTime now,
    Duration window = const Duration(hours: 3),
    String? unit,
  }) {
    final current = currentHour(hours, now);
    final currentValue = current == null ? null : metric.valueOf(current);
    if (current == null || currentValue == null) return ForecastTrend.unknown;

    final end = current.timeLocal.add(window);
    ForecastHourData? peak;
    ForecastHourData? trough;
    double? peakValue;
    double? troughValue;
    for (final hour in hours) {
      if (!hour.timeLocal.isAfter(current.timeLocal) ||
          hour.timeLocal.isAfter(end)) {
        continue;
      }
      final value = metric.valueOf(hour);
      if (value == null) continue;
      if (peakValue == null || value > peakValue) {
        peakValue = value;
        peak = hour;
      }
      if (troughValue == null || value < troughValue) {
        troughValue = value;
        trough = hour;
      }
    }

    final threshold = metric.threshold(unit: unit);
    final rise = (peakValue ?? currentValue) - currentValue;
    final fall = currentValue - (troughValue ?? currentValue);

    if (rise >= threshold && rise >= fall) {
      return ForecastTrend(
        direction: TrendDirection.rising,
        current: currentValue,
        target: peakValue,
        targetAt: peak?.timeLocal,
      );
    }
    if (fall >= threshold) {
      return ForecastTrend(
        direction: TrendDirection.falling,
        current: currentValue,
        target: troughValue,
        targetAt: trough?.timeLocal,
      );
    }
    return ForecastTrend(
      direction: TrendDirection.steady,
      current: currentValue,
    );
  }

  /// Primeiro fato relevante das próximas [window] horas, em ordem de
  /// importância para quem navega: vento, ondas, chuva, temperatura.
  static ForecastHeadline? headline(
    List<ForecastHourData> hours, {
    required DateTime now,
    Duration window = const Duration(hours: 12),
    String? windUnit,
  }) {
    for (final metric in const [ForecastMetric.wind, ForecastMetric.waves]) {
      final result = _trendHeadline(hours, metric, now, window, windUnit);
      if (result != null) return result;
    }

    final rain = _rainHeadline(hours, now, window);
    if (rain != null) return rain;

    return _trendHeadline(
      hours,
      ForecastMetric.temperature,
      now,
      window,
      windUnit,
    );
  }

  static ForecastHeadline? _trendHeadline(
    List<ForecastHourData> hours,
    ForecastMetric metric,
    DateTime now,
    Duration window,
    String? windUnit,
  ) {
    final result = trend(
      hours,
      metric,
      now: now,
      window: window,
      unit: metric == ForecastMetric.wind ? windUnit : null,
    );
    final target = result.target;
    final at = result.targetAt;
    if (result.direction == TrendDirection.steady ||
        target == null ||
        at == null) {
      return null;
    }
    return ForecastHeadline(
      metric: metric,
      direction: result.direction,
      value: target,
      at: at,
    );
  }

  static ForecastHeadline? _rainHeadline(
    List<ForecastHourData> hours,
    DateTime now,
    Duration window,
  ) {
    final current = currentHour(hours, now);
    if (current == null) return null;
    final currentValue = ForecastMetric.rain.valueOf(current) ?? 0;
    if (currentValue >= rainAlertProbability) return null;

    final end = current.timeLocal.add(window);
    ForecastHourData? first;
    double peak = 0;
    for (final hour in hours) {
      if (!hour.timeLocal.isAfter(current.timeLocal) ||
          hour.timeLocal.isAfter(end)) {
        continue;
      }
      final value = ForecastMetric.rain.valueOf(hour) ?? 0;
      if (value >= rainAlertProbability) {
        first ??= hour;
        peak = math.max(peak, value);
      }
    }
    if (first == null) return null;
    return ForecastHeadline(
      metric: ForecastMetric.rain,
      direction: TrendDirection.rising,
      value: peak,
      at: first.timeLocal,
    );
  }

  /// Resumo por dia local, a partir do dia de [now], até [days] dias.
  static List<DailyForecastSummary> dailySummaries(
    List<ForecastHourData> hours, {
    required DateTime now,
    int days = 3,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final byDay = <DateTime, List<ForecastHourData>>{};
    for (final hour in hours) {
      final time = hour.timeLocal;
      final day = DateTime(time.year, time.month, time.day);
      if (day.isBefore(today)) continue;
      byDay.putIfAbsent(day, () => []).add(hour);
    }

    final sortedDays = byDay.keys.toList()..sort();
    return [
      for (final day in sortedDays.take(days)) _summarize(day, byDay[day]!),
    ];
  }

  static DailyForecastSummary _summarize(
    DateTime day,
    List<ForecastHourData> hours,
  ) {
    double? minOf(ForecastMetric metric) => _reduce(hours, metric, math.min);
    double? maxOf(ForecastMetric metric) => _reduce(hours, metric, math.max);

    return DailyForecastSummary(
      date: day,
      minTemperature: minOf(ForecastMetric.temperature),
      maxTemperature: maxOf(ForecastMetric.temperature),
      maxWind: maxOf(ForecastMetric.wind),
      dominantWindDirection: dominantDirection([
        for (final hour in hours) hour.weather?.windDirection10m?.toDouble(),
      ]),
      maxWaveHeight: maxOf(ForecastMetric.waves),
      maxRainProbability: maxOf(ForecastMetric.rain),
    );
  }

  static double? _reduce(
    List<ForecastHourData> hours,
    ForecastMetric metric,
    double Function(double, double) combine,
  ) {
    double? result;
    for (final hour in hours) {
      final value = metric.valueOf(hour);
      if (value == null) continue;
      result = result == null ? value : combine(result, value);
    }
    return result;
  }

  static CardinalDirection cardinal(double degrees) {
    final normalized = ((degrees % 360) + 360) % 360;
    final index = ((normalized + 22.5) ~/ 45) % 8;
    return CardinalDirection.values[index];
  }

  /// Média vetorial: 350° e 10° dão 0°, não 180°.
  static double? dominantDirection(List<double?> degrees) {
    var x = 0.0;
    var y = 0.0;
    var count = 0;
    for (final value in degrees) {
      if (value == null) continue;
      final radians = value * math.pi / 180;
      x += math.cos(radians);
      y += math.sin(radians);
      count++;
    }
    if (count == 0 || (x.abs() < 1e-9 && y.abs() < 1e-9)) return null;
    final mean = math.atan2(y, x) * 180 / math.pi;
    return (mean + 360) % 360;
  }
}
