import '../l10n/app_localizations.dart';

enum BoatReminderStatus {
  pending,
  done;

  String get apiValue {
    switch (this) {
      case BoatReminderStatus.pending:
        return 'Pending';
      case BoatReminderStatus.done:
        return 'Done';
    }
  }

  static BoatReminderStatus fromApiValue(String value) {
    return BoatReminderStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => BoatReminderStatus.pending,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case BoatReminderStatus.pending:
        return l10n.boatReminderStatusPending;
      case BoatReminderStatus.done:
        return l10n.boatReminderStatusDone;
    }
  }
}
