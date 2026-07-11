import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/service_order_status.dart';
import 'service_order_status_chip.dart';

class ServiceOrderStatusFilter extends StatelessWidget {
  final ServiceOrderStatus? selected;
  final ValueChanged<ServiceOrderStatus?> onChanged;

  const ServiceOrderStatusFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final options = <ServiceOrderStatus?>[null, ...ServiceOrderStatus.values];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = options[index];
          final isSelected = status == selected;
          final color = status == null
              ? Colors.white
              : serviceOrderStatusColor(status);
          return ChoiceChip(
            label: Text(
              status == null ? l10n.serviceOrderStatusAll : status.label(l10n),
            ),
            selected: isSelected,
            onSelected: (_) => onChanged(status),
            backgroundColor: Colors.transparent,
            selectedColor: color.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(color: color.withValues(alpha: isSelected ? 0.6 : 0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
