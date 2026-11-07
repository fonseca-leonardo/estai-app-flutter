import 'package:flutter/material.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import 'forecast_now_tile.dart';

/// "Agora": vento, ondas, temperatura e chuva em 2 × 2.
class ForecastNowGrid extends StatelessWidget {
  static const List<ForecastMetric> metrics = [
    ForecastMetric.wind,
    ForecastMetric.waves,
    ForecastMetric.temperature,
    ForecastMetric.rain,
  ];

  final WeatherForecastViewModel viewModel;

  const ForecastNowGrid({super.key, required this.viewModel});

  double? _direction(ForecastMetric metric, ForecastHourData? hour) {
    switch (metric) {
      case ForecastMetric.wind:
        return hour?.weather?.windDirection10m?.toDouble();
      case ForecastMetric.waves:
        return hour?.marine?.waveDirection;
      case ForecastMetric.temperature:
      case ForecastMetric.rain:
      case ForecastMetric.pressure:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = viewModel.currentHour;

    Widget tile(ForecastMetric metric) => Expanded(
      child: ForecastNowTile(
        metric: metric,
        value: hour == null ? null : metric.valueOf(hour),
        unit: viewModel.unitFor(metric),
        direction: _direction(metric, hour),
        trend: viewModel.trendFor(metric),
        selected: viewModel.selectedMetric == metric,
        onTap: () => viewModel.selectMetric(metric),
      ),
    );

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tile(metrics[0]),
              const SizedBox(width: 10),
              tile(metrics[1]),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tile(metrics[2]),
              const SizedBox(width: 10),
              tile(metrics[3]),
            ],
          ),
        ),
      ],
    );
  }
}
