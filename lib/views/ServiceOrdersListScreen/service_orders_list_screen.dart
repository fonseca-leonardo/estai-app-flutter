import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/service_order_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import 'widgets/service_order_card.dart';
import 'widgets/service_order_status_filter.dart';

class ServiceOrdersListScreen extends StatefulWidget {
  const ServiceOrdersListScreen({super.key});

  @override
  State<ServiceOrdersListScreen> createState() =>
      _ServiceOrdersListScreenState();
}

class _ServiceOrdersListScreenState extends State<ServiceOrdersListScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ServiceOrdersListScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceOrderViewModel>().loadOrders();
    });
  }

  Future<void> _cancelOrder(String id) async {
    final viewModel = context.read<ServiceOrderViewModel>();
    final success = await viewModel.cancelOrder(id);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cancelServiceOrderError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundFile = context.select<EstaiSessionViewModel, File?>(
      (vm) => vm.backgroundFile,
    );
    final hasBackground = backgroundFile != null;
    final topInset = hasBackground
        ? MediaQuery.paddingOf(context).top + kToolbarHeight
        : 0.0;

    return Consumer<ServiceOrderViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          extendBodyBehindAppBar: hasBackground,
          appBar: AppBar(
            title: Text(l10n.myServiceOrders),
            backgroundColor: hasBackground
                ? Colors.transparent
                : Colors.black.withAlpha(200),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              Builder(
                builder: (context) => IconButton(
                  tooltip: l10n.filterByStatus,
                  icon: Icon(
                    viewModel.statusFilter == null
                        ? Icons.filter_list
                        : Icons.filter_list_alt,
                  ),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          endDrawer: ServiceOrderStatusFilterDrawer(
            selected: viewModel.statusFilter,
            onChanged: viewModel.setStatusFilter,
          ),
          body: MarinaBackground(
            backgroundFile: backgroundFile,
            child: Column(
              children: [
                SizedBox(height: topInset + 12),
                Expanded(child: _buildBody(context, l10n, viewModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ServiceOrderViewModel viewModel,
  ) {
    if (viewModel.isLoading && viewModel.orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.loadServiceOrdersError,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => viewModel.loadOrders(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    if (viewModel.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.statusFilter == null
                  ? l10n.noServiceOrders
                  : l10n.noServiceOrdersWithFilter,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.orders.length,
        itemBuilder: (context, index) {
          final order = viewModel.orders[index];
          return ServiceOrderCard(
            order: order,
            onCancel: () => _cancelOrder(order.id),
          );
        },
      ),
    );
  }
}
