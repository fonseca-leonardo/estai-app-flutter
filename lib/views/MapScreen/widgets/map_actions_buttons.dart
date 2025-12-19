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
                onPressed: () =>
                    context.read<MapViewModel>().toggleCameraLock(),
                backgroundColor: isCameraLocked
                    ? Colors.black.withAlpha(140)
                    : Colors.black.withAlpha(64),
                child: Icon(
                  isCameraLocked ? Icons.near_me : Icons.near_me_outlined,
                  color: Colors.white,
                ),
                tooltip: isCameraLocked
                    ? l10n.unlockCamera
                    : l10n.lockCamera,
              );
            },
          ),
          // Botão de toggle dos tiles - observa apenas showCustomTiles
          Selector<MapViewModel, bool>(
            selector: (_, viewModel) => viewModel.showCustomTiles,
            builder: (context, showCustomTiles, child) {
              return FloatingActionButton(
                heroTag: 'tiles_toggle_button',
                onPressed: () =>
                    context.read<MapViewModel>().toggleCustomTiles(),
                backgroundColor: showCustomTiles
                    ? Colors.black.withAlpha(140)
                    : Colors.black.withAlpha(64),
                child: Icon(
                  showCustomTiles ? Icons.layers : Icons.layers_outlined,
                  color: Colors.white,
                ),
                tooltip: showCustomTiles
                    ? l10n.hideCustomTiles
                    : l10n.showCustomTiles,
              );
            },
          ),
        ],
      ),
    );
  }
}
