import 'dart:convert';
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

/// Registra o aparelho (token FCM) no backend para que ele possa enviar os
/// lembretes por push (`/devices`).
class DeviceService {
  final EstaiApiClient _apiClient;

  DeviceService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  /// [locale] define o idioma do push/e-mail; [timezone] (IANA) faz o backend
  /// avisar no horário local do usuário.
  Future<void> registerDevice({
    required String token,
    required String platform,
    required String locale,
    String? timezone,
  }) async {
    try {
      final response = await _apiClient.post(
        '/devices',
        body: {
          'token': token,
          'platform': platform,
          'locale': locale,
          'timezone': ?timezone,
        },
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to register device: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error registering device: $e');
    }
  }

  Future<void> unregisterDevice(String token) async {
    try {
      final response = await _apiClient.delete(
        '/devices/${Uri.encodeComponent(token)}',
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 404) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to unregister device: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error unregistering device: $e');
    }
  }
}
