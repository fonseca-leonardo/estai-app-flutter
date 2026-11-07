import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/forecast_analysis.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import '../../../../widgets/ui/error_state.dart';
import '../../../../widgets/ui/section_label.dart';
import 'forecast_chart_card.dart';
import 'forecast_chart_scale.dart';
import 'forecast_daily_list.dart';
import 'forecast_details_section.dart';
import 'forecast_headline.dart';
import 'forecast_metric_selector.dart';
import 'forecast_now_grid.dart';

/// Conteúdo comum dos sheets de previsão (posição atual e pin): agora com
/// tendência, frase de resumo, gráfico da métrica, próximos dias e
/// detalhes.
class ForecastPanel extends StatefulWidget {
  final WeatherForecastViewModel viewModel;
  final VoidCallback onRetry;

  const ForecastPanel({
    super.key,
    required this.viewModel,
    required this.onRetry,
  });

  @override
  State<ForecastPanel> createState() => _ForecastPanelState();
}

class _ForecastPanelState extends State<ForecastPanel> {
  final ScrollController _chartScroll = ScrollController();
  List<ForecastHourData>? _scrolledFor;

  @override
  void dispose() {
    _chartScroll.dispose();
    super.dispose();
  }

  /// Ao chegar uma previsão nova, o gráfico começa perto de "agora".
  void _scrollToNowOnce(ForecastChartScale scale) {
    final data = widget.viewModel.forecastData;
    if (identical(_scrolledFor, data)) return;
    _scrolledFor = data;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_chartScroll.hasClients) return;
      _chartScroll.jumpTo(
        scale
            .scrollOffsetFor(DateTime.now())
            .clamp(0.0, _chartScroll.position.maxScrollExtent),
      );
    });
  }

  void _scrollToDay(ForecastChartScale scale, DailyForecastSummary day) {
    if (!_chartScroll.hasClients) return;
    final now = DateTime.now();
    final target = day.date.isAfter(now) ? day.date : now;
    _chartScroll.animateTo(
      scale
          .scrollOffsetFor(target, leadHours: 0)
          .clamp(0.0, _chartScroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = widget.viewModel;

    if (viewModel.isLoading) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (viewModel.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: ErrorState(
          message: l10n.errorLoadingForecast,
          onRetry: widget.onRetry,
        ),
      );
    }

    if (viewModel.forecastData.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            l10n.noForecastAvailable,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    }

    final scale = ForecastChartScale.of(viewModel.forecastData);
    _scrollToNowOnce(scale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(l10n.forecastNow),
        ForecastNowGrid(viewModel: viewModel),
        const SizedBox(height: 10),
        ForecastHeadlineCard(
          headline: viewModel.headline,
          unitFor: viewModel.unitFor,
        ),
        const SizedBox(height: 20),
        SectionLabel(l10n.forecastEvolution),
        ForecastMetricSelector(
          selected: viewModel.selectedMetric,
          onChanged: viewModel.selectMetric,
        ),
        const SizedBox(height: 10),
        ForecastChartCard(
          viewModel: viewModel,
          scale: scale,
          scrollController: _chartScroll,
        ),
        const SizedBox(height: 20),
        if (viewModel.dailySummaries.isNotEmpty) ...[
          SectionLabel(l10n.forecastNextDays),
          ForecastDailyList(
            viewModel: viewModel,
            onDayTap: (day) => _scrollToDay(scale, day),
          ),
          const SizedBox(height: 12),
        ],
        ForecastDetailsSection(viewModel: viewModel),
      ],
    );
  }
}
