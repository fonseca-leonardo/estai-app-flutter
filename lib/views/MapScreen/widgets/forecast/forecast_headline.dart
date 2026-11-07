import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_analysis.dart';
import '../../../../utils/forecast_format.dart';
import 'forecast_card.dart';

/// Uma frase com o que muda nas próximas horas.
class ForecastHeadlineCard extends StatelessWidget {
  final ForecastHeadline? headline;
  final String Function(ForecastMetric metric) unitFor;

  const ForecastHeadlineCard({
    super.key,
    required this.headline,
    required this.unitFor,
  });

  String _sentence(AppLocalizations l10n, String locale) {
    final item = headline;
    if (item == null) return l10n.forecastHeadlineSteady;

    final value = ForecastFormat.withUnit(
      item.metric,
      item.value,
      unitFor(item.metric),
      locale,
    );
    final time = ForecastFormat.time(item.at, DateTime.now(), locale);
    final rising = item.direction == TrendDirection.rising;

    switch (item.metric) {
      case ForecastMetric.wind:
        return rising
            ? l10n.forecastHeadlineWindRising(value, time)
            : l10n.forecastHeadlineWindFalling(value, time);
      case ForecastMetric.waves:
        return rising
            ? l10n.forecastHeadlineWavesRising(value, time)
            : l10n.forecastHeadlineWavesFalling(value, time);
      case ForecastMetric.rain:
        return l10n.forecastHeadlineRain(value, time);
      case ForecastMetric.temperature:
      case ForecastMetric.pressure:
        return rising
            ? l10n.forecastHeadlineTemperatureRising(value, time)
            : l10n.forecastHeadlineTemperatureFalling(value, time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final item = headline;
    final caution =
        item != null &&
        item.direction == TrendDirection.rising &&
        item.metric.risingIsCaution;

    return ForecastCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(
            item == null
                ? Icons.check_circle_outline
                : (caution ? Icons.warning_amber_rounded : item.metric.icon),
            size: 20,
            color: caution ? AppColors.warning : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _sentence(l10n, locale),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
