import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import 'forecast_chart_scale.dart';
import 'forecast_direction_arrow.dart';

/// Fileira de setas de direção a cada [stepHours], alinhada ao gráfico.
class ForecastDirectionStrip extends StatelessWidget {
  static const double height = 22;
  static const int stepHours = 3;

  final List<ForecastHourData> hours;
  final ForecastChartScale scale;
  final double? Function(ForecastHourData hour) directionOf;

  const ForecastDirectionStrip({
    super.key,
    required this.hours,
    required this.scale,
    required this.directionOf,
  });

  @override
  Widget build(BuildContext context) {
    const arrowSize = 14.0;

    return SizedBox(
      width: scale.width,
      height: height,
      child: Stack(
        children: [
          for (final hour in hours)
            if (hour.timeLocal.hour % stepHours == 0 &&
                directionOf(hour) != null)
              Positioned(
                left: (scale.pixelOf(scale.xOf(hour.timeLocal)) - arrowSize / 2)
                    .clamp(0, scale.width - arrowSize),
                top: (height - arrowSize) / 2,
                child: ForecastDirectionArrow(
                  degrees: directionOf(hour)!,
                  size: arrowSize,
                  color: AppColors.textSecondary,
                ),
              ),
        ],
      ),
    );
  }
}
