import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/service_order_viewmodel.dart';
import '../../ServiceOrderFormScreen/service_order_form_screen.dart';
import '../../ServiceOrdersListScreen/service_orders_list_screen.dart';
import '../../ServiceOrdersListScreen/widgets/service_order_card.dart';
import 'tracking_empty_state.dart';
import 'tracking_see_all_button.dart';

/// Aba "Serviços" do acompanhamento: as 3 ordens mais recentes.
class RecentServiceOrdersList extends StatelessWidget {
  const RecentServiceOrdersList({super.key});

  Future<void> _cancelOrder(BuildContext context, String id) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final success = await context.read<ServiceOrderViewModel>().cancelOrder(id);
    if (!success) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.cancelServiceOrderError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<ServiceOrderViewModel>();
    final orders = viewModel.orders.take(3).toList();

    if (viewModel.isLoading && orders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (orders.isEmpty) {
      return TrackingEmptyState(
        icon: Icons.assignment_outlined,
        message: l10n.noServiceOrders,
        actionLabel: l10n.marinaActionServiceOrder,
        onAction: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ServiceOrderFormScreen()),
        ),
      );
    }

    return Column(
      children: [
        ...orders.map(
          (order) => ServiceOrderCard(
            order: order,
            onCancel: () => _cancelOrder(context, order.id),
          ),
        ),
        TrackingSeeAllButton(
          label: l10n.marinaSeeAllServiceOrders,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ServiceOrdersListScreen()),
          ),
        ),
      ],
    );
  }
}
