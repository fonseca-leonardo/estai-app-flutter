import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';

class RoutePlanner extends StatelessWidget {
  const RoutePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, viewModel) => viewModel.isPlanningRoute,
      builder: (context, isPlanningRoute, child) {
        if (!isPlanningRoute) {
          return const SizedBox.shrink();
        }
        return Selector<RoutePlannerViewModel, LatLng?>(
          selector: (_, viewModel) => viewModel.pendingPoint,
          builder: (context, pendingPoint, child) {
            if (pendingPoint != null) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 32,
                      children: [
                        Selector<RoutePlannerViewModel, int>(
                          selector: (_, viewModel) =>
                              viewModel.routePoints.length,
                          builder: (context, routePointsCount, child) {
                            return FloatingActionButton(
                              heroTag: 'route_planner_remove_last_button',
                              mini: true,
                              onPressed: routePointsCount > 0
                                  ? () {
                                      context
                                          .read<RoutePlannerViewModel>()
                                          .removeLastPoint();
                                    }
                                  : null,
                              backgroundColor: routePointsCount > 0
                                  ? Colors.orange.withAlpha(200)
                                  : Colors.grey.withAlpha(140),
                              child: const Icon(
                                Icons.undo,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        Selector<RoutePlannerViewModel, int>(
                          selector: (_, viewModel) =>
                              viewModel.routePoints.length,
                          builder: (context, routePointsCount, child) {
                            return FloatingActionButton(
                              heroTag: 'route_planner_confirm_button',
                              onPressed: routePointsCount >= 2
                                  ? () {
                                      context
                                          .read<RoutePlannerViewModel>()
                                          .confirmRoute();
                                      context
                                          .read<MapViewModel>()
                                          .setIsPlanningRoute(false);
                                    }
                                  : null,
                              backgroundColor: routePointsCount >= 2
                                  ? Colors.green.withAlpha(200)
                                  : Colors.grey.withAlpha(140),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        FloatingActionButton(
                          heroTag: 'route_planner_cancel_button',
                          mini: true,
                          onPressed: () {
                            context.read<MapViewModel>().setIsPlanningRoute(
                              false,
                            );
                            context.read<RoutePlannerViewModel>().clearRoute();
                          },
                          backgroundColor: Colors.red.withAlpha(200),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
