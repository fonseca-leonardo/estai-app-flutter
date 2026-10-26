import 'package:flutter/foundation.dart';
import '../models/notification_preferences.dart';
import '../services/notification_preferences_service.dart';
import '../services/push_notification_service.dart';

/// Tela de preferências de notificação: canais aceitos no backend e se o
/// sistema permite notificações do app.
class NotificationPreferencesViewModel extends ChangeNotifier {
  NotificationPreferencesViewModel({
    NotificationPreferencesService? preferencesService,
    PushNotificationService? pushNotificationService,
  }) : _preferencesService =
           preferencesService ?? NotificationPreferencesService(),
       _pushNotificationService =
           pushNotificationService ?? PushNotificationService.instance;

  final NotificationPreferencesService _preferencesService;
  final PushNotificationService _pushNotificationService;

  NotificationPreferences? _preferences;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isSendingTest = false;
  bool _systemPermissionGranted = true;
  String? _errorMessage;

  NotificationPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isSendingTest => _isSendingTest;
  bool get systemPermissionGranted => _systemPermissionGranted;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _preferencesService.getPreferences(),
        _pushNotificationService.isAuthorized(),
      ]);
      _preferences = results[0] as NotificationPreferences;
      _systemPermissionGranted = results[1] as bool;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshSystemPermission() async {
    _systemPermissionGranted = await _pushNotificationService.isAuthorized();
    notifyListeners();
  }

  Future<bool> setPushEnabled(bool value) =>
      _save(_preferences?.copyWith(pushEnabled: value));

  Future<bool> setEmailEnabled(bool value) =>
      _save(_preferences?.copyWith(emailEnabled: value));

  Future<bool> _save(NotificationPreferences? updated) async {
    final previous = _preferences;
    if (previous == null || updated == null) return false;

    _preferences = updated;
    _isSaving = true;
    notifyListeners();

    try {
      _preferences = await _preferencesService.updatePreferences(
        pushEnabled: updated.pushEnabled,
        emailEnabled: updated.emailEnabled,
      );
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _preferences = previous;
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendTest() async {
    _isSendingTest = true;
    notifyListeners();

    try {
      await _preferencesService.sendTestNotification();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSendingTest = false;
      notifyListeners();
    }
  }
}
