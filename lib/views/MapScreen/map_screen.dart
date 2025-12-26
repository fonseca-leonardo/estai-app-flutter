import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../l10n/app_localizations.dart';
import 'dart:math' as math;
import '../../viewmodels/map_viewmodel.dart';
import 'widgets/map_actions_buttons.dart';
import 'widgets/map_navigation_data.dart';
import 'widgets/route_distance.dart';
import 'widgets/map_user_marker.dart';
import 'widgets/map_bottom_sheet.dart';
import 'widgets/map_direction_line.dart';
import 'widgets/route_planner.dart';
import 'widgets/planned_route_line.dart';
import 'widgets/planned_route_markers.dart';
import 'widgets/route_point_confirmation.dart';
import 'widgets/navigation_status.dart';
import 'widgets/tracked_route_line.dart';
import '../../viewmodels/route_planner_viewmodel.dart';
import '../../viewmodels/navigation_status_viewmodel.dart';
import '../../viewmodels/list_maps_viewmodel.dart';
import '../../viewmodels/ad_banner_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _hasMovedToLocation = false;
  LatLng? _lastTrackedPoint;

  static const LatLng _initialPosition = LatLng(-23.5505, -46.6333);
  static const double _initialZoom = 8.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapViewModel>().getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _moveToCurrentLocation(Position position) {
    _mapController.move(LatLng(position.latitude, position.longitude), 8.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapViewModel>(
        builder: (context, viewModel, child) {
          LatLng centerPosition;
          double zoom;

          if (viewModel.currentPosition != null) {
            final position = viewModel.currentPosition!;
            centerPosition = LatLng(position.latitude, position.longitude);
            zoom = 8.0;
            if (!_hasMovedToLocation) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _moveToCurrentLocation(position);
                _hasMovedToLocation = true;
              });
            }

            final currentLatLng = LatLng(position.latitude, position.longitude);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final navigationStatusViewModel = context
                  .read<NavigationStatusViewModel>();
              if (navigationStatusViewModel.isNavigating) {
                if (_lastTrackedPoint == null ||
                    _lastTrackedPoint != currentLatLng) {
                  navigationStatusViewModel.addTrackedPoint(currentLatLng);
                  _lastTrackedPoint = currentLatLng;
                }
              } else {
                _lastTrackedPoint = null;
              }
            });
          } else {
            centerPosition = _initialPosition;
            zoom = _initialZoom;
          }

          return Stack(
            children: [
              Listener(
                onPointerMove: viewModel.isPlanningRoute
                    ? (event) {
                        final routePlannerViewModel = context
                            .read<RoutePlannerViewModel>();
                        final draggingIndex =
                            routePlannerViewModel.draggingIndex;
                        if (draggingIndex != null) {
                          final renderBox =
                              context.findRenderObject() as RenderBox?;
                          if (renderBox != null) {
                            final localPosition = renderBox.globalToLocal(
                              event.position,
                            );
                            try {
                              final camera = _mapController.camera;
                              final point = math.Point(
                                localPosition.dx,
                                localPosition.dy,
                              );
                              final newPoint = camera.pointToLatLng(point);
                              routePlannerViewModel.updateRoutePoint(
                                draggingIndex,
                                newPoint,
                              );
                            } catch (e) {
                              // Ignora erros de conversão
                            }
                          }
                        }
                      }
                    : null,
                onPointerUp: viewModel.isPlanningRoute
                    ? (_) {
                        context.read<RoutePlannerViewModel>().stopDragging();
                      }
                    : null,
                child: Selector<RoutePlannerViewModel, int?>(
                  selector: (_, viewModel) => viewModel.draggingIndex,
                  builder: (context, draggingIndex, child) {
                    return Selector<MapViewModel, bool>(
                      selector: (_, viewModel) => viewModel.isPlanningRoute,
                      builder: (context, isPlanningRoute, child) {
                        return Consumer2<MapViewModel, ListMapsViewModel>(
                          builder: (context, mapViewModel, mapsViewModel, _) {
                            final customTileLayers =
                                mapViewModel.showCustomTiles
                                ? mapsViewModel.selectedMaps
                                      .map(
                                        (mapItem) => TileLayer(
                                          urlTemplate:
                                              'https://maps-api.estai.com.br/maps/${mapItem.path}/{z}/{x}/{y}.png${mapsViewModel.darkMode ? '?dark=true' : ''}',
                                          userAgentPackageName: 'com.br.estai',
                                          maxZoom: mapItem.maxZoom.toDouble(),
                                          minZoom: mapItem.minZoom.toDouble(),
                                          errorTileCallback:
                                              (tile, error, stackTrace) {
                                                return null;
                                              },
                                        ),
                                      )
                                      .toList()
                                : <Widget>[];

                            return FlutterMap(
                              key: const ValueKey('map'),
                              mapController: _mapController,

                              options: MapOptions(
                                initialCenter: centerPosition,
                                initialZoom: zoom,
                                minZoom: 3.0,
                                maxZoom: 20.0,
                                interactionOptions: InteractionOptions(
                                  flags:
                                      draggingIndex != null && isPlanningRoute
                                      ? InteractiveFlag.none
                                      : InteractiveFlag.all &
                                            ~InteractiveFlag.rotate,
                                ),
                                onLongPress: mapViewModel.isPlanningRoute
                                    ? (tapPosition, point) {
                                        final routePlannerViewModel = context
                                            .read<RoutePlannerViewModel>();
                                        if (routePlannerViewModel
                                                .draggingIndex ==
                                            null) {
                                          routePlannerViewModel.setPendingPoint(
                                            point,
                                          );
                                        }
                                      }
                                    : null,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.br.estai',
                                  maxZoom: 22,
                                  minZoom: 1,
                                  errorTileCallback: (tile, error, stackTrace) {
                                    return null;
                                  },
                                ),
                                ...customTileLayers,
                                TileLayer(
                                  urlTemplate:
                                      'https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.br.estai',
                                  maxZoom: 18,
                                  minZoom: 1,
                                  errorTileCallback: (tile, error, stackTrace) {
                                    return null;
                                  },
                                ),
                                const PlannedRouteLine(),
                                PlannedRouteMarkers(
                                  mapController: _mapController,
                                ),
                                const TrackedRouteLine(),
                                MapDirectionLine(mapController: _mapController),
                                MapUserMarker(mapController: _mapController),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              if (viewModel.errorMessage != null)
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      final errorKey = viewModel.errorMessage!;
                      String errorText;
                      if (errorKey.contains(':')) {
                        final parts = errorKey.split(':');
                        final key = parts[0];
                        final param = parts.length > 1 ? parts[1] : '';
                        switch (key) {
                          case 'errorGettingLocation':
                            errorText = l10n.errorGettingLocation(param);
                            break;
                          case 'errorUpdatingLocation':
                            errorText = l10n.errorUpdatingLocation(param);
                            break;
                          default:
                            errorText = errorKey;
                        }
                      } else {
                        switch (errorKey) {
                          case 'locationServicesDisabled':
                            errorText = l10n.locationServicesDisabled;
                            break;
                          case 'locationPermissionDenied':
                            errorText = l10n.locationPermissionDenied;
                            break;
                          case 'locationPermissionDeniedForever':
                            errorText = l10n.locationPermissionDeniedForever;
                            break;
                          default:
                            errorText = errorKey;
                        }
                      }
                      return Card(
                        color: Colors.red[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      errorText,
                                      style: TextStyle(color: Colors.red[900]),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => viewModel.getCurrentLocation(),
                                child: Text(l10n.tryAgain),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const MapNavigationData(),

              const RouteDistance(),

              const MapActionsButtons(),

              const RoutePlanner(),

              const RoutePointConfirmation(),

              const NavigationStatus(),

              Selector<MapViewModel, bool>(
                selector: (_, viewModel) => viewModel.isPlanningRoute,
                builder: (context, isPlanningRoute, child) {
                  if (isPlanningRoute) {
                    return const SizedBox.shrink();
                  }
                  return Consumer<AdBannerViewModel>(
                    builder: (context, adBannerViewModel, child) {
                      const bannerHeight = 60.0;
                      const defaultBottom = 20.0;
                      final bottomOffset = adBannerViewModel.isLoaded
                          ? defaultBottom + bannerHeight + 8
                          : defaultBottom;

                      return Positioned(
                        bottom: bottomOffset,
                        right: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 12,
                          children: [
                            Selector<NavigationStatusViewModel, bool>(
                              selector: (_, viewModel) =>
                                  viewModel.isNavigating,
                              builder: (context, isNavigating, child) {
                                if (!isNavigating) {
                                  return const SizedBox.shrink();
                                }
                                return FloatingActionButton(
                                  heroTag: 'stop_navigation_button',
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        final l10n = AppLocalizations.of(
                                          dialogContext,
                                        )!;
                                        return AlertDialog(
                                          backgroundColor: Colors.black
                                              .withAlpha(180),
                                          title: Text(
                                            l10n.finishNavigation,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          content: Text(
                                            l10n.finishNavigationQuestion,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                              },
                                              child: Text(
                                                l10n.cancel,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<
                                                      NavigationStatusViewModel
                                                    >()
                                                    .stopNavigation();
                                                context
                                                    .read<
                                                      NavigationStatusViewModel
                                                    >()
                                                    .resetNavigation();
                                                context
                                                    .read<
                                                      RoutePlannerViewModel
                                                    >()
                                                    .clearRoute();
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                              },
                                              child: Text(
                                                l10n.finish,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  backgroundColor: Colors.orange.withAlpha(200),
                                  child: const Icon(
                                    Icons.flag,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                            FloatingActionButton(
                              heroTag: 'map_bottom_sheet_button',
                              onPressed: () => MapBottomSheet.show(context),
                              backgroundColor: Colors.black.withAlpha(140),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.white.withAlpha(64),
                                ),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AdBannerWidget(),
              ),
            ],
          );
        },
      ),
    );
  }
}
