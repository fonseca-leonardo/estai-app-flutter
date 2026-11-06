import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/logbook_entry.dart';

/// Textos das métricas de viagem (distância, duração, velocidade) no idioma
/// do usuário.
class TripFormat {
  TripFormat._();

  static String distance(AppLocalizations l10n, double nm, String locale) =>
      l10n.distanceNmValue(NumberFormat('#,##0.0#', locale).format(nm));

  static String speed(AppLocalizations l10n, double kn, String locale) =>
      l10n.speedKnValue(NumberFormat('#,##0.0', locale).format(kn));

  static String duration(AppLocalizations l10n, int minutes) {
    if (minutes < 60) return l10n.durationMinutesValue(minutes.toString());
    return l10n.durationHoursMinutes(
      (minutes ~/ 60).toString(),
      (minutes % 60).toString().padLeft(2, '0'),
    );
  }

  /// `12,4 NM · 2 h 15 min · máx 18,2 kn`, só com o que a entrada tiver.
  static String metricsLine(
    AppLocalizations l10n,
    LogbookEntry entry,
    String locale,
  ) {
    final distanceNm = entry.distanceNm;
    final minutes = entry.durationMinutes;
    final maxSpeed = entry.maxSpeedKn;
    return [
      if (distanceNm != null) distance(l10n, distanceNm, locale),
      if (minutes != null) duration(l10n, minutes),
      if (maxSpeed != null)
        l10n.logbookTopSpeed(NumberFormat('#,##0.0', locale).format(maxSpeed)),
    ].join(' · ');
  }
}
