import '../l10n/app_localizations.dart';

/// Por onde o backend entrega um lembrete.
enum NotificationChannel {
  push,
  email;

  String get apiValue {
    switch (this) {
      case NotificationChannel.push:
        return 'Push';
      case NotificationChannel.email:
        return 'Email';
    }
  }

  static NotificationChannel fromApiValue(String value) {
    return NotificationChannel.values.firstWhere(
      (channel) => channel.apiValue == value,
      orElse: () => NotificationChannel.push,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case NotificationChannel.push:
        return l10n.notificationChannelPush;
      case NotificationChannel.email:
        return l10n.notificationChannelEmail;
    }
  }
}
