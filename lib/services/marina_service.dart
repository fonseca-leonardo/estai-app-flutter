import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/marina.dart';
import 'estai_api_client.dart';

/// Consome os endpoints de marina (`/estai-app/marina`) da API do Estai.
class MarinaService {
  final EstaiApiClient _apiClient;

  MarinaService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Future<Marina> getMarina(String id) async {
    try {
      final response = await _apiClient.get('/marina/$id');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return Marina.fromJson(data);
      } else {
        throw ApiException(
          _extractErrorMessage(response) ??
              'Failed to load marina: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading marina: $e');
    }
  }

  Future<Marina> giveMarinaAccess({
    required String marinaId,
    required List<String> boatIds,
  }) async {
    try {
      final response = await _apiClient.post(
        '/marina-access',
        body: {'marinaId': marinaId, 'boatIds': boatIds},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;
        final marina = data?['marina'] as Map<String, dynamic>?;

        if (marina == null) {
          throw ApiException('Invalid response: marina field is null');
        }

        return Marina.fromJson(marina);
      } else {
        throw ApiException(
          _extractErrorMessage(response) ??
              'Failed to associate marina: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error associating marina: $e');
    }
  }

  String? _extractErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final message = body['message'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) return message.first.toString();
    } catch (_) {
      // corpo não é um JSON com `message`, ignora e usa mensagem genérica
    }
    return null;
  }
}
