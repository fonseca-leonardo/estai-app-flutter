import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/weather_forecast_viewmodel.dart';

class WeatherTimelineItem extends StatelessWidget {
  final ForecastHourData data;
  final bool isCurrentHour;

  const WeatherTimelineItem({
    super.key,
    required this.data,
    this.isCurrentHour = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentHour
            ? Border.all(color: Colors.blue.withValues(alpha: 0.78), width: 2)
            : Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeHeader(),
            const SizedBox(height: 12),
            if (data.marine != null) ...[
              _buildMarineSection(context, data.marine!),
              const SizedBox(height: 12),
            ],
            if (data.weather != null) ...[
              _buildWeatherSection(context, data.weather!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeHeader() {
    try {
      final time = DateTime.parse(data.time);
      final timeFormat = DateFormat('HH:mm');
      final dateFormat = DateFormat('dd/MM');
      final isToday =
          time.day == DateTime.now().day &&
          time.month == DateTime.now().month &&
          time.year == DateTime.now().year;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isToday ? 'Hoje' : dateFormat.format(time),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            timeFormat.format(time),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } catch (e) {
      return Text(
        data.time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget _buildMarineSection(BuildContext context, MarineHourlyData marine) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _buildInfoRow(
        l10n.waveHeight,
        marine.waveHeight != null
            ? '${marine.waveHeight!.toStringAsFixed(1)} m'
            : '--',
        Icons.waves,
      ),
      _buildInfoRow(
        l10n.wavePeriod,
        marine.wavePeriod != null
            ? '${marine.wavePeriod!.toStringAsFixed(1)} s'
            : '--',
        Icons.timer_outlined,
      ),
      _buildInfoRow(
        l10n.waveDirection,
        marine.waveDirection != null
            ? '${marine.waveDirection!.toStringAsFixed(0)}°'
            : '--',
        Icons.navigation,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.marine,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        _buildTwoColumnLayout(items),
      ],
    );
  }

  Widget _buildWeatherSection(BuildContext context, WeatherHourlyData weather) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _buildInfoRow(
        l10n.temperature,
        weather.temperature2m != null
            ? '${weather.temperature2m!.toStringAsFixed(1)}°C'
            : '--',
        Icons.thermostat,
      ),
      _buildInfoRow(
        l10n.dewPoint,
        weather.dewPoint2m != null
            ? '${weather.dewPoint2m!.toStringAsFixed(1)}°C'
            : '--',
        Icons.water_drop_outlined,
      ),
      _buildInfoRow(
        l10n.windSpeed,
        weather.windSpeed10m != null
            ? '${weather.windSpeed10m!.toStringAsFixed(1)} kn'
            : '--',
        Icons.air,
      ),
      _buildInfoRow(
        l10n.windDirection,
        weather.windDirection10m != null
            ? '${weather.windDirection10m}°'
            : '--',
        Icons.navigation,
      ),
      _buildInfoRow(
        l10n.windGusts,
        weather.windGusts10m != null
            ? '${weather.windGusts10m!.toStringAsFixed(1)} kn'
            : '--',
        Icons.wind_power,
      ),
      _buildInfoRow(
        l10n.pressure,
        weather.pressureMsl != null
            ? '${weather.pressureMsl!.toStringAsFixed(1)} hPa'
            : '--',
        Icons.compress,
      ),
      _buildInfoRow(
        l10n.humidity,
        weather.relativeHumidity2m != null
            ? '${weather.relativeHumidity2m}%'
            : '--',
        Icons.opacity,
      ),
      _buildInfoRow(
        l10n.precipitation,
        weather.precipitation != null
            ? '${weather.precipitation!.toStringAsFixed(1)} mm'
            : '--',
        Icons.water_drop,
      ),
      _buildInfoRow(
        l10n.precipitationProbability,
        weather.precipitationProbability != null
            ? '${weather.precipitationProbability}%'
            : '--',
        Icons.cloud,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.weather,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        _buildTwoColumnLayout(items),
      ],
    );
  }

  Widget _buildTwoColumnLayout(List<Widget> items) {
    final leftColumn = <Widget>[];
    final rightColumn = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final widget = Padding(
        padding: EdgeInsets.only(bottom: i < items.length - 1 ? 4 : 0),
        child: items[i],
      );
      if (i % 2 == 0) {
        leftColumn.add(widget);
      } else {
        rightColumn.add(widget);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: leftColumn,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rightColumn,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white.withValues(alpha: 0.78)),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.59),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
