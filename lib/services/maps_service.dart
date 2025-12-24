import 'dart:convert';
import '../models/map_item.dart';
import 'maps_api_client.dart';

class MapsService {
  final MapsApiClient _apiClient;

  MapsService({MapsApiClient? apiClient})
    : _apiClient = apiClient ?? MapsApiClient();

  Future<List<MapItem>> getMaps() async {
    try {
      final response = await _apiClient.get('/maps');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final mapsList = jsonData['maps'] as List<dynamic>;

        return mapsList
            .map((item) => MapItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Failed to load maps: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading maps: $e');
    }
  }
}
