import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../models/push_notification_target.dart';
import 'device_service.dart';
import 'estai_api_client.dart';

/// Push dos lembretes enviados pelo backend (FCM).
///
/// O app não agenda nada: só registra o token do aparelho em `/devices`,
/// exibe o push quando o app está aberto e avisa, por [openedTargets], para
/// onde levar o usuário quando ele toca na notificação.
class PushNotificationService {
  PushNotificationService._();
  static final instance = PushNotificationService._();

  static const _channelId = 'reminders';
  static const _androidIcon = 'ic_notification_anchor';

  final DeviceService _deviceService = DeviceService();
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _openedTargets = StreamController<PushNotificationTarget>.broadcast();

  bool _initialized = false;
  String? _registeredToken;

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  /// Pushes tocados com o app aberto ou em segundo plano. O de abertura do
  /// app vem de [getInitialTarget].
  Stream<PushNotificationTarget> get openedTargets => _openedTargets.stream;

  /// Chamado na inicialização do app, depois do
  /// `AnchorAlarmNotificationService.setupChannel()`: o plugin de notificações
  /// locais é compartilhado e esta inicialização acrescenta o tratamento do
  /// toque. Não pede permissão.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestCriticalPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) =>
          _emitPayload(response.payload),
    );

    final l10n = _platformLocalizations();
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              _channelId,
              l10n.reminderChannelName,
              description: l10n.reminderChannelDescription,
              importance: Importance.high,
            ),
          );
    }

    // No iOS o próprio sistema mostra o push com o app aberto; no Android
    // ele é reexibido como notificação local em [_showForeground].
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _emitData(message.data),
    );
    _messaging.onTokenRefresh.listen((token) {
      if (EstaiApiClient.instance.isAuthenticated) _register(token);
    });
  }

  /// Destino do push que abriu o app a partir do estado fechado, se houver.
  Future<PushNotificationTarget?> getInitialTarget() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) {
        return PushNotificationTarget.fromData(message.data);
      }

      final launch = await _localNotifications
          .getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp == true) {
        return _decodePayload(launch?.notificationResponse?.payload);
      }
    } catch (e) {
      debugPrint('[PushNotificationService] initial message error: $e');
    }
    return null;
  }

  /// Envia o token ao backend se o usuário já autorizou notificações. Chamar
  /// depois que a sessão do Estai estiver pronta. Nunca pede permissão.
  Future<void> syncToken() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      if (!_isAuthorized(settings.authorizationStatus)) return;

      // No iOS o token FCM depende do token APNs, que pode demorar a chegar.
      if (Platform.isIOS && await _messaging.getAPNSToken() == null) return;

      final token = await _messaging.getToken();
      if (token == null || token == _registeredToken) return;
      await _register(token);
    } catch (e) {
      debugPrint('[PushNotificationService] sync token error: $e');
    }
  }

  /// Remove o aparelho do backend (usar no logout, antes de limpar a sessão).
  Future<void> unregister() async {
    final token = _registeredToken;
    if (token == null) return;
    try {
      await _deviceService.unregisterDevice(token);
    } catch (e) {
      debugPrint('[PushNotificationService] unregister error: $e');
    }
    _registeredToken = null;
  }

  /// Explica por que o app quer notificar e pede a permissão ao sistema.
  ///
  /// Chamar em contexto, quando o usuário liga um lembrete por push — nunca
  /// na abertura do app. Retorna se as notificações ficaram autorizadas.
  Future<bool> requestPermissionIfNeeded(BuildContext context) async {
    final settings = await _messaging.getNotificationSettings();
    if (_isAuthorized(settings.authorizationStatus)) {
      await syncToken();
      return true;
    }
    if (!context.mounted) return false;

    final blocked = Platform.isAndroid
        ? await Permission.notification.isPermanentlyDenied
        : settings.authorizationStatus == AuthorizationStatus.denied;
    if (!context.mounted) return false;
    if (blocked) {
      await _showBlockedDialog(context);
      return false;
    }

    final shouldRequest = await _showRationaleDialog(context);
    if (!shouldRequest) return false;

    final result = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted = _isAuthorized(result.authorizationStatus);
    if (granted) {
      await syncToken();
    } else if (context.mounted && Platform.isIOS) {
      await _showBlockedDialog(context);
    }
    return granted;
  }

  /// Se o sistema hoje permite notificações do app.
  Future<bool> isAuthorized() async {
    final settings = await _messaging.getNotificationSettings();
    return _isAuthorized(settings.authorizationStatus);
  }

  bool _isAuthorized(AuthorizationStatus status) =>
      status == AuthorizationStatus.authorized ||
      status == AuthorizationStatus.provisional;

  Future<void> _register(String token) async {
    try {
      String? timezone;
      try {
        timezone = (await FlutterTimezone.getLocalTimezone()).identifier;
      } catch (_) {
        timezone = null;
      }
      await _deviceService.registerDevice(
        token: token,
        platform: Platform.isIOS ? 'ios' : 'android',
        locale: PlatformDispatcher.instance.locale.languageCode,
        timezone: timezone,
      );
      _registeredToken = token;
    } catch (e) {
      debugPrint('[PushNotificationService] register error: $e');
    }
  }

  Future<void> _showForeground(RemoteMessage message) async {
    if (!Platform.isAndroid) return;
    final notification = message.notification;
    if (notification == null) return;

    final l10n = _platformLocalizations();
    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l10n.reminderChannelName,
          channelDescription: l10n.reminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: _androidIcon,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _emitData(Map<String, dynamic> data) {
    final target = PushNotificationTarget.fromData(data);
    if (target != null) _openedTargets.add(target);
  }

  void _emitPayload(String? payload) {
    final target = _decodePayload(payload);
    if (target != null) _openedTargets.add(target);
  }

  PushNotificationTarget? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      return PushNotificationTarget.fromData(
        jsonDecode(payload) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  AppLocalizations _platformLocalizations() {
    final languageCode = PlatformDispatcher.instance.locale.languageCode;
    return lookupAppLocalizations(Locale(languageCode == 'en' ? 'en' : 'pt'));
  }

  static Future<bool> _showRationaleDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: Row(
          spacing: 8,
          children: [
            const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 20,
            ),
            Flexible(
              child: Text(
                l10n.pushPermissionRationaleTitle,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.pushPermissionRationaleBody,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.notNow,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.backgroundLocationAllow),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<void> _showBlockedDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: Row(
          spacing: 8,
          children: [
            const Icon(Icons.notifications_off, color: Colors.white, size: 20),
            Flexible(
              child: Text(
                l10n.pushPermissionBlockedTitle,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.pushPermissionBlockedBody,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              openAppSettings();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.openAppSettings),
          ),
        ],
      ),
    );
  }
}
