import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../TideScreen/tide_screen.dart';
import '../../SettingsScreen/settings_screen.dart';
import '../../RoutesListScreen/routes_list_screen.dart';
import '../../ListMapsScreen/list_maps_screen.dart';
import '../../NavigationPermissionScreen/navigation_permission_screen.dart';
import 'feedback_suggestion_dialog.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../viewmodels/navigation_status_viewmodel.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';
import '../../../viewmodels/weather_monitor_pins_viewmodel.dart';
import '../../../viewmodels/anchor_alarm_viewmodel.dart';
import '../../../services/anchor_alarm_notification_service.dart';

class MapBottomSheet extends StatelessWidget {
  final BuildContext? parentContext;

  const MapBottomSheet({super.key, this.parentContext});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(164, 0, 0, 0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Selector<NavigationStatusViewModel, bool>(
              selector: (_, viewModel) => viewModel.isNavigating,
              builder: (context, isNavigating, child) {
                return Consumer<WeatherMonitorPinsViewModel>(
                  builder: (context, pinsViewModel, child) {
                    final isAddingPin = pinsViewModel.isAddingPin;
                    final isNewRouteDisabled = isNavigating || isAddingPin;

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      children: [
                        _GridItem(
                          icon: Icons.navigation,
                          title: l10n.navigate,
                          onTap: isNavigating
                              ? null
                              : () {
                                  final navigatorContext =
                                      parentContext ?? context;
                                  Navigator.pop(context);
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (navigatorContext.mounted) {
                                      final navigationStatusViewModel =
                                          Provider.of<
                                            NavigationStatusViewModel
                                          >(navigatorContext, listen: false);
                                      if (navigationStatusViewModel
                                          .isNavigating) {
                                        navigationStatusViewModel
                                            .stopNavigation();
                                        navigationStatusViewModel
                                            .resetNavigation();
                                      } else {
                                        final routePlannerViewModel =
                                            Provider.of<RoutePlannerViewModel>(
                                              navigatorContext,
                                              listen: false,
                                            );
                                        navigationStatusViewModel
                                            .startNavigation(
                                              plannedRoute:
                                                  routePlannerViewModel
                                                      .routePoints,
                                            );
                                      }
                                    }
                                  });
                                },
                        ),
                        _GridItem(
                          icon: Icons.route,
                          title: l10n.newRoute,
                          onTap: isNewRouteDisabled
                              ? null
                              : () {
                                  final navigatorContext =
                                      parentContext ?? context;
                                  final viewModel = Provider.of<MapViewModel>(
                                    navigatorContext,
                                    listen: false,
                                  );
                                  final routePlannerViewModel =
                                      Provider.of<RoutePlannerViewModel>(
                                        navigatorContext,
                                        listen: false,
                                      );
                                  Navigator.pop(context);
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (navigatorContext.mounted) {
                                      routePlannerViewModel.clearRoute();
                                      viewModel.setIsPlanningRoute(true);
                                    }
                                  });
                                },
                        ),
                        _GridItem(
                          icon: Icons.list,
                          title: l10n.myRoutes,
                          onTap: () {
                            final navigatorContext = parentContext ?? context;
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (navigatorContext.mounted) {
                                Navigator.of(navigatorContext).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RoutesListScreen(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        _GridItem(
                          icon: Icons.water_drop,
                          title: l10n.tides,
                          onTap: () {
                            final navigatorContext = parentContext ?? context;
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (navigatorContext.mounted) {
                                Navigator.of(navigatorContext).push(
                                  MaterialPageRoute(
                                    builder: (context) => const TideScreen(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        _GridItem(
                          icon: Icons.map,
                          title: l10n.maps,
                          onTap: () {
                            final navigatorContext = parentContext ?? context;
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (navigatorContext.mounted) {
                                Navigator.of(navigatorContext).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ListMapsScreen(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        _GridItem(
                          icon: Icons.settings,
                          title: l10n.adjustments,
                          onTap: () {
                            final navigatorContext = parentContext ?? context;
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (navigatorContext.mounted) {
                                Navigator.of(navigatorContext).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        _GridItem(
                          icon: Icons.lightbulb,
                          title: l10n.improvementsAndSuggestions,
                          onTap: () {
                            final navigatorContext = parentContext ?? context;
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (navigatorContext.mounted) {
                                FeedbackSuggestionDialog.show(navigatorContext);
                              }
                            });
                          },
                        ),
                        Consumer<AnchorAlarmViewModel>(
                          builder: (context, anchorVm, child) {
                            final isActive = anchorVm.isActive;
                            return _GridItem(
                              icon: Icons.anchor,
                              title: isActive
                                  ? l10n.anchorAlarmActive
                                  : l10n.anchorAlarm,
                              isHighlighted: isActive,
                              onTap: () {
                                final navigatorContext =
                                    parentContext ?? context;
                                Navigator.pop(context);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  if (!navigatorContext.mounted) return;
                                  if (isActive) {
                                    anchorVm.clearAlarm();
                                  } else {
                                    await AnchorAlarmNotificationService
                                        .requestPermissionIfNeeded(
                                            navigatorContext);
                                    if (navigatorContext.mounted) {
                                      anchorVm.setSettingAnchorMode(true);
                                    }
                                  }
                                });
                              },
                            );
                          },
                        ),
                        _GridItem(
                          icon: Icons.location_on,
                          title: l10n.navigationPermission,
                          onTap: () {
                            final navigatorContext = parentContext ?? context;
                            Navigator.pop(context);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (navigatorContext.mounted) {
                                Navigator.of(navigatorContext).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NavigationPermissionScreen(),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.65),
      isScrollControlled: true,
      useRootNavigator: false,
      enableDrag: true,
      useSafeArea: true,
      builder: (bottomSheetContext) => MapBottomSheet(parentContext: context),
    );
  }
}

class _GridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const _GridItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: isHighlighted
                ? Border.all(color: Colors.white.withValues(alpha: 0.6))
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
