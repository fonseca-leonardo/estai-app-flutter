import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_analysis.dart';
import '../../../../utils/forecast_format.dart';
import 'forecast_direction_arrow.dart';

/// Um dia: temperatura mín/máx, vento máximo com direção, onda máxima e
/// maior chance de chuva.
class ForecastDailyRow extends StatelessWidget {
  final DailyForecastSummary summary;
  final String windUnit;
  final String waveUnit;
  final String temperatureUnit;
  final VoidCallback onTap;

  const ForecastDailyRow({
    super.key,
    required this.summary,
    required this.windUnit,
    required this.waveUnit,
    required this.temperatureUnit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final valueStyle = const TextStyle(color: Colors.white, fontSize: 13);
    final iconColor = AppColors.textTertiary;
    final direction = summary.dominantWindDirection;

    Widget item(IconData icon, String text, {Widget? trailing}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(text, style: valueStyle),
        if (trailing != null) ...[const SizedBox(width: 3), trailing],
      ],
    );

    final temperature =
        '${ForecastFormat.metricValue(ForecastMetric.temperature, summary.minTemperature, locale)}'
        ' / '
        '${ForecastFormat.withUnit(ForecastMetric.temperature, summary.maxTemperature, temperatureUnit, locale)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(
                ForecastFormat.dayLabel(summary.date, now, l10n, locale),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  item(ForecastMetric.temperature.icon, temperature),
                  item(
                    ForecastMetric.wind.icon,
                    ForecastFormat.withUnit(
                      ForecastMetric.wind,
                      summary.maxWind,
                      windUnit,
                      locale,
                    ),
                    trailing: direction == null
                        ? null
                        : ForecastDirectionArrow(
                            degrees: direction,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                  ),
                  if (summary.maxWaveHeight != null)
                    item(
                      ForecastMetric.waves.icon,
                      ForecastFormat.withUnit(
                        ForecastMetric.waves,
                        summary.maxWaveHeight,
                        waveUnit,
                        locale,
                      ),
                    ),
                  item(
                    ForecastMetric.rain.icon,
                    ForecastFormat.withUnit(
                      ForecastMetric.rain,
                      summary.maxRainProbability,
                      '%',
                      locale,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: iconColor),
          ],
        ),
      ),
    );
  }
}
