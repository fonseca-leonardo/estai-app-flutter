import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance.dart';
import '../../../models/maintenance_status.dart';
import 'maintenance_category_icon.dart';
import 'maintenance_due_label.dart';
import 'maintenance_status_chip.dart';

class MaintenanceCard extends StatelessWidget {
  final Maintenance maintenance;
  final double? currentEngineHours;
  final bool highlighted;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const MaintenanceCard({
    super.key,
    required this.maintenance,
    this.currentEngineHours,
    this.highlighted = false,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final done = maintenance.status == MaintenanceStatus.done;
    final status = maintenance.isOverdue(currentEngineHours: currentEngineHours)
        ? MaintenanceStatus.overdue
        : maintenance.status;
    final completedAt = maintenance.completedAt;
    final cost = maintenance.cost;
    final subtitle = [
      maintenance.category.label(l10n),
      if (maintenance.provider != null && maintenance.provider!.isNotEmpty)
        maintenance.provider!,
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: highlighted ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: highlighted ? 0.6 : 0.12),
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      maintenanceCategoryIcon(maintenance.category),
                      color: Colors.white.withValues(alpha: done ? 0.5 : 1),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maintenance.title,
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: done ? 0.7 : 1,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  MaintenanceStatusChip(status: status),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (done && completedAt != null)
                    Text(
                      [
                        l10n.maintenanceCompletedOn(
                          DateFormat.yMMMd(
                            locale,
                          ).format(completedAt.toLocal()),
                        ),
                        if (cost != null)
                          NumberFormat.simpleCurrency(
                            locale: locale,
                          ).format(cost),
                      ].join(' · '),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    )
                  else
                    MaintenanceDueLabel(
                      maintenance: maintenance,
                      currentEngineHours: currentEngineHours,
                    ),
                  if (maintenance.isRecurring && !done)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.maintenanceRecurringBadge,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (onComplete != null && !done) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: onComplete,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(l10n.maintenanceComplete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
