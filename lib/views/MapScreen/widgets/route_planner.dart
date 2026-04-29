import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/map_viewmodel.dart';
import '../../../viewmodels/route_planner_viewmodel.dart';
import '../../../viewmodels/ad_banner_viewmodel.dart';
import 'save_route_dialog.dart';

class RoutePlanner extends StatelessWidget {
  const RoutePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            return Consumer<AdBannerViewModel>(
              builder: (context, adBannerViewModel, child) {
                const bannerHeight = 60.0;
                const defaultBottom = 32.0;
                final bottomOffset = adBannerViewModel.isLoaded
                    ? defaultBottom + bannerHeight + 8
                    : defaultBottom;

                return Positioned(
                  bottom: bottomOffset,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(140),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Text(
                              l10n.tapMapToAddPin,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
                                      ? () async {
                                          final l10n = AppLocalizations.of(
                                            context,
                                          )!;
                                          final routePlannerViewModel = context
                                              .read<RoutePlannerViewModel>();
                                          final mapViewModel = context
                                              .read<MapViewModel>();

                                          final result =
                                              await SaveRouteDialog.show(
                                                context,
                                              );

                                          if (result != null) {
                                            routePlannerViewModel
                                                .confirmRoute();
                                            mapViewModel.setIsPlanningRoute(
                                              false,
                                            );

                                            if (result.saveForReuse) {
                                              try {
                                                await routePlannerViewModel
                                                    .saveRoute(
                                                      context,
                                                      result.routeName,
                                                    );

                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        l10n.routeSaved,
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        l10n.errorSavingRoute,
                                                      ),
                                                      backgroundColor:
                                                          Colors.orange,
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          }
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
                                context
                                    .read<RoutePlannerViewModel>()
                                    .clearRoute();
                              },
                              backgroundColor: Colors.red.withAlpha(200),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
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
      },
    );
  }
}
