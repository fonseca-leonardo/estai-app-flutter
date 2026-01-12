import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/marine_forecast.dart';
import '../models/weather_forecast.dart';
import 'maps_api_client.dart';

class MeteoService {
  final MapsApiClient _apiClient;

  MeteoService({MapsApiClient? apiClient})
    : _apiClient =
          apiClient ?? MapsApiClient(baseUrl: 'https://apps.estai.com.br');

  Future<MarineForecast> getMarineForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _apiClient.get(
        '/meteo/marine',
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        if (jsonData['success'] != true) {
          debugPrint(
            '[MeteoService] Marine forecast API returned success: false. Response: ${response.body}',
          );
          throw ApiException('API returned success: false');
        }

        try {
          return MarineForecast.fromJson(jsonData);
        } catch (e) {
          debugPrint(
            '[MeteoService] Error parsing marine forecast: $e. Response body: ${response.body}',
          );
          throw ApiException('Error parsing marine forecast: $e');
        }
      } else {
        debugPrint(
          '[MeteoService] Marine forecast API error. Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw ApiException(
          'Failed to load marine forecast: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('[MeteoService] Unexpected error loading marine forecast: $e');
      throw ApiException('Error loading marine forecast: $e');
    }
  }

  Future<WeatherForecast> getWeatherForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _apiClient.get(
        '/meteo/forecast',
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        if (jsonData['success'] != true) {
          debugPrint(
            '[MeteoService] Weather forecast API returned success: false. Response: ${response.body}',
          );
          throw ApiException('API returned success: false');
        }

        try {
          return WeatherForecast.fromJson(jsonData);
        } catch (e) {
          debugPrint(
            '[MeteoService] Error parsing weather forecast: $e. Response body: ${response.body}',
          );
          throw ApiException('Error parsing weather forecast: $e');
        }
      } else {
        debugPrint(
          '[MeteoService] Weather forecast API error. Status: ${response.statusCode}, Body: ${response.body}',
        );
        throw ApiException(
          'Failed to load weather forecast: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint(
        '[MeteoService] Unexpected error loading weather forecast: $e',
      );
      throw ApiException('Error loading weather forecast: $e');
    }
  }
}
