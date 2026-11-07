import 'package:estai/models/forecast_metric.dart';
import 'package:estai/models/marine_forecast.dart';
import 'package:estai/models/weather_forecast.dart';
import 'package:estai/services/meteo_service.dart';
import 'package:estai/utils/forecast_analysis.dart';
import 'package:estai/viewmodels/weather_forecast_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

/// Horas no formato da API: UTC sem "Z".
String apiTime(DateTime utc) => utc.toIso8601String().substring(0, 16);

class FakeMeteoService extends MeteoService {
  FakeMeteoService(this.times, {this.windUnit = 'kn'});

  final List<String> times;
  final String windUnit;

  @override
  Future<MarineForecast> getMarineForecast(double lat, double lon) async {
    return MarineForecast.fromJson({
      'data': {
        'hourly': {
          'time': times,
          'wave_height': [for (var i = 0; i < times.length; i++) 1.0],
          'wave_period': [for (var i = 0; i < times.length; i++) 8.0],
          'wave_direction': [for (var i = 0; i < times.length; i++) 120.0],
        },
        'hourly_units': {'wave_height': 'm', 'wave_period': 's'},
      },
    });
  }

  @override
  Future<WeatherForecast> getWeatherForecast(double lat, double lon) async {
    final n = times.length;
    return WeatherForecast.fromJson({
      'data': {
        'hourly': {
          'time': times,
          'temperature_2m': [for (var i = 0; i < n; i++) 24.0],
          'dew_point_2m': [for (var i = 0; i < n; i++) 18.0],
          'relative_humidity_2m': [for (var i = 0; i < n; i++) 70],
          'pressure_msl': [for (var i = 0; i < n; i++) 1013.0],
          'precipitation': [for (var i = 0; i < n; i++) 0.0],
          'precipitation_probability': [for (var i = 0; i < n; i++) 0],
          'wind_direction_10m': [for (var i = 0; i < n; i++) 45],
          'wind_gusts_10m': [for (var i = 0; i < n; i++) 15.0 + i],
          'wind_speed_10m': [for (var i = 0; i < n; i++) 10.0 + i * 2],
        },
        'hourly_units': {
          'wind_speed_10m': windUnit,
          'temperature_2m': '°C',
          'pressure_msl': 'hPa',
        },
      },
    });
  }
}

void main() {
  final nowUtc = DateTime.utc(2026, 11, 7, 13, 20);
  final now = nowUtc.toLocal();
  final times = [
    for (var i = 0; i < 24; i++)
      apiTime(DateTime.utc(2026, 11, 7, 13).add(Duration(hours: i))),
  ];

  WeatherForecastViewModel create({String windUnit = 'kn'}) =>
      WeatherForecastViewModel(
        meteoService: FakeMeteoService(times, windUnit: windUnit),
        clock: () => now,
      );

  test('derives current hour, trends, headline and units', () async {
    final viewModel = create();
    await viewModel.fetchForecasts(-23, -45);

    expect(viewModel.forecastData, hasLength(24));
    expect(
      viewModel.currentHour?.timeLocal,
      DateTime.utc(2026, 11, 7, 13).toLocal(),
    );
    expect(viewModel.windUnit, 'kn');
    expect(viewModel.waveUnit, 'm');
    expect(viewModel.unitFor(ForecastMetric.rain), '%');
    expect(
      viewModel.trendFor(ForecastMetric.wind).direction,
      TrendDirection.rising,
    );
    expect(
      viewModel.trendFor(ForecastMetric.temperature).direction,
      TrendDirection.steady,
    );
    expect(viewModel.headline?.metric, ForecastMetric.wind);
    expect(viewModel.dailySummaries, isNotEmpty);
  });

  test('falls back to defaults when units are missing', () async {
    final viewModel = create(windUnit: '');
    await viewModel.fetchForecasts(-23, -45);

    expect(viewModel.windUnit, 'kn');
    expect(viewModel.precipitationUnit, 'mm');
  });

  test('selection resets on a new fetch', () async {
    final viewModel = create();
    await viewModel.fetchForecasts(-23, -45);

    final picked = viewModel.forecastData[3].timeLocal;
    viewModel.selectMetric(ForecastMetric.waves);
    viewModel.selectTime(picked);
    expect(viewModel.selectedHour?.timeLocal, picked);

    await viewModel.fetchForecasts(-23, -45);
    expect(viewModel.selectedMetric, ForecastMetric.wind);
    expect(viewModel.selectedTime, isNull);
    expect(viewModel.selectedHour, same(viewModel.currentHour));
  });
}
