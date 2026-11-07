import 'package:estai/models/forecast_metric.dart';
import 'package:estai/utils/forecast_analysis.dart';
import 'package:estai/viewmodels/weather_forecast_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

final DateTime start = DateTime(2026, 11, 7, 10);

ForecastHourData hour(
  int offset, {
  double? wind,
  double? gust,
  int? windDir,
  double? wave,
  double? temp,
  int? rain,
}) {
  return ForecastHourData(
    time: 'unused',
    timeLocal: start.add(Duration(hours: offset)),
    weather: WeatherHourlyData(
      dewPoint2m: null,
      precipitation: null,
      precipitationProbability: rain,
      pressureMsl: null,
      relativeHumidity2m: null,
      temperature2m: temp,
      windDirection10m: windDir,
      windGusts10m: gust,
      windSpeed10m: wind,
    ),
    marine: MarineHourlyData(
      waveDirection: null,
      waveHeight: wave,
      wavePeriod: null,
    ),
  );
}

void main() {
  final now = start.add(const Duration(minutes: 20));

  group('currentHour', () {
    test('uses the hour that already started', () {
      final hours = [hour(0), hour(1), hour(2)];
      expect(ForecastAnalysis.currentHour(hours, now), same(hours[0]));
    });

    test('falls back to the next hour when the last one is too old', () {
      final hours = [hour(-5), hour(1)];
      expect(ForecastAnalysis.currentHour(hours, now), same(hours[1]));
    });
  });

  group('trend', () {
    test('rising when the peak clears the threshold', () {
      final hours = [hour(0, wind: 10), hour(1, wind: 12), hour(2, wind: 15)];
      final trend = ForecastAnalysis.trend(
        hours,
        ForecastMetric.wind,
        now: now,
      );
      expect(trend.direction, TrendDirection.rising);
      expect(trend.target, 15);
      expect(trend.targetAt, hours[2].timeLocal);
    });

    test('falling when the trough clears the threshold', () {
      final hours = [hour(0, temp: 26), hour(2, temp: 24), hour(3, temp: 23)];
      final trend = ForecastAnalysis.trend(
        hours,
        ForecastMetric.temperature,
        now: now,
      );
      expect(trend.direction, TrendDirection.falling);
      expect(trend.target, 23);
    });

    test('steady inside the threshold and ignores hours past the window', () {
      final hours = [
        hour(0, wave: 1.0),
        hour(2, wave: 1.2),
        hour(5, wave: 3.0),
      ];
      final trend = ForecastAnalysis.trend(
        hours,
        ForecastMetric.waves,
        now: now,
      );
      expect(trend.direction, TrendDirection.steady);
    });

    test('wind threshold follows the API unit', () {
      final hours = [hour(0, wind: 10), hour(1, wind: 14)];
      expect(
        ForecastAnalysis.trend(hours, ForecastMetric.wind, now: now).direction,
        TrendDirection.rising,
      );
      expect(
        ForecastAnalysis.trend(
          hours,
          ForecastMetric.wind,
          now: now,
          unit: 'km/h',
        ).direction,
        TrendDirection.steady,
      );
    });

    test('unknown when the current value is missing', () {
      final hours = [hour(0), hour(1, wind: 20)];
      final trend = ForecastAnalysis.trend(
        hours,
        ForecastMetric.wind,
        now: now,
      );
      expect(trend.direction, TrendDirection.steady);
      expect(trend.current, isNull);
    });
  });

  group('headline', () {
    test('wind wins over waves', () {
      final hours = [hour(0, wind: 8, wave: 0.5), hour(6, wind: 20, wave: 2.0)];
      final headline = ForecastAnalysis.headline(hours, now: now);
      expect(headline?.metric, ForecastMetric.wind);
      expect(headline?.value, 20);
    });

    test('rain uses the first hour above the alert probability', () {
      final hours = [
        hour(0, wind: 8, rain: 10),
        hour(3, wind: 8, rain: 60),
        hour(5, wind: 8, rain: 80),
      ];
      final headline = ForecastAnalysis.headline(hours, now: now);
      expect(headline?.metric, ForecastMetric.rain);
      expect(headline?.at, hours[1].timeLocal);
      expect(headline?.value, 80);
    });

    test('null when nothing changes', () {
      final hours = [
        hour(0, wind: 8, wave: 0.5, temp: 24, rain: 0),
        hour(6, wind: 9, wave: 0.6, temp: 24.5, rain: 5),
      ];
      expect(ForecastAnalysis.headline(hours, now: now), isNull);
    });
  });

  test('daily summaries group by local day', () {
    final hours = [
      hour(0, temp: 20, wind: 10, windDir: 350, rain: 10),
      hour(4, temp: 26, wind: 18, windDir: 10, rain: 40, wave: 1.2),
      hour(16, temp: 18, wind: 6, windDir: 90),
    ];
    final days = ForecastAnalysis.dailySummaries(hours, now: now);

    expect(days, hasLength(2));
    expect(days[0].date, DateTime(2026, 11, 7));
    expect(days[0].minTemperature, 20);
    expect(days[0].maxTemperature, 26);
    expect(days[0].maxWind, 18);
    expect(days[0].maxWaveHeight, 1.2);
    expect(days[0].maxRainProbability, 40);
    expect(days[0].dominantWindDirection, closeTo(0, 0.001));
    expect(days[1].date, DateTime(2026, 11, 8));
  });

  group('directions', () {
    test('cardinal buckets', () {
      expect(ForecastAnalysis.cardinal(0), CardinalDirection.n);
      expect(ForecastAnalysis.cardinal(350), CardinalDirection.n);
      expect(ForecastAnalysis.cardinal(45), CardinalDirection.ne);
      expect(ForecastAnalysis.cardinal(180), CardinalDirection.s);
      expect(ForecastAnalysis.cardinal(-90), CardinalDirection.w);
    });

    test('dominant direction is a vector mean', () {
      expect(ForecastAnalysis.dominantDirection([350, 10]), closeTo(0, 0.001));
      expect(ForecastAnalysis.dominantDirection([80, 100]), closeTo(90, 0.001));
      expect(ForecastAnalysis.dominantDirection([null]), isNull);
    });
  });
}
