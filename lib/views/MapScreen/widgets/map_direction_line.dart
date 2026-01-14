import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../viewmodels/map_viewmodel.dart';

class MapDirectionLine extends StatefulWidget {
  final MapController mapController;

  const MapDirectionLine({super.key, required this.mapController});

  @override
  State<MapDirectionLine> createState() => _MapDirectionLineState();
}

class _MapDirectionLineState extends State<MapDirectionLine> {
  StreamSubscription? _mapEventSubscription;
  double _currentZoom = 10.0;

  @override
  void initState() {
    super.initState();
    _currentZoom = widget.mapController.camera.zoom;
    _mapEventSubscription = widget.mapController.mapEventStream.listen((event) {
      if (mounted) {
        setState(() {
          _currentZoom = widget.mapController.camera.zoom;
        });
      }
    });
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    super.dispose();
  }

  double _calculateDistanceFromZoom(double zoom) {
    double distance = 30;

    if (zoom <= 22) {
      distance = 5;
    }

    if (zoom <= 20) {
      distance = 30;
    }

    if (zoom <= 19) {
      distance = 70;
    }

    if (zoom <= 18) {
      distance = 180;
    }

    if (zoom <= 17) {
      distance = 350;
    }

    if (zoom <= 16) {
      distance = 550;
    }

    if (zoom <= 14) {
      distance = 2000;
    }

    if (zoom <= 12) {
      distance = 7400;
    }

    if (zoom <= 10) {
      distance = 24000;
    }

    if (zoom <= 7.8) {
      distance = 80000;
    }

    if (zoom <= 5.7) {
      distance = 320000;
    }

    if (zoom <= 3.4) {
      distance = 640000;
    }

    return distance * 0.7;
  }

  LatLng _calculateDestinationPoint(
    LatLng start,
    double bearing,
    double distanceInMeters,
  ) {
    const distance = Distance();
    return distance.offset(start, distanceInMeters, bearing);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, ({Position? position, double? heading})>(
      selector: (_, viewModel) => (
        position: viewModel.currentPosition,
        heading: viewModel.currentHeading,
      ),
      builder: (context, data, child) {
        if (data.position != null &&
            data.heading != null &&
            data.heading! >= 0) {
          final startPoint = LatLng(
            data.position!.latitude,
            data.position!.longitude,
          );

          final distanceInMeters = _calculateDistanceFromZoom(_currentZoom);
          final endPoint = _calculateDestinationPoint(
            startPoint,
            data.heading!,
            distanceInMeters,
          );

          return PolylineLayer(
            polylines: [
              Polyline(
                points: [startPoint, endPoint],
                strokeWidth: 3.0,
                color: Colors.blue.withOpacity(0.7),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
