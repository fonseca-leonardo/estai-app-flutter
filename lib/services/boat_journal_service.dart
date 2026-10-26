import 'dart:convert';
import '../models/boat_overview.dart';
import '../models/engine_hours_reading.dart';
import '../models/engine_hours_source.dart';
import 'estai_api_client.dart';

String? _extractErrorMessage(String body) {
  try {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final message = jsonData['message'];
    if (message is List) return message.join('\n');
    return message as String?;
  } catch (_) {
    return null;
  }
}

/// Resumo do Diário da Embarcação e horímetro
/// (`/boats/{id}/overview`, `/boats/{id}/engine-hours`).
class BoatJournalService {
  final EstaiApiClient _apiClient;

  BoatJournalService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  Future<BoatOverview> getOverview(String boatId) async {
    try {
      final response = await _apiClient.get('/boats/$boatId/overview');

      if (response.statusCode == 200) {
        return BoatOverview.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load boat overview: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading boat overview: $e');
    }
  }

  Future<EngineHoursReading> addEngineHoursReading({
    required String boatId,
    required double hours,
    DateTime? readAt,
    EngineHoursSource source = EngineHoursSource.manual,
  }) async {
    try {
      final response = await _apiClient.post(
        '/boats/$boatId/engine-hours',
        body: {
          'hours': hours,
          'readAt': (readAt ?? DateTime.now()).toUtc().toIso8601String(),
          'source': source.apiValue,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return EngineHoursReading.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to save engine hours: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error saving engine hours: $e');
    }
  }
}
