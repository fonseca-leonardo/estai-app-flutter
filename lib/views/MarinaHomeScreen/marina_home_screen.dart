import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/service_order_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import '../BoatsListScreen/boats_list_screen.dart';
import '../ServiceOrderFormScreen/service_order_form_screen.dart';
import '../ServiceOrdersListScreen/service_orders_list_screen.dart';
import '../ServiceOrdersListScreen/widgets/service_order_card.dart';
import 'widgets/marina_action_card.dart';
import 'widgets/marina_header_card.dart';

class MarinaHomeScreen extends StatefulWidget {
  const MarinaHomeScreen({super.key});

  @override
  State<MarinaHomeScreen> createState() => _MarinaHomeScreenState();
}

class _MarinaHomeScreenState extends State<MarinaHomeScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MarinaHomeScreen';

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

    return Scaffold(
      extendBodyBehindAppBar: hasBackground,
      appBar: AppBar(
        title: Text(l10n.marinaHomeTitle),
        backgroundColor: hasBackground
            ? Colors.transparent
            : Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: MarinaBackground(
        backgroundFile: backgroundFile,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MarinaHeaderCard(),
              const SizedBox(height: 20),
              MarinaActionCard(
                icon: Icons.directions_boat,
                title: l10n.myBoats,
                subtitle: l10n.marinaHomeMyBoatsSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BoatsListScreen()),
                ),
              ),
              MarinaActionCard(
                icon: Icons.add_task,
                title: l10n.newServiceOrder,
                subtitle: l10n.newServiceOrderSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ServiceOrderFormScreen(),
                  ),
                ),
              ),
              MarinaActionCard(
                icon: Icons.assignment_outlined,
                title: l10n.myServiceOrders,
                subtitle: l10n.myServiceOrdersSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ServiceOrdersListScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentServiceOrders,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ServiceOrdersListScreen(),
                      ),
                    ),
                    child: Text(l10n.seeAllServiceOrders),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Consumer<ServiceOrderViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.orders.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  if (viewModel.errorMessage != null) {
                    return const SizedBox.shrink();
                  }

                  if (viewModel.orders.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        l10n.noServiceOrders,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  }

                  final recentOrders = viewModel.orders.take(3);
                  return Column(
                    children: recentOrders
                        .map(
                          (order) => ServiceOrderCard(
                            order: order,
                            onCancel: () => _cancelOrder(order.id),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
