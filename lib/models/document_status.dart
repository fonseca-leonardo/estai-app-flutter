import '../l10n/app_localizations.dart';

/// Situação do documento pela validade, calculada no app.
enum DocumentStatus {
  expired,
  expiringSoon,
  valid,
  noExpiry;

  /// A partir daqui (em dias) o documento aparece como "vencendo".
  static const int expiringSoonDays = 30;

  static DocumentStatus of(DateTime? expiresAt, {DateTime? now}) {
    if (expiresAt == null) return DocumentStatus.noExpiry;
    final days = daysUntil(expiresAt, now: now);
    if (days < 0) return DocumentStatus.expired;
    if (days <= expiringSoonDays) return DocumentStatus.expiringSoon;
    return DocumentStatus.valid;
  }

  /// Dias de calendário até [date] (negativo se já passou).
  static int daysUntil(DateTime date, {DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());
    return _dateOnly(date.toLocal()).difference(today).inDays;
  }

  bool get needsAttention =>
      this == DocumentStatus.expired || this == DocumentStatus.expiringSoon;

  String label(AppLocalizations l10n) {
    switch (this) {
      case DocumentStatus.expired:
        return l10n.documentStatusExpired;
      case DocumentStatus.expiringSoon:
        return l10n.documentStatusExpiringSoon;
      case DocumentStatus.valid:
        return l10n.documentStatusValid;
      case DocumentStatus.noExpiry:
        return l10n.documentStatusNoExpiry;
    }
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
