import '../l10n/app_localizations.dart';

enum ServicePriceUnit {
  unit,
  hour,
  day,
  month;

  String get apiValue {
    switch (this) {
      case ServicePriceUnit.unit:
        return 'Unit';
      case ServicePriceUnit.hour:
        return 'Hour';
      case ServicePriceUnit.day:
        return 'Day';
      case ServicePriceUnit.month:
        return 'Month';
    }
  }

  static ServicePriceUnit fromApiValue(String value) {
    return ServicePriceUnit.values.firstWhere(
      (unit) => unit.apiValue == value,
      orElse: () => ServicePriceUnit.unit,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case ServicePriceUnit.unit:
        return l10n.unitPerUnit;
      case ServicePriceUnit.hour:
        return l10n.unitPerHour;
      case ServicePriceUnit.day:
        return l10n.unitPerDay;
      case ServicePriceUnit.month:
        return l10n.unitPerMonth;
    }
  }
}
