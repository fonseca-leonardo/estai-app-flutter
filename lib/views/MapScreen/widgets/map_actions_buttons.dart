import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/map_viewmodel.dart';

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
            onPressed: () {},
            backgroundColor: Colors.black.withAlpha(64),
            child: const Icon(Icons.thermostat_outlined, color: Colors.white),
            tooltip: 'Previsão do Tempo',
          ),
        ],
      ),
    );
  }
}
