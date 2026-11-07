import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/forecast_metric.dart';
import 'forecast_analysis.dart';

/// Formatação dos valores da previsão no idioma do aparelho.
abstract final class ForecastFormat {
  static int decimalsFor(ForecastMetric metric) =>
      metric == ForecastMetric.waves ? 1 : 0;

  /// Só o número ("12", "1,4"), ou "--" sem dado.
  static String number(double? value, String locale, {int decimals = 0}) {
    if (value == null) return '--';
    final format = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimals,
    );
    return format.format(value);
  }

  static String metricValue(
    ForecastMetric metric,
    double? value,
    String locale,
  ) => number(value, locale, decimals: decimalsFor(metric));

  /// Número com unidade: "12 kn", "1,4 m", "24°C", "70%".
  static String withUnit(
    ForecastMetric metric,
    double? value,
    String unit,
    String locale,
  ) {
    final text = metricValue(metric, value, locale);
    if (value == null) return text;
    return _joinUnit(text, unit);
  }

  static String _joinUnit(String text, String unit) {
    if (unit == '%' || unit.startsWith('°')) return '$text$unit';
    return '$text $unit';
  }

  static String joinUnit(String text, String unit) => _joinUnit(text, unit);

  /// "15:00" hoje; "sáb 15:00" em outro dia.
  static String time(DateTime time, DateTime now, String locale) {
    final hour = DateFormat.Hm(locale).format(time);
    final sameDay =
        time.year == now.year && time.month == now.month && time.day == now.day;
    if (sameDay) return hour;
    return '${DateFormat.E(locale).format(time)} $hour';
  }

  /// "Hoje", "Amanhã" ou "sáb 9".
  static String dayLabel(
    DateTime day,
    DateTime now,
    AppLocalizations l10n,
    String locale,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(day.year, day.month, day.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return l10n.forecastToday;
    if (diff == 1) return l10n.forecastTomorrow;
    return DateFormat('E d', locale).format(date);
  }

  static String cardinal(double? degrees, AppLocalizations l10n) {
    if (degrees == null) return '';
    switch (ForecastAnalysis.cardinal(degrees)) {
      case CardinalDirection.n:
        return l10n.cardinalN;
      case CardinalDirection.ne:
        return l10n.cardinalNE;
      case CardinalDirection.e:
        return l10n.cardinalE;
      case CardinalDirection.se:
        return l10n.cardinalSE;
      case CardinalDirection.s:
        return l10n.cardinalS;
      case CardinalDirection.sw:
        return l10n.cardinalSW;
      case CardinalDirection.w:
        return l10n.cardinalW;
      case CardinalDirection.nw:
        return l10n.cardinalNW;
    }
  }
}
