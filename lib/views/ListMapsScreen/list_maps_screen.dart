import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/list_maps_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';
import 'widgets/maps_selection_info.dart';
import 'widgets/map_card.dart';
import 'widgets/primary_map_card.dart';
import 'widgets/dark_mode_toggle.dart';

class ListMapsScreen extends StatelessWidget {
  const ListMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maps),
        backgroundColor: Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Consumer<ListMapsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.maps.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if ((viewModel.errorMessage != null || viewModel.isConnectionError) &&
              viewModel.maps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.isConnectionError
                          ? l10n.errorLoadingMaps
                          : (viewModel.errorMessage ?? l10n.errorLoadingMaps),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => viewModel.loadMaps(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        side: const BorderSide(color: Colors.redAccent),
                        foregroundColor: Colors.redAccent,
                      ),
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewModel.maps.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum mapa disponível',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final primaryMaps = viewModel.primaryMaps;
          final optionalMaps = viewModel.optionalMaps;

          return RefreshIndicator(
            onRefresh: () => viewModel.loadMaps(),
            color: Colors.white,
            backgroundColor: Colors.black,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const DarkModeToggle(),
                const SizedBox(height: 8),
                const MapsSelectionInfo(),
                const SizedBox(height: 8),
                if (primaryMaps.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber.withValues(alpha: 0.9),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mapas Principais',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...primaryMaps.map(
                    (mapItem) => PrimaryMapCard(mapItem: mapItem),
                  ),
                  if (optionalMaps.isNotEmpty) const SizedBox(height: 16),
                ],
                if (optionalMaps.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mapas Opcionais',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...optionalMaps.map(
                    (mapItem) => MapCard(
                      mapItem: mapItem,
                      isSelected: viewModel.isMapSelected(mapItem.id),
                      onToggleSelection: () =>
                          viewModel.toggleMapSelection(mapItem.id),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
