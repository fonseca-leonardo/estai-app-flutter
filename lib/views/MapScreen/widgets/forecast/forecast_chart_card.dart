import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_format.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import 'forecast_card.dart';
import 'forecast_chart.dart';
import 'forecast_chart_scale.dart';
import 'forecast_direction_strip.dart';

/// Gráfico rolável da métrica escolhida, com mínimo e máximo do período
/// e, para vento e ondas, a fileira de direções.
class ForecastChartCard extends StatelessWidget {
  final WeatherForecastViewModel viewModel;
  final ForecastChartScale scale;
  final ScrollController scrollController;

  const ForecastChartCard({
    super.key,
    required this.viewModel,
    required this.scale,
    required this.scrollController,
  });

  double? Function(ForecastHourData)? _directionOf(ForecastMetric metric) {
    switch (metric) {
      case ForecastMetric.wind:
        return (hour) => hour.weather?.windDirection10m?.toDouble();
      case ForecastMetric.waves:
        return (hour) => hour.marine?.waveDirection;
      case ForecastMetric.temperature:
      case ForecastMetric.rain:
      case ForecastMetric.pressure:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final metric = viewModel.selectedMetric;
    final hours = viewModel.forecastData;
    final unit = viewModel.unitFor(metric);
    final directionOf = _directionOf(metric);

    final values = [for (final hour in hours) ?metric.valueOf(hour)];
    final min = values.isEmpty ? null : values.reduce((a, b) => a < b ? a : b);
    final max = values.isEmpty ? null : values.reduce((a, b) => a > b ? a : b);
    final secondary = TextStyle(color: AppColors.textSecondary, fontSize: 12);

    return ForecastCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: metric.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    metric == ForecastMetric.rain
                        ? l10n.forecastChartRainTitle
                        : metric.label(l10n),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              l10n.forecastMinMax(
                ForecastFormat.withUnit(metric, min, unit, locale),
                ForecastFormat.withUnit(metric, max, unit, locale),
              ),
              style: secondary,
            ),
          ),
          if (metric == ForecastMetric.wind) ...[
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(l10n.forecastChartWindLegend, style: secondary),
            ),
          ],
          const SizedBox(height: 8),
          SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (directionOf != null)
                  ForecastDirectionStrip(
                    hours: hours,
                    scale: scale,
                    directionOf: directionOf,
                  ),
                ForecastChart(
                  hours: hours,
                  metric: metric,
                  scale: scale,
                  unit: unit,
                  wavePeriodUnit: viewModel.wavePeriodUnit,
                  precipitationUnit: viewModel.precipitationUnit,
                  now: DateTime.now(),
                  onSelect: viewModel.selectTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
