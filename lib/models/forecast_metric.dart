import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_chart_colors.dart';
import '../viewmodels/weather_forecast_viewmodel.dart';

/// Variáveis da previsão que têm gráfico e tendência.
enum ForecastMetric {
  wind(Icons.air, AppChartColors.blue, risingIsCaution: true),
  waves(Icons.waves, AppChartColors.aqua, risingIsCaution: true),
  temperature(Icons.thermostat, AppChartColors.orange),
  rain(Icons.water_drop_outlined, AppChartColors.violet, risingIsCaution: true),
  pressure(Icons.speed, AppChartColors.yellow);

  const ForecastMetric(this.icon, this.color, {this.risingIsCaution = false});

  final IconData icon;

  /// Cor da série no gráfico (só a marca; textos usam as cores de texto).
  final Color color;

  /// Subir é sinal de atenção para quem navega (vento, ondas, chuva).
  final bool risingIsCaution;

  /// Valor da métrica na hora, ou `null` se a API não trouxe.
  double? valueOf(ForecastHourData hour) {
    switch (this) {
      case ForecastMetric.wind:
        return hour.weather?.windSpeed10m;
      case ForecastMetric.waves:
        return hour.marine?.waveHeight;
      case ForecastMetric.temperature:
        return hour.weather?.temperature2m;
      case ForecastMetric.rain:
        return hour.weather?.precipitationProbability?.toDouble();
      case ForecastMetric.pressure:
        return hour.weather?.pressureMsl;
    }
  }

  /// Variação mínima para contar como "subindo"/"caindo". O vento depende
  /// da unidade da API (3 nós ≈ 5,5 km/h).
  double threshold({String? unit}) {
    switch (this) {
      case ForecastMetric.wind:
        final normalized = unit?.toLowerCase().replaceAll(' ', '') ?? '';
        if (normalized == 'km/h') return 5.5;
        if (normalized == 'm/s') return 1.5;
        if (normalized == 'mph') return 3.5;
        return 3;
      case ForecastMetric.waves:
        return 0.3;
      case ForecastMetric.temperature:
        return 1.5;
      case ForecastMetric.rain:
        return 20;
      case ForecastMetric.pressure:
        return 2;
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case ForecastMetric.wind:
        return l10n.forecastMetricWind;
      case ForecastMetric.waves:
        return l10n.forecastMetricWaves;
      case ForecastMetric.temperature:
        return l10n.forecastMetricTemperature;
      case ForecastMetric.rain:
        return l10n.forecastMetricRain;
      case ForecastMetric.pressure:
        return l10n.forecastMetricPressure;
    }
  }
}
