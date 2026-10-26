import '../l10n/app_localizations.dart';

enum MaintenanceStatus {
  scheduled,
  overdue,
  done;

  String get apiValue {
    switch (this) {
      case MaintenanceStatus.scheduled:
        return 'Scheduled';
      case MaintenanceStatus.overdue:
        return 'Overdue';
      case MaintenanceStatus.done:
        return 'Done';
    }
  }

  static MaintenanceStatus fromApiValue(String value) {
    return MaintenanceStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => MaintenanceStatus.scheduled,
    );
  }

  bool get isPending =>
      this == MaintenanceStatus.scheduled || this == MaintenanceStatus.overdue;

  String label(AppLocalizations l10n) {
    switch (this) {
      case MaintenanceStatus.scheduled:
        return l10n.maintenanceStatusScheduled;
      case MaintenanceStatus.overdue:
        return l10n.maintenanceStatusOverdue;
      case MaintenanceStatus.done:
        return l10n.maintenanceStatusDone;
    }
  }
}
