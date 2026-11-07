import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_analysis.dart';
import '../../../../utils/forecast_format.dart';
import 'forecast_card.dart';
import 'forecast_direction_arrow.dart';
import 'forecast_trend_chip.dart';

/// Valor de agora de uma métrica, com direção (vento/ondas) e tendência.
/// Tocar seleciona a métrica no gráfico.
class ForecastNowTile extends StatelessWidget {
  final ForecastMetric metric;
  final double? value;
  final String unit;
  final double? direction;
  final ForecastTrend trend;
  final bool selected;
  final VoidCallback onTap;

  const ForecastNowTile({
    super.key,
    required this.metric,
    required this.value,
    required this.unit,
    required this.trend,
    required this.selected,
    required this.onTap,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final heading = direction;

    return Stack(
      children: [
        ForecastCard(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(metric.icon, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      metric.label(l10n),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ForecastFormat.metricValue(metric, value, locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (heading != null) ...[
                    ForecastDirectionArrow(degrees: heading, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      ForecastFormat.cardinal(heading, l10n),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              ForecastTrendChip(metric: metric, trend: trend, unit: unit),
            ],
          ),
        ),
        if (selected)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: metric.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
