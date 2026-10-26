import 'dart:convert';
import '../models/notification_preferences.dart';
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

/// Preferências de notificação do usuário (`/me/notification-preferences`).
class NotificationPreferencesService {
  final EstaiApiClient _apiClient;

  NotificationPreferencesService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Map<String, dynamic> _readData(String body) {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    final data = jsonData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ApiException('Invalid response: data field is null');
    }
    return data;
  }

  Future<NotificationPreferences> getPreferences() async {
    try {
      final response = await _apiClient.get('/me/notification-preferences');

      if (response.statusCode == 200) {
        return NotificationPreferences.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load notification preferences: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading notification preferences: $e');
    }
  }

  Future<NotificationPreferences> updatePreferences({
    required bool pushEnabled,
    required bool emailEnabled,
  }) async {
    try {
      final response = await _apiClient.put(
        '/me/notification-preferences',
        body: {'pushEnabled': pushEnabled, 'emailEnabled': emailEnabled},
      );

      if (response.statusCode == 200) {
        return NotificationPreferences.fromJson(_readData(response.body));
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to update notification preferences: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error updating notification preferences: $e');
    }
  }

  /// Pede ao backend um push/e-mail de teste pelos canais ativos.
  Future<void> sendTestNotification() async {
    try {
      final response = await _apiClient.post('/me/notifications/test');

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 202) {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to send test notification: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error sending test notification: $e');
    }
  }
}
