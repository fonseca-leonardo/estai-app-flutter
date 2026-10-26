import '../l10n/app_localizations.dart';

enum MaintenanceCategory {
  engine,
  hull,
  electrical,
  plumbing,
  safety,
  rigging,
  electronics,
  other;

  String get apiValue {
    switch (this) {
      case MaintenanceCategory.engine:
        return 'Engine';
      case MaintenanceCategory.hull:
        return 'Hull';
      case MaintenanceCategory.electrical:
        return 'Electrical';
      case MaintenanceCategory.plumbing:
        return 'Plumbing';
      case MaintenanceCategory.safety:
        return 'Safety';
      case MaintenanceCategory.rigging:
        return 'Rigging';
      case MaintenanceCategory.electronics:
        return 'Electronics';
      case MaintenanceCategory.other:
        return 'Other';
    }
  }

  static MaintenanceCategory fromApiValue(String value) {
    return MaintenanceCategory.values.firstWhere(
      (category) => category.apiValue == value,
      orElse: () => MaintenanceCategory.other,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case MaintenanceCategory.engine:
        return l10n.maintenanceCategoryEngine;
      case MaintenanceCategory.hull:
        return l10n.maintenanceCategoryHull;
      case MaintenanceCategory.electrical:
        return l10n.maintenanceCategoryElectrical;
      case MaintenanceCategory.plumbing:
        return l10n.maintenanceCategoryPlumbing;
      case MaintenanceCategory.safety:
        return l10n.maintenanceCategorySafety;
      case MaintenanceCategory.rigging:
        return l10n.maintenanceCategoryRigging;
      case MaintenanceCategory.electronics:
        return l10n.maintenanceCategoryElectronics;
      case MaintenanceCategory.other:
        return l10n.maintenanceCategoryOther;
    }
  }
}
