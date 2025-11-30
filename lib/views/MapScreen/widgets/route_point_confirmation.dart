import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';

class RoutePointConfirmation extends StatelessWidget {
  const RoutePointConfirmation({super.key});

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
            if (pendingPoint == null) {
              return const SizedBox.shrink();
            }

            return Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(140),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              context
                                  .read<RoutePlannerViewModel>()
                                  .confirmPendingPoint();
                            },
                            tooltip: 'Confirmar ponto',
                          ),
                          const Text(
                            'Adicionar ponto?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<RoutePlannerViewModel>()
                                  .cancelPendingPoint();
                            },
                            tooltip: 'Cancelar',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
