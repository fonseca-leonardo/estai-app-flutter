import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/forecast_metric.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_format.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import 'forecast_chart_scale.dart';

/// Linha da métrica ao longo das horas. Vento ganha a faixa até a rajada;
/// chuva vira área em degraus (chance por hora). Marca "Agora", meia-noite,
/// mínimo e máximo; tocar ou arrastar lê a hora e o valor.
class ForecastChart extends StatelessWidget {
  static const double height = 170;

  final List<ForecastHourData> hours;
  final ForecastMetric metric;
  final ForecastChartScale scale;
  final String unit;
  final String wavePeriodUnit;
  final String precipitationUnit;
  final DateTime now;
  final ValueChanged<DateTime> onSelect;

  const ForecastChart({
    super.key,
    required this.hours,
    required this.metric,
    required this.scale,
    required this.unit,
    required this.wavePeriodUnit,
    required this.precipitationUnit,
    required this.now,
    required this.onSelect,
  });

  bool get _isWind => metric == ForecastMetric.wind;
  bool get _isRain => metric == ForecastMetric.rain;

  List<FlSpot> _spots(double? Function(ForecastHourData hour) valueOf) {
    return [
      for (final hour in hours)
        if (valueOf(hour) case final value?)
          FlSpot(scale.xOf(hour.timeLocal), value)
        else
          FlSpot.nullSpot,
    ];
  }

  ({double min, double max}) _range(List<FlSpot> main, List<FlSpot> extra) {
    final values = [
      for (final spot in [...main, ...extra])
        if (!spot.isNull()) spot.y,
    ];
    if (_isRain) return (min: 0, max: 100);
    if (values.isEmpty) return (min: 0, max: 1);
    var low = values.reduce(math.min);
    var high = values.reduce(math.max);
    final pad = math.max((high - low) * 0.15, metric.threshold(unit: unit));
    high += pad;
    low -= pad;
    // Vento e ondas não ficam negativos.
    if (metric == ForecastMetric.wind || metric == ForecastMetric.waves) {
      low = math.max(0, low);
    }
    return (min: low, max: high);
  }

  ForecastHourData? _hourAt(double x) {
    final time = scale.timeOf(x);
    ForecastHourData? closest;
    for (final hour in hours) {
      if (closest == null ||
          (hour.timeLocal.difference(time)).abs() <
              (closest.timeLocal.difference(time)).abs()) {
        closest = hour;
      }
    }
    return closest;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final color = metric.color;

    final main = _spots(metric.valueOf);
    final gusts = _isWind
        ? _spots((hour) => hour.weather?.windGusts10m)
        : const <FlSpot>[];
    final range = _range(main, gusts);

    final valid = main.where((spot) => !spot.isNull()).toList();
    final minSpot = valid.isEmpty
        ? null
        : valid.reduce((a, b) => a.y <= b.y ? a : b);
    final maxSpot = valid.isEmpty
        ? null
        : valid.reduce((a, b) => a.y >= b.y ? a : b);

    final mainBar = LineChartBarData(
      spots: main,
      color: color,
      barWidth: 2,
      isCurved: !_isRain,
      curveSmoothness: 0.2,
      preventCurveOverShooting: true,
      isStepLineChart: _isRain,
      belowBarData: BarAreaData(
        show: _isRain,
        color: color.withValues(alpha: 0.35),
      ),
      dotData: FlDotData(
        checkToShowDot: (spot, bar) => spot == minSpot || spot == maxSpot,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.black,
        ),
      ),
    );

    final gustBar = LineChartBarData(
      spots: gusts,
      color: color.withValues(alpha: 0.55),
      barWidth: 1.5,
      isCurved: true,
      curveSmoothness: 0.2,
      preventCurveOverShooting: true,
      dashArray: const [4, 4],
      dotData: const FlDotData(show: false),
    );

    final bars = _isWind ? [gustBar, mainBar] : [mainBar];
    final mainIndex = bars.length - 1;
    final nowX = scale.xOf(now).clamp(0.0, scale.maxX);

    final midnights = [
      for (final hour in hours)
        if (hour.timeLocal.hour == 0) scale.xOf(hour.timeLocal),
    ];

    return SizedBox(
      width: scale.width,
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: scale.maxX,
          minY: range.min,
          maxY: range.max,
          lineBarsData: bars,
          betweenBarsData: _isWind
              ? [
                  BetweenBarsData(
                    fromIndex: 1,
                    toIndex: 0,
                    color: color.withValues(alpha: 0.18),
                  ),
                ]
              : const [],
          clipData: const FlClipData.all(),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: (range.max - range.min) / 3,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.white.withValues(alpha: 0.06),
              strokeWidth: 1,
            ),
          ),
          extraLinesData: ExtraLinesData(
            verticalLines: [
              for (final x in midnights)
                VerticalLine(
                  x: x,
                  color: Colors.white.withValues(alpha: 0.12),
                  strokeWidth: 1,
                ),
              VerticalLine(
                x: nowX,
                color: Colors.white.withValues(alpha: 0.6),
                strokeWidth: 1,
                dashArray: const [3, 3],
                label: VerticalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(left: 4, top: 0),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  labelResolver: (_) => l10n.forecastNow,
                ),
              ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final hour = _hourAt(value);
                  if (hour == null ||
                      (scale.xOf(hour.timeLocal) - value).abs() > 0.01 ||
                      hour.timeLocal.hour % 6 != 0) {
                    return const SizedBox.shrink();
                  }
                  final isMidnight = hour.timeLocal.hour == 0;
                  return SideTitleWidget(
                    meta: meta,
                    space: 6,
                    child: Text(
                      isMidnight
                          ? DateFormat.E(locale).format(hour.timeLocal)
                          : DateFormat.H(locale).format(hour.timeLocal),
                      style: TextStyle(
                        color: isMidnight
                            ? Colors.white
                            : AppColors.textTertiary,
                        fontSize: 11,
                        fontWeight: isMidnight
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 24,
            touchCallback: (event, response) {
              final spots = response?.lineBarSpots;
              if (!event.isInterestedForInteractions ||
                  spots == null ||
                  spots.isEmpty) {
                return;
              }
              final hour = _hourAt(spots.first.x);
              if (hour != null) onSelect(hour.timeLocal);
            },
            getTouchedSpotIndicator: (bar, indexes) => [
              for (final _ in indexes)
                TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.white.withValues(alpha: 0.4),
                    strokeWidth: 1,
                  ),
                  FlDotData(
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                          radius: 4,
                          color: bar.color ?? color,
                          strokeWidth: 2,
                          strokeColor: Colors.black,
                        ),
                  ),
                ),
            ],
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black.withValues(alpha: 0.85),
              tooltipBorder: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
              tooltipBorderRadius: BorderRadius.circular(8),
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              maxContentWidth: 160,
              getTooltipItems: (spots) => [
                for (final spot in spots)
                  _tooltipItem(spot, mainIndex, l10n, locale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineTooltipItem? _tooltipItem(
    LineBarSpot spot,
    int mainIndex,
    AppLocalizations l10n,
    String locale,
  ) {
    final hour = _hourAt(spot.x);
    if (hour == null) return null;

    const valueStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );
    final secondaryStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );

    if (spot.barIndex != mainIndex) {
      // Rajada: uma linha abaixo do valor principal.
      return LineTooltipItem(
        '${l10n.windGusts} ${ForecastFormat.withUnit(metric, spot.y, unit, locale)}',
        secondaryStyle,
      );
    }

    final extra = <TextSpan>[];
    if (metric == ForecastMetric.waves) {
      final period = hour.marine?.wavePeriod;
      if (period != null) {
        extra.add(
          TextSpan(
            text:
                '\n${l10n.wavePeriod} ${ForecastFormat.joinUnit(ForecastFormat.number(period, locale), wavePeriodUnit)}',
            style: secondaryStyle,
          ),
        );
      }
    }
    if (_isRain) {
      final mm = hour.weather?.precipitation;
      if (mm != null && mm > 0) {
        extra.add(
          TextSpan(
            text:
                '\n${ForecastFormat.joinUnit(ForecastFormat.number(mm, locale, decimals: 1), precipitationUnit)}',
            style: secondaryStyle,
          ),
        );
      }
    }

    return LineTooltipItem(
      '${ForecastFormat.time(hour.timeLocal, now, locale)}\n',
      secondaryStyle,
      children: [
        TextSpan(
          text: ForecastFormat.withUnit(metric, spot.y, unit, locale),
          style: valueStyle,
        ),
        ...extra,
      ],
    );
  }
}
