import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../MapScreen/widgets/offline_basemap_layer.dart';

/// Mapa compacto com o trajeto da viagem (ou só a posição, num fundeio),
/// enquadrado nos pontos. Usa o mesmo mapa base offline da tela de mapa.
class TripTrackMap extends StatelessWidget {
  final List<LatLng> track;
  final LatLng? singlePoint;

  const TripTrackMap({super.key, this.track = const [], this.singlePoint});

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
    final point = singlePoint;
    final coordinates = track.isNotEmpty ? track : [?point];
    if (coordinates.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(12),
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
            backgroundColor: const Color(0xFF0A0A0A),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            const OfflineBasemapLayer(),
            if (track.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(points: track, strokeWidth: 4, color: Colors.pink),
                ],
              ),
            MarkerLayer(
              markers: [
                if (track.isNotEmpty) ...[
                  _dot(track.first, Colors.greenAccent),
                  _dot(track.last, Colors.redAccent),
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
