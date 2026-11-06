import '../../../theme/app_colors.dart';
import 'dart:io';

import 'package:estai/views/NavigationPermissionScreen/navigation_permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/estai_session_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../BoatsListScreen/boats_list_screen.dart';
import '../../MarinaHomeScreen/marina_home_screen.dart';
import '../../../widgets/ui/glass_fab.dart';
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
              return GlassFab(
                heroTag: 'camera_lock_button',
                onPressed: () =>
                    context.read<MapViewModel>().toggleCameraLock(),
                emphasized: isCameraLocked,
                tooltip: isCameraLocked ? l10n.unlockCamera : l10n.lockCamera,
                child: Icon(
                  isCameraLocked ? Icons.near_me : Icons.near_me_outlined,
                  color: Colors.white,
                ),
              );
            },
          ),
          Selector<MapViewModel, bool>(
            selector: (_, viewModel) => viewModel.isChartplotterMode,
            builder: (context, isChartplotterMode, child) {
              return GlassFab(
                heroTag: 'chartplotter_mode_button',
                onPressed: () =>
                    context.read<MapViewModel>().toggleChartplotterMode(),
                emphasized: isChartplotterMode,
                tooltip: 'Modo Chartplotter',
                child: Icon(
                  isChartplotterMode ? Icons.grid_on : Icons.grid_off,
                  color: Colors.white,
                ),
              );
            },
          ),
          GlassFab(
            heroTag: 'weather_forecast_button',
            onPressed: () => WeatherForecastBottomSheet.show(context),
            tooltip: 'Previsão do Tempo',
            child: const Icon(Icons.thermostat, color: Colors.white),
          ),
          Selector<EstaiSessionViewModel, ({bool hasMarina, File? logoFile})>(
            selector: (_, viewModel) =>
                (hasMarina: viewModel.hasMarina, logoFile: viewModel.logoFile),
            builder: (context, state, child) {
              final hasMarina = state.hasMarina;
              final logoFile = state.logoFile;
              return GlassFab(
                heroTag: 'my_boats_button',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => hasMarina
                        ? const MarinaHomeScreen()
                        : const BoatsListScreen(),
                  ),
                ),
                tooltip: hasMarina
                    ? l10n.marinaHubTooltip
                    : l10n.myBoatsTooltip,
                child: hasMarina && logoFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          logoFile,
                          key: ValueKey(logoFile.path),
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.anchor, color: Colors.white),
                        ),
                      )
                    : Icon(
                        hasMarina ? Icons.anchor : Icons.directions_boat,
                        color: Colors.white,
                      ),
              );
            },
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
              return GlassFab(
                heroTag: 'gps_availability_button',
                tint: AppColors.danger.withValues(alpha: 0.55),
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
