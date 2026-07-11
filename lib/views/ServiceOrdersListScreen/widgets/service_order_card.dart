import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/service_order.dart';
import 'cancel_order_dialog.dart';
import 'service_order_status_chip.dart';

class ServiceOrderCard extends StatefulWidget {
  final ServiceOrder order;
  final VoidCallback onCancel;

  const ServiceOrderCard({
    super.key,
    required this.order,
    required this.onCancel,
  });

  @override
  State<ServiceOrderCard> createState() => _ServiceOrderCardState();
}

class _ServiceOrderCardState extends State<ServiceOrderCard> {
  bool _expanded = false;

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_Hm().format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final order = widget.order;
    final locale = Localizations.localeOf(context).toString();
    final priceFormat = NumberFormat.simpleCurrency(locale: locale);
    final headerDate = order.scheduledAt ?? order.createdAt;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.priceItemName ?? '—',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.boatName ?? '—',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(context, headerDate),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ServiceOrderStatusChip(status: order.status),
                ],
              ),
              if (_expanded) ...[
                const Divider(color: Colors.white24, height: 24),
                Text(
                  order.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    order.notes!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  '${l10n.estimatedPrice}: ${priceFormat.format(order.price)}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                if (order.assignedUserName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.assignedUserName!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
                if (order.startedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(context, order.startedAt!),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (order.status.isCancellable) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () => showCancelOrderDialog(
                        context: context,
                        onConfirm: widget.onCancel,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      child: Text(l10n.cancelServiceOrder),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
