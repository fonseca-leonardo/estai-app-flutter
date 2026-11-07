import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/weather_monitor_pin.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/coordinate_formatter.dart';
import '../../../viewmodels/weather_forecast_viewmodel.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';
import 'forecast/forecast_panel.dart';
import 'forecast/forecast_sheet_frame.dart';

/// Previsão para um pin de clima, com a opção de excluir o pin.
class WeatherPinForecastBottomSheet extends StatelessWidget {
  final WeatherMonitorPin pin;

  const WeatherPinForecastBottomSheet({super.key, required this.pin});

  static void show(BuildContext context, WeatherMonitorPin pin) {
    final weatherViewModel = Provider.of<WeatherForecastViewModel>(
      context,
      listen: false,
    );

    if (weatherViewModel.shouldFetchForecasts(pin.latitude, pin.longitude)) {
      weatherViewModel.fetchForecasts(pin.latitude, pin.longitude);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      useRootNavigator: false,
      enableDrag: true,
      useSafeArea: true,
      builder: (bottomSheetContext) => WeatherPinForecastBottomSheet(pin: pin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final coordinates =
        '${CoordinateFormatter.formatLatitude(pin.latitude)}  ·  '
        '${CoordinateFormatter.formatLongitude(pin.longitude)}';

    return ForecastSheetFrame(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pin.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  coordinates,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<WeatherForecastViewModel>(
            builder: (context, viewModel, child) => ForecastPanel(
              viewModel: viewModel,
              onRetry: () =>
                  viewModel.fetchForecasts(pin.latitude, pin.longitude),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              context.read<WeatherMonitorPinsViewModel>().removePin(pin.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            label: Text(
              l10n.deletePin,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
