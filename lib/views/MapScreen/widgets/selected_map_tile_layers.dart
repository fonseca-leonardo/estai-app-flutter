import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../services/cached_tile_provider.dart';
import '../../../services/tile_cache_service.dart';
import '../../../viewmodels/list_maps_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';

/// Camadas de tiles dos mapas que o usuário selecionou na lista de mapas,
/// iguais às da tela de mapa. Vazio se os mapas personalizados estiverem
/// desligados.
List<Widget> buildSelectedMapTileLayers(
  MapViewModel mapViewModel,
  ListMapsViewModel mapsViewModel,
) {
  if (!mapViewModel.showCustomTiles) return const <Widget>[];

  return mapsViewModel.selectedMaps
      .map(
        (mapItem) => TileLayer(
          urlTemplate:
              '${mapItem.path}${mapsViewModel.darkMode ? '?dark=true' : ''}',
          userAgentPackageName: 'com.br.estai',
          maxZoom: mapItem.maxZoom.toDouble(),
          minZoom: mapItem.minZoom.toDouble(),
          tileProvider: mapsViewModel.isMapCached(mapItem.id)
              ? CachedTileProvider(
                  mapId: mapItem.id,
                  darkMode: mapsViewModel.darkMode,
                  cacheService: TileCacheService.instance,
                )
              : NetworkTileProvider(),
          errorTileCallback: (tile, error, stackTrace) {},
        ),
      )
      .toList();
}
