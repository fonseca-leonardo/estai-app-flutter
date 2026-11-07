import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/forecast_format.dart';
import '../../../../viewmodels/weather_forecast_viewmodel.dart';
import 'forecast_card.dart';

/// Dados secundários da hora selecionada no gráfico (ou de agora),
/// recolhidos por padrão.
class ForecastDetailsSection extends StatefulWidget {
  final WeatherForecastViewModel viewModel;

  const ForecastDetailsSection({super.key, required this.viewModel});

  @override
  State<ForecastDetailsSection> createState() => _ForecastDetailsSectionState();
}

class _ForecastDetailsSectionState extends State<ForecastDetailsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final viewModel = widget.viewModel;
    final hour = viewModel.selectedHour;
    final weather = hour?.weather;
    final marine = hour?.marine;

    String withUnit(double? value, String unit, {int decimals = 0}) {
      if (value == null) return '--';
      return ForecastFormat.joinUnit(
        ForecastFormat.number(value, locale, decimals: decimals),
        unit,
      );
    }

    final rows = <(String, String)>[
      (l10n.windGusts, withUnit(weather?.windGusts10m, viewModel.windUnit)),
      (l10n.pressure, withUnit(weather?.pressureMsl, viewModel.pressureUnit)),
      (l10n.humidity, withUnit(weather?.relativeHumidity2m?.toDouble(), '%')),
      (l10n.dewPoint, withUnit(weather?.dewPoint2m, viewModel.temperatureUnit)),
      (l10n.wavePeriod, withUnit(marine?.wavePeriod, viewModel.wavePeriodUnit)),
      (
        l10n.precipitation,
        withUnit(
          weather?.precipitation,
          viewModel.precipitationUnit,
          decimals: 1,
        ),
      ),
    ];

    return ForecastCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hour == null
                          ? l10n.forecastMoreDetails
                          : l10n.forecastMoreDetailsAt(
                              ForecastFormat.time(
                                hour.timeLocal,
                                DateTime.now(),
                                locale,
                              ),
                            ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                children: [
                  for (final (label, value) in rows)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
