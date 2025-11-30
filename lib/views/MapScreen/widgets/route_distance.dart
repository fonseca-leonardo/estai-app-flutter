import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../components/navigation_data.dart';

class RouteDistance extends StatelessWidget {
  const RouteDistance({super.key});

  static const double _navigationDataTop = 48.0;
  static const double _navigationDataItemHeight = 50.0;
  static const double _navigationDataSpacing = 12.0;
  static const int _navigationDataItems = 3;
  static const double _routeDistanceSpacing = 12.0;

  double _calculateTopPosition() {
    return _navigationDataTop +
        (_navigationDataItemHeight * _navigationDataItems) +
        (_navigationDataSpacing * (_navigationDataItems - 1)) +
        _routeDistanceSpacing +
        12;
  }

  double _calculateTotalDistance(List<LatLng> points) {
    if (points.length < 2) {
      return 0.0;
    }

    const distance = Distance();
    double totalDistance = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += distance.as(LengthUnit.Meter, points[i], points[i + 1]);
    }

    return totalDistance;
  }

  String _formatDistanceInNauticalMiles(double distanceInMeters) {
    const metersPerNauticalMile = 1852.0;
    final nauticalMiles = distanceInMeters / metersPerNauticalMile;
    return '${nauticalMiles.toStringAsFixed(2)} NM';
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, viewModel) => viewModel.isPlanningRoute,
      builder: (context, isPlanningRoute, child) {
        if (!isPlanningRoute) {
          return const SizedBox.shrink();
        }
        return Selector<RoutePlannerViewModel, List<LatLng>>(
          selector: (_, viewModel) => viewModel.routePoints,
          builder: (context, routePoints, child) {
            if (routePoints.length < 2) {
              return const SizedBox.shrink();
            }

            final totalDistance = _calculateTotalDistance(routePoints);
            final formattedDistance = _formatDistanceInNauticalMiles(
              totalDistance,
            );

            return Positioned(
              top: _calculateTopPosition(),
              right: 20,
              child: NavigationData(
                data: [
                  NavigationDataItem(title: 'DIST', data: formattedDistance),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
