import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../viewmodels/map_viewmodel.dart';

class MapUserMarker extends StatelessWidget {
  final MapController mapController;

  const MapUserMarker({super.key, required this.mapController});

  void _updateCameraIfLocked(Position position, bool isLocked) {
    if (isLocked) {
      mapController.move(
        LatLng(position.latitude, position.longitude),
        mapController.camera.zoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, ({Position? position, bool isCameraLocked})>(
      selector: (_, viewModel) => (
        position: viewModel.currentPosition,
        isCameraLocked: viewModel.isCameraLocked,
      ),
      builder: (context, data, child) {
        if (data.position != null) {
          // Se a câmera estiver travada, move automaticamente
          if (data.isCameraLocked) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateCameraIfLocked(data.position!, data.isCameraLocked);
            });
          }
          return MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  data.position!.latitude,
                  data.position!.longitude,
                ),
                width: 20,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
