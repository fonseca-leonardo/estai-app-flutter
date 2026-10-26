import '../l10n/app_localizations.dart';

enum RampScheduleType {
  launch,
  haul;

  String get apiValue {
    switch (this) {
      case RampScheduleType.launch:
        return 'Launch';
      case RampScheduleType.haul:
        return 'Haul';
    }
  }

  static RampScheduleType fromApiValue(String value) {
    return RampScheduleType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => RampScheduleType.launch,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case RampScheduleType.launch:
        return l10n.rampTypeLaunch;
      case RampScheduleType.haul:
        return l10n.rampTypeHaul;
    }
  }
}
