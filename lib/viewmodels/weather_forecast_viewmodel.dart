import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/marine_forecast.dart';
import '../models/weather_forecast.dart';
import '../services/meteo_service.dart';
import '../services/maps_api_client.dart';

class ForecastHourData {
  final String time;
  final MarineHourlyData? marine;
  final WeatherHourlyData? weather;

  ForecastHourData({required this.time, this.marine, this.weather});
}

class MarineHourlyData {
  final double? waveDirection;
  final double? waveHeight;
  final double? wavePeriod;

  MarineHourlyData({
    required this.waveDirection,
    required this.waveHeight,
    required this.wavePeriod,
  });
}

class WeatherHourlyData {
  final double? dewPoint2m;
  final double? precipitation;
  final int? precipitationProbability;
  final double? pressureMsl;
  final int? relativeHumidity2m;
  final double? temperature2m;
  final int? windDirection10m;
  final double? windGusts10m;
  final double? windSpeed10m;

  WeatherHourlyData({
    required this.dewPoint2m,
    required this.precipitation,
    required this.precipitationProbability,
    required this.pressureMsl,
    required this.relativeHumidity2m,
    required this.temperature2m,
    required this.windDirection10m,
    required this.windGusts10m,
    required this.windSpeed10m,
  });
}

class WeatherForecastViewModel extends ChangeNotifier {
  final MeteoService _meteoService;

  MarineForecast? _marineForecast;
  WeatherForecast? _weatherForecast;
  List<ForecastHourData> _forecastData = [];
  bool _isLoading = false;
  String? _errorMessage;
  double? _lastFetchLatitude;
  double? _lastFetchLongitude;

  WeatherForecastViewModel({MeteoService? meteoService})
    : _meteoService = meteoService ?? MeteoService();

  MarineForecast? get marineForecast => _marineForecast;
  WeatherForecast? get weatherForecast => _weatherForecast;
  List<ForecastHourData> get forecastData => _forecastData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double? get lastFetchLatitude => _lastFetchLatitude;
  double? get lastFetchLongitude => _lastFetchLongitude;

  Future<void> fetchForecasts(double latitude, double longitude) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final marineFuture = _meteoService.getMarineForecast(latitude, longitude);
      final weatherFuture = _meteoService.getWeatherForecast(
        latitude,
        longitude,
      );

      final results = await Future.wait([marineFuture, weatherFuture]);

      _marineForecast = results[0] as MarineForecast;
      _weatherForecast = results[1] as WeatherForecast;

      _lastFetchLatitude = latitude;
      _lastFetchLongitude = longitude;

      _organizeForecastData();

      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      debugPrint(
        '[WeatherForecastViewModel] ApiException: ${e.message}, StatusCode: ${e.statusCode}, URI: ${e.uri}',
      );
      _errorMessage = 'errorLoadingForecast:${e.statusCode ?? e.message}';
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        '[WeatherForecastViewModel] Unexpected error: $e\nStackTrace: $stackTrace',
      );
      _errorMessage = 'errorLoadingForecast:$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _organizeForecastData() {
    _forecastData = [];

    if (_marineForecast == null && _weatherForecast == null) {
      return;
    }

    final marineTimes = _marineForecast?.hourly.time ?? [];
    final weatherTimes = _weatherForecast?.hourly.time ?? [];

    final allTimes = <String>{};
    allTimes.addAll(marineTimes);
    allTimes.addAll(weatherTimes);

    final sortedTimes = allTimes.toList()..sort();

    final now = DateTime.now();
    final minTime = now.subtract(const Duration(hours: 1));
    final maxTime = now.add(const Duration(hours: 72));

    for (final timeStr in sortedTimes) {
      try {
        final timeUtc = DateTime.parse(timeStr + 'Z').toUtc();
        final time = timeUtc.toLocal();
        if (time.isBefore(minTime) || time.isAfter(maxTime)) {
          continue;
        }

        MarineHourlyData? marineData;
        WeatherHourlyData? weatherData;

        final marineIndex = marineTimes.indexOf(timeStr);
        if (marineIndex != -1 && _marineForecast != null) {
          final hourly = _marineForecast!.hourly;
          if (marineIndex < hourly.waveDirection.length &&
              marineIndex < hourly.waveHeight.length &&
              marineIndex < hourly.wavePeriod.length) {
            marineData = MarineHourlyData(
              waveDirection: hourly.waveDirection[marineIndex],
              waveHeight: hourly.waveHeight[marineIndex],
              wavePeriod: hourly.wavePeriod[marineIndex],
            );
          }
        }

        final weatherIndex = weatherTimes.indexOf(timeStr);
        if (weatherIndex != -1 && _weatherForecast != null) {
          final hourly = _weatherForecast!.hourly;
          if (weatherIndex < hourly.dewPoint2m.length &&
              weatherIndex < hourly.precipitation.length &&
              weatherIndex < hourly.precipitationProbability.length &&
              weatherIndex < hourly.pressureMsl.length &&
              weatherIndex < hourly.relativeHumidity2m.length &&
              weatherIndex < hourly.temperature2m.length &&
              weatherIndex < hourly.windDirection10m.length &&
              weatherIndex < hourly.windGusts10m.length &&
              weatherIndex < hourly.windSpeed10m.length) {
            weatherData = WeatherHourlyData(
              dewPoint2m: hourly.dewPoint2m[weatherIndex],
              precipitation: hourly.precipitation[weatherIndex],
              precipitationProbability:
                  hourly.precipitationProbability[weatherIndex],
              pressureMsl: hourly.pressureMsl[weatherIndex],
              relativeHumidity2m: hourly.relativeHumidity2m[weatherIndex],
              temperature2m: hourly.temperature2m[weatherIndex],
              windDirection10m: hourly.windDirection10m[weatherIndex],
              windGusts10m: hourly.windGusts10m[weatherIndex],
              windSpeed10m: hourly.windSpeed10m[weatherIndex],
            );
          }
        }

        if (marineData != null || weatherData != null) {
          _forecastData.add(
            ForecastHourData(
              time: timeStr,
              marine: marineData,
              weather: weatherData,
            ),
          );
        }
      } catch (e) {
        continue;
      }
    }

    _forecastData.sort((a, b) => a.time.compareTo(b.time));
  }

  bool shouldFetchForecasts(double latitude, double longitude) {
    if (_lastFetchLatitude == null || _lastFetchLongitude == null) {
      return true;
    }

    const distance = Distance();
    final distanceInMeters = distance.as(
      LengthUnit.Meter,
      LatLng(_lastFetchLatitude!, _lastFetchLongitude!),
      LatLng(latitude, longitude),
    );

    return distanceInMeters > 1000;
  }

  void clearData() {
    _marineForecast = null;
    _weatherForecast = null;
    _forecastData = [];
    _errorMessage = null;
    _lastFetchLatitude = null;
    _lastFetchLongitude = null;
    notifyListeners();
  }
}
