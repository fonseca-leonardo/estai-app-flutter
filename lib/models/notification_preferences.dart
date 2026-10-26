/// Canais que o usuário aceita receber do backend, valendo para todos os
/// lembretes.
class NotificationPreferences {
  final bool pushEnabled;
  final bool emailEnabled;
  final String? email;

  const NotificationPreferences({
    required this.pushEnabled,
    required this.emailEnabled,
    this.email,
  });

  NotificationPreferences copyWith({bool? pushEnabled, bool? emailEnabled}) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      email: email,
    );
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      email: json['email'] as String?,
    );
  }
}
