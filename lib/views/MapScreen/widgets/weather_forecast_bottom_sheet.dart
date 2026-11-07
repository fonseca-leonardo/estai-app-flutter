import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../viewmodels/weather_forecast_viewmodel.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';
import '../../../widgets/ui/glass_fab.dart';
import 'forecast/forecast_panel.dart';
import 'forecast/forecast_sheet_frame.dart';
import 'login_required_widget.dart';

/// Previsão para a posição atual do barco.
class WeatherForecastBottomSheet extends StatelessWidget {
  final BuildContext? parentContext;

  const WeatherForecastBottomSheet({super.key, this.parentContext});

  static void show(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherForecastViewModel>(
      context,
      listen: false,
    );

    final position = mapViewModel.currentPosition;
    if (position != null) {
      if (weatherViewModel.shouldFetchForecasts(
        position.latitude,
        position.longitude,
      )) {
        weatherViewModel.fetchForecasts(position.latitude, position.longitude);
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      useRootNavigator: false,
      enableDrag: true,
      useSafeArea: true,
      builder: (bottomSheetContext) =>
          WeatherForecastBottomSheet(parentContext: context),
    );
  }

  void _retry(BuildContext context, WeatherForecastViewModel viewModel) {
    final lastLat = viewModel.lastFetchLatitude;
    final lastLon = viewModel.lastFetchLongitude;
    if (lastLat != null && lastLon != null) {
      viewModel.fetchForecasts(lastLat, lastLon);
      return;
    }
    final position = context.read<MapViewModel>().currentPosition;
    if (position != null) {
      viewModel.fetchForecasts(position.latitude, position.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ForecastSheetFrame(
      header: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.weatherForecast,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.currentLocation,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Consumer3<AuthViewModel, WeatherMonitorPinsViewModel, MapViewModel>(
            builder: (context, auth, pins, map, child) {
              if (!auth.isAuthenticated) return const SizedBox.shrink();
              return GlassFab(
                heroTag: 'addWeatherPin',
                tooltip: l10n.addWeatherPin,
                onPressed: map.isPlanningRoute
                    ? null
                    : () {
                        pins.setAddingPinMode(true);
                        Navigator.of(context).pop();
                      },
                child: Opacity(
                  opacity: map.isPlanningRoute ? 0.5 : 1,
                  child: const Icon(Icons.add_location_alt),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<WeatherForecastViewModel, AuthViewModel>(
        builder: (context, viewModel, auth, child) {
          if (!auth.isAuthenticated) return const LoginRequiredWidget();
          return ForecastPanel(
            viewModel: viewModel,
            onRetry: () => _retry(context, viewModel),
          );
        },
      ),
    );
  }
}
