import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/route.dart' as route_model;
import '../../viewmodels/routes_viewmodel.dart';
import '../../viewmodels/route_planner_viewmodel.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../../viewmodels/navigation_status_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myRoutes),
        backgroundColor: Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Consumer<RoutesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.routes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.routes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.route,
                    size: 64,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noRoutesFound,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.routes.length,
            itemBuilder: (context, index) {
              final route = viewModel.routes[index];
              return _RouteCard(route: route);
            },
          );
        },
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final route_model.Route route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () => _loadRoute(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      route.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white70),
                    color: Colors.black.withAlpha(240),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editRouteName(context);
                      } else if (value == 'delete') {
                        _deleteRoute(context);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.editRouteName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.deleteRoute,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${route.points.length} ${l10n.points}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(route.createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadRoute(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routePlannerViewModel = context.read<RoutePlannerViewModel>();
    final mapViewModel = context.read<MapViewModel>();
    final navigationStatusViewModel = context.read<NavigationStatusViewModel>();

    final totalDistance = _calculateTotalDistance(route.points);
    final distanceText = _formatDistanceInNauticalMiles(totalDistance);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black.withAlpha(240),
          title: Text(
            l10n.routeDetails,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${route.points.length} ${l10n.points}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.straighten,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.totalDistance}: $distanceText',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();

                routePlannerViewModel.clearRoute();
                for (final point in route.points) {
                  routePlannerViewModel.addRoutePoint(point);
                }
                routePlannerViewModel.confirmRoute();
                mapViewModel.setIsPlanningRoute(false);
                navigationStatusViewModel.startNavigation();
              },
              child: Text(
                l10n.startNavigationWithRoute,
                style: const TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        );
      },
    );
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

  void _editRouteName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routesViewModel = context.read<RoutesViewModel>();
    final nameController = TextEditingController(text: route.name);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black.withAlpha(240),
          title: Text(
            l10n.editRouteName,
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: l10n.routeName,
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  routesViewModel.updateRoute(
                    route.id,
                    nameController.text.trim(),
                  );
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(
                l10n.confirm,
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteRoute(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routesViewModel = context.read<RoutesViewModel>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.black.withAlpha(240),
          title: Text(
            l10n.deleteRoute,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${route.name}"?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                routesViewModel.deleteRoute(route.id);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
