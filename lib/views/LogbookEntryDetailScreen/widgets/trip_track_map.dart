import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/list_maps_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../MapScreen/widgets/offline_basemap_layer.dart';
import '../../MapScreen/widgets/selected_map_tile_layers.dart';

/// Mapa compacto com o trajeto da viagem (ou só a posição, num fundeio),
/// enquadrado nos pontos. Usa as mesmas camadas da tela de mapa: base offline
/// e mapas selecionados.
class TripTrackMap extends StatelessWidget {
  final List<LatLng> track;
  final LatLng? singlePoint;

  /// Só a versão expandida aceita gestos; o preview é estático.
  final bool interactive;
  final double? height;

  const TripTrackMap({
    super.key,
    this.track = const [],
    this.singlePoint,
    this.interactive = false,
    this.height = 240,
  });

  Marker _dot(LatLng point, Color color) {
    return Marker(
      point: point,
      width: 16,
      height: 16,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = context.watch<MapViewModel>();
    final mapsViewModel = context.watch<ListMapsViewModel>();
    final point = singlePoint;
    final coordinates = track.isNotEmpty ? track : [?point];
    if (coordinates.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(interactive ? 0 : 12),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: interactive
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(interactive ? 0 : 12),
        ),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: coordinates.first,
            initialZoom: 14,
            initialCameraFit: CameraFit.coordinates(
              coordinates: coordinates,
              padding: const EdgeInsets.all(40),
              maxZoom: 16,
            ),
            backgroundColor: AppColors.surfaceElevated,
            interactionOptions: InteractionOptions(
              flags: interactive
                  ? InteractiveFlag.all & ~InteractiveFlag.rotate
                  : InteractiveFlag.none,
            ),
          ),
          children: [
            const OfflineBasemapLayer(),
            ...buildSelectedMapTileLayers(mapViewModel, mapsViewModel),
            if (track.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(points: track, strokeWidth: 4, color: Colors.pink),
                ],
              ),
            MarkerLayer(
              markers: [
                if (track.isNotEmpty) ...[
                  _dot(track.first, AppColors.success),
                  _dot(track.last, AppColors.danger),
                ] else if (point != null)
                  _dot(point, Colors.lightBlueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
