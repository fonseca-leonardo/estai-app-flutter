import 'dart:async';
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
import 'widgets/weather_pin_addition_mode.dart';
import 'widgets/add_pin_dialog.dart';
import 'widgets/tracked_route_line.dart';
import '../../viewmodels/route_planner_viewmodel.dart';
import '../../viewmodels/navigation_status_viewmodel.dart';
import '../../viewmodels/list_maps_viewmodel.dart';
import '../../viewmodels/ad_banner_viewmodel.dart';
import '../../viewmodels/weather_monitor_pins_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';
import 'widgets/weather_monitor_pins_layer.dart';
import 'widgets/weather_pin_forecast_bottom_sheet.dart';
import 'widgets/location_error_dialog.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String? pinIdToOpen;

  const MapScreen({super.key, this.initialLocation, this.pinIdToOpen});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  bool _hasMovedToLocation = false;
  bool _hasMovedToInitialLocation = false;
  bool _hasOpenedPinBottomSheet = false;
  bool _locationErrorDialogShown = false;
  LatLng? _lastTrackedPoint;
  MapViewModel? _mapViewModel;
  NavigationStatusViewModel? _navigationStatusViewModel;

  static const LatLng _initialPosition = LatLng(-23.5505, -46.6333);
  static const double _initialZoom = 14.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mapViewModel = context.read<MapViewModel>();
    _navigationStatusViewModel = context.read<NavigationStatusViewModel>();

    _mapViewModel!.addListener(_handlePositionUpdate);

    if (widget.initialLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasMovedToInitialLocation) {
          _mapController.move(widget.initialLocation!, 12.0);
          _hasMovedToInitialLocation = true;

          if (widget.pinIdToOpen != null) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && !_hasOpenedPinBottomSheet) {
                _openPinBottomSheet();
                _hasOpenedPinBottomSheet = true;
              }
            });
          }
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapViewModel!.getCurrentLocation();
      });
    }
  }

  void _handlePositionUpdate() {
    if (!mounted) return;

    final position = _mapViewModel?.currentPosition;
    if (position == null) return;

    if (!_hasMovedToLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _moveToCurrentLocation(position);
          _hasMovedToLocation = true;
        }
      });
    }

    if (_navigationStatusViewModel?.isNavigating == true) {
      final currentLatLng = LatLng(position.latitude, position.longitude);
      if (_lastTrackedPoint == null || _lastTrackedPoint != currentLatLng) {
        _navigationStatusViewModel!.addTrackedPoint(currentLatLng);
        _lastTrackedPoint = currentLatLng;
      }
    } else {
      _lastTrackedPoint = null;
    }
  }

  void _openPinBottomSheet() {
    final pinsViewModel = context.read<WeatherMonitorPinsViewModel>();
    final pin = pinsViewModel.getPinById(widget.pinIdToOpen!);
    if (pin != null && mounted) {
      WeatherPinForecastBottomSheet.show(context, pin);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _mapViewModel?.errorMessage != null) {
      _mapViewModel!.getCurrentLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapViewModel?.removeListener(_handlePositionUpdate);
    _mapController.dispose();
    super.dispose();
  }

  void _moveToCurrentLocation(Position position) {
    _mapController.move(LatLng(position.latitude, position.longitude), 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<MapViewModel, Position?>(
        selector: (_, viewModel) => viewModel.currentPosition,
        builder: (context, position, child) {
          LatLng centerPosition;
          double zoom;

          if (widget.initialLocation != null) {
            centerPosition = widget.initialLocation!;
            zoom = 12.0;
          } else if (position != null) {
            centerPosition = LatLng(position.latitude, position.longitude);
            zoom = 8.0;
          } else {
            centerPosition = _initialPosition;
            zoom = _initialZoom;
          }

          return Stack(
            children: [
              Selector<MapViewModel, bool>(
                selector: (_, viewModel) => viewModel.isPlanningRoute,
                builder: (context, isPlanningRoute, child) {
                  return Listener(
                    onPointerMove: isPlanningRoute
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
                    onPointerUp: isPlanningRoute
                        ? (_) {
                            context
                                .read<RoutePlannerViewModel>()
                                .stopDragging();
                          }
                        : null,
                    child: Selector<RoutePlannerViewModel, int?>(
                      selector: (_, viewModel) => viewModel.draggingIndex,
                      builder: (context, draggingIndex, child) {
                        return Consumer2<MapViewModel, ListMapsViewModel>(
                          builder: (context, mapViewModel, mapsViewModel, _) {
                            final customTileLayers =
                                mapViewModel.showCustomTiles
                                ? mapsViewModel.selectedMaps
                                      .map(
                                        (mapItem) => TileLayer(
                                          urlTemplate:
                                              '${mapItem.path}${mapsViewModel.darkMode ? '?dark=true' : ''}',
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
                                onLongPress: (tapPosition, point) {
                                  final routePlannerViewModel = context
                                      .read<RoutePlannerViewModel>();
                                  final pinsViewModel = context
                                      .read<WeatherMonitorPinsViewModel>();

                                  if (mapViewModel.isPlanningRoute) {
                                    if (routePlannerViewModel.draggingIndex ==
                                        null) {
                                      routePlannerViewModel.setPendingPoint(
                                        point,
                                      );
                                    }
                                  } else if (pinsViewModel.isAddingPin) {
                                    AddPinDialog.show(
                                      context,
                                      point,
                                      pinsViewModel,
                                    );
                                  }
                                },
                              ),
                              children: [
                                ...customTileLayers,
                                const PlannedRouteLine(),
                                PlannedRouteMarkers(
                                  mapController: _mapController,
                                ),
                                const TrackedRouteLine(),
                                MapDirectionLine(mapController: _mapController),
                                MapUserMarker(mapController: _mapController),
                                const WeatherMonitorPinsLayer(),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              Selector<MapViewModel, bool>(
                selector: (_, viewModel) => viewModel.isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Selector<MapViewModel, String?>(
                selector: (_, viewModel) => viewModel.errorMessage,
                builder: (context, errorMessage, child) {
                  if (errorMessage == null) {
                    if (_locationErrorDialogShown) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _locationErrorDialogShown = false);
                        }
                      });
                    }
                    return const SizedBox.shrink();
                  }
                  if (!_locationErrorDialogShown) {
                    final errorKey = errorMessage;
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      if (!mounted) return;
                      final mapViewModel = context.read<MapViewModel>();
                      if (mapViewModel.errorMessage == null) return;
                      final permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.whileInUse ||
                          permission == LocationPermission.always) {
                        mapViewModel.getCurrentLocation();
                        return;
                      }
                      if (!mounted) return;
                      setState(() => _locationErrorDialogShown = true);
                      LocationErrorDialog.show(
                        context,
                        errorKey: errorKey,
                      ).then((_) {
                        if (mounted) {
                          setState(() => _locationErrorDialogShown = false);
                        }
                      });
                    });
                  }
                  return const SizedBox.shrink();
                },
              ),

              const MapNavigationData(),

              const RouteDistance(),

              const MapActionsButtons(),

              const RoutePlanner(),

              const RoutePointConfirmation(),

              const WeatherPinAdditionMode(),

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
