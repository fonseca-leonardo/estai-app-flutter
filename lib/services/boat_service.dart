import 'dart:convert';
import '../models/boat.dart';
import '../models/boat_type.dart';
import 'estai_api_client.dart';

class BoatListResult {
  final List<Boat> items;
  final int total;
  final int page;
  final int limit;

  BoatListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

/// Consome os endpoints de embarcações (`/boats`) da API do Estai.
class BoatService {
  final EstaiApiClient _apiClient;

  BoatService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Future<BoatListResult> getBoats({
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/boats',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        final items = (data['items'] as List<dynamic>)
            .map((item) => Boat.fromJson(item as Map<String, dynamic>))
            .toList();

        return BoatListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          'Failed to load boats: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading boats: $e');
    }
  }

  Future<Boat> getBoat(String id) async {
    try {
      final response = await _apiClient.get('/boats/$id');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return Boat.fromJson(data);
      } else {
        throw ApiException(
          'Failed to load boat: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading boat: $e');
    }
  }

  Future<Boat> createBoat({
    required String name,
    required String model,
    required BoatType type,
    required int year,
    required double length,
  }) async {
    try {
      final response = await _apiClient.post(
        '/boats',
        body: {
          'name': name,
          'model': model,
          'type': type.apiValue,
          'year': year,
          'length': length,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return Boat.fromJson(data);
      } else {
        throw ApiException(
          'Failed to create boat: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating boat: $e');
    }
  }

  Future<Boat> updateBoat(
    String id, {
    String? name,
    String? model,
    BoatType? type,
    int? year,
    double? length,
  }) async {
    try {
      final response = await _apiClient.put(
        '/boats/$id',
        body: {
          'name': ?name,
          'model': ?model,
          if (type != null) 'type': type.apiValue,
          'year': ?year,
          'length': ?length,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return Boat.fromJson(data);
      } else {
        throw ApiException(
          'Failed to update boat: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating boat: $e');
    }
  }

  Future<void> giveBoatToMarina({
    required String boatId,
    required bool access,
  }) async {
    try {
      final response = await _apiClient.post(
        '/boats/give-to-marina',
        body: {'boatId': boatId, 'access': access},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ApiException(
          'Failed to update marina access: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating marina access: $e');
    }
  }

  Future<void> deleteBoat(String id) async {
    try {
      final response = await _apiClient.delete('/boats/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ApiException(
          'Failed to delete boat: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error deleting boat: $e');
    }
  }
}
