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
import 'widgets/navigation_status.dart';
import 'widgets/weather_pin_addition_mode.dart';
import 'widgets/add_pin_dialog.dart';
import 'widgets/tracked_route_line.dart';
import '../../viewmodels/route_planner_viewmodel.dart';
import '../../viewmodels/navigation_status_viewmodel.dart';
import '../../viewmodels/list_maps_viewmodel.dart';
import '../../viewmodels/ad_banner_viewmodel.dart';
import '../../viewmodels/weather_monitor_pins_viewmodel.dart';
import '../../services/cached_tile_provider.dart';
import '../../services/tile_cache_service.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/analytics_screen_mixin.dart';
import 'widgets/offline_basemap_layer.dart';
import 'widgets/raster_charts_layer.dart';
import 'widgets/chartplotter_layer.dart';
import 'widgets/chartplotter_crosshair.dart';
import 'widgets/chartplotter_camera_sync.dart';
import 'widgets/chartplotter_actions_bar.dart';
import 'widgets/weather_monitor_pins_layer.dart';
import 'widgets/weather_pin_forecast_bottom_sheet.dart';
import 'widgets/anchor_alarm_layer.dart';
import 'widgets/anchor_alarm_selection_banner.dart';
import 'widgets/anchor_alarm_set_radius_dialog.dart';
import 'widgets/anchor_alarm_triggered_overlay.dart';
import 'widgets/map_onboarding_overlay.dart';
import 'widgets/resume_navigation_dialog.dart';
import '../../viewmodels/anchor_alarm_viewmodel.dart';
import '../../viewmodels/onboarding_viewmodel.dart';
import '../../services/anchor_alarm_notification_service.dart';
import '../NavigationPermissionScreen/navigation_permission_screen.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String? pinIdToOpen;

  const MapScreen({super.key, this.initialLocation, this.pinIdToOpen});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with WidgetsBindingObserver, AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MapScreen';

  final MapController _mapController = MapController();
  bool _hasMovedToLocation = false;
  bool _hasMovedToInitialLocation = false;
  bool _hasOpenedPinBottomSheet = false;
  LatLng? _lastTrackedPoint;
  MapViewModel? _mapViewModel;
  NavigationStatusViewModel? _navigationStatusViewModel;
  AnchorAlarmViewModel? _anchorAlarmViewModel;

  static const LatLng _initialPosition = LatLng(-23.5505, -46.6333);
  static const double _initialZoom = 14.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mapViewModel = context.read<MapViewModel>();
    _navigationStatusViewModel = context.read<NavigationStatusViewModel>();
    _anchorAlarmViewModel = context.read<AnchorAlarmViewModel>();

    _mapViewModel!.onPermissionError = _navigateToPermissionScreen;
    _mapViewModel!.addListener(_handlePositionUpdate);

    _anchorAlarmViewModel!.onAlarmTriggered =
        AnchorAlarmNotificationService.instance.triggerAlarm;
    _anchorAlarmViewModel!.onAlarmRestored =
        AnchorAlarmNotificationService.instance.stopAlarm;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowOnboarding();
    });
  }

  Future<void> _maybeShowOnboarding() async {
    if (!mounted) return;
    final onboardingViewModel = context.read<OnboardingViewModel>();
    await onboardingViewModel.loadMapOnboardingState();
    if (!mounted) return;
    if (onboardingViewModel.shouldShowMapOnboarding) {
      await MapOnboardingOverlay.show(context);
    }
    if (!mounted) return;
    await _maybeResumeNavigation();
  }

  Future<void> _maybeResumeNavigation() async {
    if (!mounted) return;
    final navigationStatusViewModel = context
        .read<NavigationStatusViewModel>();
    if (navigationStatusViewModel.isNavigating) return;

    final snapshot = await navigationStatusViewModel
        .loadPersistedNavigation();
    if (snapshot == null || !mounted) return;

    final shouldResume = await ResumeNavigationDialog.show(context, snapshot);
    if (!mounted) return;

    if (shouldResume == true) {
      if (snapshot.plannedRoute.isNotEmpty) {
        context.read<RoutePlannerViewModel>().restoreRoute(
          snapshot.plannedRoute,
        );
      }
      navigationStatusViewModel.resumeFromPersisted(snapshot);
    } else if (shouldResume == false) {
      await navigationStatusViewModel.discardPersisted();
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

    final currentLatLng = LatLng(position.latitude, position.longitude);

    if (_navigationStatusViewModel?.isNavigating == true) {
      if (_lastTrackedPoint == null || _lastTrackedPoint != currentLatLng) {
        _navigationStatusViewModel!.addTrackedPoint(currentLatLng);
        _lastTrackedPoint = currentLatLng;
      }
    } else {
      _lastTrackedPoint = null;
    }

    _anchorAlarmViewModel?.checkPosition(currentLatLng);
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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _navigationStatusViewModel?.flushTrackedRoute();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapViewModel?.removeListener(_handlePositionUpdate);
    _mapViewModel?.onPermissionError = null;
    _anchorAlarmViewModel?.onAlarmTriggered = null;
    _anchorAlarmViewModel?.onAlarmRestored = null;
    _mapController.dispose();
    super.dispose();
  }

  void _moveToCurrentLocation(Position position) {
    _mapController.move(LatLng(position.latitude, position.longitude), 14.0);
  }

  void _navigateToPermissionScreen() {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NavigationPermissionScreen(),
        ),
      );
    }
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
                                          tileProvider:
                                              mapsViewModel.isMapCached(
                                                mapItem.id,
                                              )
                                              ? CachedTileProvider(
                                                  mapId: mapItem.id,
                                                  darkMode:
                                                      mapsViewModel.darkMode,
                                                  cacheService:
                                                      TileCacheService.instance,
                                                )
                                              : NetworkTileProvider(),
                                          errorTileCallback:
                                              (tile, error, stackTrace) {},
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
                                onTap: (tapPosition, point) {
                                  final anchorVm = context
                                      .read<AnchorAlarmViewModel>();
                                  if (anchorVm.isSettingAnchor) {
                                    AnchorAlarmSetRadiusDialog.show(
                                      context,
                                      point,
                                      (r) => anchorVm.setAlarm(point, r),
                                    );
                                  }
                                },
                                onLongPress: (tapPosition, point) {
                                  final routePlannerViewModel = context
                                      .read<RoutePlannerViewModel>();
                                  final pinsViewModel = context
                                      .read<WeatherMonitorPinsViewModel>();

                                  if (mapViewModel.isPlanningRoute) {
                                    if (routePlannerViewModel.draggingIndex ==
                                        null) {
                                      routePlannerViewModel.addRoutePoint(
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
                                const OfflineBasemapLayer(),
                                ...customTileLayers,
                                const RasterChartsLayer(),
                                const ChartplotterLayer(),
                                const ChartplotterCameraSync(),
                                const PlannedRouteLine(),
                                PlannedRouteMarkers(
                                  mapController: _mapController,
                                ),
                                const TrackedRouteLine(),
                                MapDirectionLine(mapController: _mapController),
                                MapUserMarker(mapController: _mapController),
                                const WeatherMonitorPinsLayer(),
                                const AnchorAlarmLayer(),
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
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const ChartplotterCrosshair(),

              const ChartplotterActionsBar(),

              const MapNavigationData(),

              const RouteDistance(),

              const MapActionsButtons(),

              const RoutePlanner(),

              const WeatherPinAdditionMode(),

              const AnchorAlarmSelectionBanner(),

              const AnchorAlarmTriggeredOverlay(),

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
                      const defaultBottom = 32.0;
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
                                    Icons.square,
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
