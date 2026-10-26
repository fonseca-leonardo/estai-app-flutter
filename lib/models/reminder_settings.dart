import 'notification_channel.dart';

/// Configuração de lembrete enviada junto da manutenção (e, depois, de
/// documentos e checklists).
///
/// O app só descreve quando avisar; quem agenda e dispara (push ou e-mail) é o
/// backend.
class ReminderSettings {
  static const List<int> daysBeforeOptions = [30, 15, 7, 1, 0];
  static const List<int> hoursBeforeOptions = [5, 10, 25, 50];

  final bool enabled;
  final List<int> daysBefore;
  final int? hoursBefore;
  final List<NotificationChannel> channels;

  const ReminderSettings({
    required this.enabled,
    required this.daysBefore,
    this.hoursBefore,
    required this.channels,
  });

  const ReminderSettings.defaults()
    : enabled = true,
      daysBefore = const [7, 1],
      hoursBefore = 10,
      channels = const [NotificationChannel.push, NotificationChannel.email];

  const ReminderSettings.disabled()
    : enabled = false,
      daysBefore = const [],
      hoursBefore = null,
      channels = const [];

  bool get usesPush => enabled && channels.contains(NotificationChannel.push);

  ReminderSettings copyWith({
    bool? enabled,
    List<int>? daysBefore,
    int? hoursBefore,
    bool clearHoursBefore = false,
    List<NotificationChannel>? channels,
  }) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      daysBefore: daysBefore ?? this.daysBefore,
      hoursBefore: clearHoursBefore ? null : (hoursBefore ?? this.hoursBefore),
      channels: channels ?? this.channels,
    );
  }

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    return ReminderSettings(
      enabled: json['enabled'] as bool? ?? false,
      daysBefore: (json['daysBefore'] as List<dynamic>? ?? [])
          .map((value) => (value as num).toInt())
          .toList(),
      hoursBefore: (json['hoursBefore'] as num?)?.toInt(),
      channels: (json['channels'] as List<dynamic>? ?? [])
          .map((value) => NotificationChannel.fromApiValue(value as String))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'daysBefore': daysBefore,
      'hoursBefore': hoursBefore,
      'channels': channels.map((channel) => channel.apiValue).toList(),
    };
  }
}
