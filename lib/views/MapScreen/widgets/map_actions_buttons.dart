import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../viewmodels/list_maps_viewmodel.dart';
import '../../ListMapsScreen/list_maps_screen.dart';

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
                tooltip: isCameraLocked ? l10n.unlockCamera : l10n.lockCamera,
              );
            },
          ),
          // Botão de toggle dos tiles - observa showCustomTiles e mapas selecionados
          Consumer2<MapViewModel, ListMapsViewModel>(
            builder: (context, mapViewModel, mapsViewModel, child) {
              final showCustomTiles = mapViewModel.showCustomTiles;
              final hasSelectedMaps = mapsViewModel.selectedMaps.isNotEmpty;

              // O botão aparece como "selecionado" apenas se showCustomTiles for true E houver mapas selecionados
              final isActive = showCustomTiles && hasSelectedMaps;

              return FloatingActionButton(
                heroTag: 'tiles_toggle_button',
                onPressed: () {
                  if (!showCustomTiles) {
                    // Tentando ativar - verificar se há mapas selecionados
                    if (!hasSelectedMaps) {
                      // Navegar para ListMapsScreen se não houver mapas selecionados
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ListMapsScreen(),
                        ),
                      );
                    } else {
                      // Há mapas selecionados, pode ativar
                      mapViewModel.toggleCustomTiles();
                    }
                  } else {
                    // Desativando - sempre permitir
                    mapViewModel.toggleCustomTiles();
                  }
                },
                backgroundColor: isActive
                    ? Colors.black.withAlpha(140)
                    : Colors.black.withAlpha(64),
                child: Icon(
                  isActive ? Icons.layers : Icons.layers_outlined,
                  color: Colors.white,
                ),
                tooltip: isActive ? l10n.hideCustomTiles : l10n.showCustomTiles,
              );
            },
          ),
        ],
      ),
    );
  }
}
