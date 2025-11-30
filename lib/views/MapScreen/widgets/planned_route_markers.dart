import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';

class PlannedRouteMarkers extends StatelessWidget {
  final MapController mapController;

  const PlannedRouteMarkers({super.key, required this.mapController});

  Color _getMarkerColor(int index, int totalPoints) {
    if (index == 0) {
      return Colors.red;
    } else if (index == totalPoints - 1) {
      return Colors.green;
    } else {
      return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<
      RoutePlannerViewModel,
      ({List<LatLng> points, int count, bool hasConfirmedRoute})
    >(
      selector: (_, viewModel) => (
        points: viewModel.routePoints,
        count: viewModel.routePoints.length,
        hasConfirmedRoute: viewModel.hasConfirmedRoute,
      ),
      builder: (context, data, child) {
        if (data.count == 0) {
          return const SizedBox.shrink();
        }
        return Selector<MapViewModel, bool>(
          selector: (_, viewModel) => viewModel.isPlanningRoute,
          builder: (context, isPlanningRoute, child) {
            if (!isPlanningRoute && !data.hasConfirmedRoute) {
              return const SizedBox.shrink();
            }
            return MarkerLayer(
              markers: data.points.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                final color = _getMarkerColor(index, data.count);
                final isIntermediate = index > 0 && index < data.count - 1;
                final size = isIntermediate ? 12.0 : 16.0;

                return Marker(
                  point: point,
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                  child: _DraggableMarker(
                    index: index,
                    color: color,
                    size: size,
                    onTap: () {
                      context.read<RoutePlannerViewModel>().startDragging(
                        index,
                      );
                    },
                    mapController: mapController,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class _DraggableMarker extends StatelessWidget {
  final int index;
  final Color color;
  final double size;
  final VoidCallback onTap;
  final MapController mapController;

  const _DraggableMarker({
    required this.index,
    required this.color,
    required this.size,
    required this.onTap,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<RoutePlannerViewModel, int?>(
      selector: (_, viewModel) => viewModel.draggingIndex,
      builder: (context, draggingIndex, child) {
        final isDragging = draggingIndex == index;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: isDragging
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );
  }
}
