import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/service_order_status.dart';

Color serviceOrderStatusColor(ServiceOrderStatus status) {
  switch (status) {
    case ServiceOrderStatus.pending:
      return Colors.amber;
    case ServiceOrderStatus.scheduled:
      return Colors.lightBlueAccent;
    case ServiceOrderStatus.inProgress:
      return Colors.purpleAccent;
    case ServiceOrderStatus.completed:
      return Colors.greenAccent;
    case ServiceOrderStatus.cancelled:
      return Colors.grey;
  }
}

class ServiceOrderStatusChip extends StatelessWidget {
  final ServiceOrderStatus status;

  const ServiceOrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = serviceOrderStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label(l10n),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
