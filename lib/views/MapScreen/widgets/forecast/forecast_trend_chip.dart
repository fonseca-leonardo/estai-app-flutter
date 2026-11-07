import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_analysis.dart';
import '../../../../utils/forecast_format.dart';

/// "↑ 18 kn às 15:00" / "→ Estável". Âmbar só quando subir pede atenção
/// (vento, ondas, chuva); o texto fica sempre nas cores de texto.
class ForecastTrendChip extends StatelessWidget {
  final ForecastMetric metric;
  final ForecastTrend trend;
  final String unit;

  const ForecastTrendChip({
    super.key,
    required this.metric,
    required this.trend,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();

    final IconData icon;
    final String text;
    switch (trend.direction) {
      case TrendDirection.rising:
        icon = Icons.trending_up;
        text = l10n.forecastTrendTo(
          ForecastFormat.withUnit(metric, trend.target, unit, locale),
          ForecastFormat.time(trend.targetAt!, now, locale),
        );
      case TrendDirection.falling:
        icon = Icons.trending_down;
        text = l10n.forecastTrendTo(
          ForecastFormat.withUnit(metric, trend.target, unit, locale),
          ForecastFormat.time(trend.targetAt!, now, locale),
        );
      case TrendDirection.steady:
        icon = Icons.trending_flat;
        text = l10n.forecastTrendSteady;
    }

    final caution =
        trend.direction == TrendDirection.rising && metric.risingIsCaution;
    final iconColor = caution ? AppColors.warning : AppColors.textSecondary;
    final semantics = switch (trend.direction) {
      TrendDirection.rising => l10n.forecastTrendRising,
      TrendDirection.falling => l10n.forecastTrendFalling,
      TrendDirection.steady => l10n.forecastTrendSteady,
    };

    return Semantics(
      label: '$semantics, $text',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: caution
              ? AppColors.warning.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
