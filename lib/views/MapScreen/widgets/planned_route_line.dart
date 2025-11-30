import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';

class PlannedRouteLine extends StatelessWidget {
  const PlannedRouteLine({super.key});

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
        if (data.count < 2) {
          return const SizedBox.shrink();
        }
        return Selector<MapViewModel, bool>(
          selector: (_, viewModel) => viewModel.isPlanningRoute,
          builder: (context, isPlanningRoute, child) {
            if (!isPlanningRoute && !data.hasConfirmedRoute) {
              return const SizedBox.shrink();
            }
            return PolylineLayer(
              polylines: [
                Polyline(
                  points: data.points,
                  strokeWidth: 5.0,
                  borderStrokeWidth: 4,
                  color: Colors.purple.withAlpha(200),
                  borderColor: Colors.white,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
