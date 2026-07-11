import '../l10n/app_localizations.dart';

enum ServiceOrderStatus {
  pending,
  scheduled,
  inProgress,
  completed,
  cancelled;

  String get apiValue {
    switch (this) {
      case ServiceOrderStatus.pending:
        return 'Pending';
      case ServiceOrderStatus.scheduled:
        return 'Scheduled';
      case ServiceOrderStatus.inProgress:
        return 'InProgress';
      case ServiceOrderStatus.completed:
        return 'Completed';
      case ServiceOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static ServiceOrderStatus fromApiValue(String value) {
    return ServiceOrderStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => ServiceOrderStatus.pending,
    );
  }

  bool get isCancellable =>
      this != ServiceOrderStatus.completed &&
      this != ServiceOrderStatus.cancelled;

  String label(AppLocalizations l10n) {
    switch (this) {
      case ServiceOrderStatus.pending:
        return l10n.serviceOrderStatusPending;
      case ServiceOrderStatus.scheduled:
        return l10n.serviceOrderStatusScheduled;
      case ServiceOrderStatus.inProgress:
        return l10n.serviceOrderStatusInProgress;
      case ServiceOrderStatus.completed:
        return l10n.serviceOrderStatusCompleted;
      case ServiceOrderStatus.cancelled:
        return l10n.serviceOrderStatusCancelled;
    }
  }
}
