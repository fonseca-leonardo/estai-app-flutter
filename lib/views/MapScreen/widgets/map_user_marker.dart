import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../viewmodels/map_viewmodel.dart';

class MapUserMarker extends StatefulWidget {
  final MapController mapController;

  const MapUserMarker({super.key, required this.mapController});

  @override
  State<MapUserMarker> createState() => _MapUserMarkerState();
}

class _MapUserMarkerState extends State<MapUserMarker> {
  MapViewModel? _mapViewModel;
  Position? _lastPosition;
  bool _lastCameraLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _mapViewModel = context.read<MapViewModel>();
        _mapViewModel?.addListener(_handlePositionUpdate);
        _handlePositionUpdate();
      }
    });
  }

  @override
  void dispose() {
    _mapViewModel?.removeListener(_handlePositionUpdate);
    super.dispose();
  }

  void _handlePositionUpdate() {
    if (!mounted) return;
    
    final position = _mapViewModel?.currentPosition;
    final isCameraLocked = _mapViewModel?.isCameraLocked ?? false;
    
    if (position != null && isCameraLocked) {
      if (_lastPosition == null || 
          _lastPosition != position || 
          _lastCameraLocked != isCameraLocked) {
        _lastPosition = position;
        _lastCameraLocked = isCameraLocked;
        _updateCameraIfLocked(position, isCameraLocked);
      }
    } else {
      _lastPosition = position;
      _lastCameraLocked = isCameraLocked;
    }
    
    if (mounted) {
      setState(() {});
    }
  }

  void _updateCameraIfLocked(Position position, bool isLocked) {
    if (isLocked && mounted) {
      widget.mapController.move(
        LatLng(position.latitude, position.longitude),
        widget.mapController.camera.zoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, Position?>(
      selector: (_, viewModel) => viewModel.currentPosition,
      builder: (context, position, child) {
        if (position != null) {
          return MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  position.latitude,
                  position.longitude,
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
