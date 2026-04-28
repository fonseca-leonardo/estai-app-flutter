import 'package:estai/views/NavigationPermissionScreen/navigation_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/map_viewmodel.dart';
import './weather_forecast_bottom_sheet.dart';

class MapActionsButtons extends StatelessWidget {
  const MapActionsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      top: 48,
      left: 20,
      child: Column(
        spacing: 12,
        children: [
          // Botão de lock/unlock da câmera - observa apenas isCameraLocked
          Selector<MapViewModel, bool>(
            selector: (_, viewModel) => viewModel.isCameraLocked,
            builder: (context, isCameraLocked, child) {
              return FloatingActionButton(
                heroTag: 'camera_lock_button',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.white.withAlpha(64)),
                ),
                onPressed: () =>
                    context.read<MapViewModel>().toggleCameraLock(),
                backgroundColor: isCameraLocked
                    ? Colors.black.withAlpha(140)
                    : Colors.black.withAlpha(64),
                child: Icon(
                  isCameraLocked ? Icons.near_me : Icons.near_me_outlined,
                  color: Colors.white,
                ),
                tooltip: isCameraLocked ? l10n.unlockCamera : l10n.lockCamera,
              );
            },
          ),
          FloatingActionButton(
            heroTag: 'weather_forecast_button',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.white.withAlpha(64)),
            ),
            onPressed: () => WeatherForecastBottomSheet.show(context),
            backgroundColor: Colors.black.withAlpha(140),
            child: const Icon(Icons.thermostat, color: Colors.white),
            tooltip: 'Previsão do Tempo',
          ),
          Selector<MapViewModel, bool>(
            selector: (_, viewModel) {
              final error = viewModel.errorMessage;
              return error != null &&
                  (error.contains('locationPermissionDenied') ||
                      error.contains('locationPermissionDeniedForever'));
            },
            builder: (context, isLocationPermissionDenied, child) {
              if (!isLocationPermissionDenied) {
                return const SizedBox.shrink();
              }
              return FloatingActionButton(
                heroTag: 'gps_availability_button',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.white.withAlpha(64)),
                ),
                backgroundColor: Colors.redAccent.withAlpha(140),
                tooltip: 'Disponibilidade do GPS',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NavigationPermissionScreen(),
                  ),
                ),
                child: const Icon(Icons.gps_off, color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}
