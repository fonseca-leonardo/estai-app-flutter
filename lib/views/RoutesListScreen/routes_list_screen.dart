import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/route.dart' as route_model;
import '../../utils/route_geometry.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../../viewmodels/navigation_status_viewmodel.dart';
import '../../viewmodels/route_planner_viewmodel.dart';
import '../../viewmodels/routes_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/start_navigation_flow.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/empty_state.dart';
import '../../widgets/ui/glass_bar_background.dart';
import '../MapScreen/map_screen.dart';
import 'widgets/delete_route_dialog.dart';
import 'widgets/edit_route_name_dialog.dart';
import 'widgets/route_card.dart';
import 'widgets/route_details_dialog.dart';

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'RoutesListScreen';

  /// Carrega a rota no planejador e inicia a navegação com ela.
  Future<void> _openRoute(route_model.Route route) async {
    final routePlanner = context.read<RoutePlannerViewModel>();
    final mapViewModel = context.read<MapViewModel>();
    final navigationStatus = context.read<NavigationStatusViewModel>();

    final navigate = await showRouteDetailsDialog(context, route);
    if (!navigate || !mounted || route.points.isEmpty) return;

    navigationStatus.resetNavigation();
    routePlanner.clearRoute();
    for (final point in route.points) {
      routePlanner.addRoutePoint(point);
    }
    routePlanner.confirmRoute();
    mapViewModel.setIsPlanningRoute(false);

    final started = await StartNavigationFlow.start(
      context,
      plannedRoute: routePlanner.routePoints,
    );
    if (!started || !mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            MapScreen(initialLocation: RouteGeometry.center(route.points)),
      ),
    );
  }

  Future<void> _editName(route_model.Route route) async {
    final routes = context.read<RoutesViewModel>();
    final name = await showEditRouteNameDialog(
      context,
      currentName: route.name,
    );
    if (name != null) routes.updateRoute(route.id, name);
  }

  Future<void> _delete(route_model.Route route) async {
    final routes = context.read<RoutesViewModel>();
    final confirmed = await showDeleteRouteDialog(
      context,
      routeName: route.name,
    );
    if (confirmed) routes.deleteRoute(route.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.myRoutes),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: const GlassBarBackground(),
      ),
      body: Consumer<RoutesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.routes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (viewModel.routes.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.route,
                message: l10n.noRoutesFound,
                bordered: false,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.routes.length,
            itemBuilder: (context, index) {
              final route = viewModel.routes[index];
              return RouteCard(
                route: route,
                onTap: () => _openRoute(route),
                onEdit: () => _editName(route),
                onDelete: () => _delete(route),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
