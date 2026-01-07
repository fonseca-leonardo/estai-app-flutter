import 'dart:convert';
import '../models/tide_station.dart';
import 'maps_api_client.dart';

class TideService {
  final MapsApiClient _apiClient;

  TideService({MapsApiClient? apiClient})
    : _apiClient = apiClient ?? MapsApiClient();

  Future<List<TideStation>> getTideStations() async {
    try {
      final response = await _apiClient.get('/tides');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as List<dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return data.map((item) {
          try {
            return TideStation.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            throw ApiException('Error parsing tide station: $e');
          }
        }).toList();
      } else {
        throw ApiException(
          'Failed to load tide stations: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading tide stations: $e');
    }
  }
}
