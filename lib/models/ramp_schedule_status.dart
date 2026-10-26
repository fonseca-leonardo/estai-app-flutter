import '../l10n/app_localizations.dart';

enum RampScheduleStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  rejected,
  noShow;

  String get apiValue {
    switch (this) {
      case RampScheduleStatus.pending:
        return 'Pending';
      case RampScheduleStatus.confirmed:
        return 'Confirmed';
      case RampScheduleStatus.inProgress:
        return 'InProgress';
      case RampScheduleStatus.completed:
        return 'Completed';
      case RampScheduleStatus.cancelled:
        return 'Cancelled';
      case RampScheduleStatus.rejected:
        return 'Rejected';
      case RampScheduleStatus.noShow:
        return 'NoShow';
    }
  }

  static RampScheduleStatus fromApiValue(String value) {
    return RampScheduleStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => RampScheduleStatus.pending,
    );
  }

  bool get isActive =>
      this == RampScheduleStatus.pending ||
      this == RampScheduleStatus.confirmed ||
      this == RampScheduleStatus.inProgress;

  /// O app só pode cancelar pedidos que ainda não começaram.
  bool get isCancellable =>
      this == RampScheduleStatus.pending ||
      this == RampScheduleStatus.confirmed;

  String label(AppLocalizations l10n) {
    switch (this) {
      case RampScheduleStatus.pending:
        return l10n.rampStatusPending;
      case RampScheduleStatus.confirmed:
        return l10n.rampStatusConfirmed;
      case RampScheduleStatus.inProgress:
        return l10n.rampStatusInProgress;
      case RampScheduleStatus.completed:
        return l10n.rampStatusCompleted;
      case RampScheduleStatus.cancelled:
        return l10n.rampStatusCancelled;
      case RampScheduleStatus.rejected:
        return l10n.rampStatusRejected;
      case RampScheduleStatus.noShow:
        return l10n.rampStatusNoShow;
    }
  }
}
