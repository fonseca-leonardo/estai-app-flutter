import 'package:flutter/material.dart';
import '../../../../utils/forecast_analysis.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import 'forecast_card.dart';
import 'forecast_daily_row.dart';

/// "Próximos dias"; tocar num dia rola o gráfico até ele.
class ForecastDailyList extends StatelessWidget {
  final WeatherForecastViewModel viewModel;
  final ValueChanged<DailyForecastSummary> onDayTap;

  const ForecastDailyList({
    super.key,
    required this.viewModel,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final summaries = viewModel.dailySummaries;

    return ForecastCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < summaries.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            ForecastDailyRow(
              summary: summaries[i],
              windUnit: viewModel.windUnit,
              waveUnit: viewModel.waveUnit,
              temperatureUnit: viewModel.temperatureUnit,
              onTap: () => onDayTap(summaries[i]),
            ),
          ],
        ],
      ),
    );
  }
}
