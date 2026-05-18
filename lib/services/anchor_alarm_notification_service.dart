import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';

class AnchorAlarmNotificationService {
  AnchorAlarmNotificationService._();
  static final instance = AnchorAlarmNotificationService._();

  static const _channelId = 'anchor_alarm';
  static const _notificationId = 9001;
  static const _soundAsset = 'anchor_alarm.wav';

  final _notifications = FlutterLocalNotificationsPlugin();
  final _player = AudioPlayer();
  bool _channelReady = false;
  bool _pluginInitialized = false;

  /// Called at app startup — only creates the notification channel, no permission dialog.
  Future<void> setupChannel() async {
    if (_channelReady) return;

    const androidSettings = AndroidInitializationSettings(
      'ic_notification_anchor',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestCriticalPermission: false,
    );

    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    _pluginInitialized = true;

    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              'Alarme de Âncora',
              description: 'Notificações do alarme de âncora',
              importance: Importance.max,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('anchor_alarm'),
              enableVibration: true,
              enableLights: true,
            ),
          );
    }

    _channelReady = true;
  }

  /// Shows a rationale dialog explaining why the notification permission is needed,
  /// then requests the permission from the OS.
  ///
  /// This should be called in context, when the user explicitly activates the
  /// anchor alarm feature — never at app startup.
  static Future<void> requestPermissionIfNeeded(BuildContext context) async {
    if (Platform.isAndroid) {
      await _requestAndroidPermission(context);
    } else if (Platform.isIOS) {
      await _requestIOSPermission(context);
    }
  }

  static Future<void> _requestAndroidPermission(BuildContext context) async {
    final status = await Permission.notification.status;
    if (status.isGranted) return;

    if (!context.mounted) return;

    if (status.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(context);
      return;
    }

    final shouldRequest = await _showRationaleDialog(context);
    if (!shouldRequest) return;

    await Permission.notification.request();
  }

  static Future<void> _requestIOSPermission(BuildContext context) async {
    final iosPlugin = instance._notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final current = await iosPlugin?.checkPermissions();
    if (current?.isEnabled == true) return;

    if (!context.mounted) return;

    final shouldRequest = await _showRationaleDialog(context);
    if (!shouldRequest) return;

    final granted = await iosPlugin?.requestPermissions(
      alert: true,
      badge: false,
      sound: true,
    );

    if (granted == false && context.mounted) {
      await _showPermanentlyDeniedDialog(context);
    }
  }

  static Future<bool> _showRationaleDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          spacing: 8,
          children: [
            const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 20,
            ),
            Text(
              l10n.anchorAlarmNotificationRationaleTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          l10n.anchorAlarmNotificationRationaleBody,
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

  static Future<void> _showPermanentlyDeniedDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          spacing: 8,
          children: [
            const Icon(Icons.notifications_off, color: Colors.white, size: 20),
            Text(
              l10n.anchorAlarmNotificationBlockedTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          l10n.anchorAlarmNotificationBlockedBody,
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

  Future<void> triggerAlarm() async {
    if (!_pluginInitialized) await setupChannel();
    await _sendNotification();
    await _playSound();
  }

  Future<void> stopAlarm() async {
    await _player.stop();
    await _notifications.cancel(_notificationId);
  }

  Future<void> _sendNotification() async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      'Alarme de Âncora',
      channelDescription: 'Âncora arrastou!',
      importance: Importance.max,
      priority: Priority.max,
      icon: 'ic_notification_anchor',
      sound: const RawResourceAndroidNotificationSound('anchor_alarm'),
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      color: Colors.redAccent,
      ticker: 'Âncora Arrastou!',
      styleInformation: const BigTextStyleInformation(
        'Você saiu do raio de segurança definido para a âncora.',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: _soundAsset,
      presentAlert: true,
      presentSound: true,
      presentBadge: false,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    await _notifications.show(
      _notificationId,
      'Âncora Arrastou!',
      'Você saiu do raio de segurança da âncora.',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  Future<void> _playSound() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/$_soundAsset'));
  }
}
