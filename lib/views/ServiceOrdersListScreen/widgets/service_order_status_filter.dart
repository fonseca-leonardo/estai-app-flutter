import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/service_order_status.dart';
import 'service_order_status_chip.dart';

class ServiceOrderStatusFilterDrawer extends StatelessWidget {
  final ServiceOrderStatus? selected;
  final ValueChanged<ServiceOrderStatus?> onChanged;

  const ServiceOrderStatusFilterDrawer({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final options = <ServiceOrderStatus?>[null, ...ServiceOrderStatus.values];

    return Drawer(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.filterByStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: options.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final status = options[index];
                  return _StatusFilterTile(
                    status: status,
                    isSelected: status == selected,
                    onTap: () {
                      onChanged(status);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusFilterTile extends StatelessWidget {
  final ServiceOrderStatus? status;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusFilterTile({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final label = status == null ? l10n.serviceOrderStatusAll : status!.label(l10n);
    final color = status == null ? Colors.white : serviceOrderStatusColor(status!);

    return Material(
      color: isSelected
          ? color.withValues(alpha: 0.15)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: isSelected ? 0.6 : 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, size: 18, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
