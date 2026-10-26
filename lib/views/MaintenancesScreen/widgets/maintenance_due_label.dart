import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance.dart';
import '../../../utils/engine_hours_format.dart';

/// Quanto falta (ou quanto passou) para o vencimento, por data e/ou
/// horímetro. Vermelho se atrasada, âmbar se está perto.
class MaintenanceDueLabel extends StatelessWidget {
  static const int _soonDays = 7;
  static const double _soonHours = 10;

  final Maintenance maintenance;
  final double? currentEngineHours;

  const MaintenanceDueLabel({
    super.key,
    required this.maintenance,
    this.currentEngineHours,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final days = maintenance.daysRemaining();
    final hours = maintenance.hoursRemaining(currentEngineHours);
    final dueHours = maintenance.dueEngineHours;

    final parts = <String>[
      if (days != null)
        days < 0
            ? l10n.maintenanceOverdueDays(-days)
            : days == 0
            ? l10n.maintenanceDueToday
            : l10n.maintenanceDueInDays(days),
      if (dueHours != null)
        hours == null
            ? l10n.maintenanceDueAtHours(
                EngineHoursFormat.format(dueHours, locale),
              )
            : hours < 0
            ? l10n.maintenanceOverdueHours(
                EngineHoursFormat.format(-hours, locale),
              )
            : l10n.maintenanceDueInHours(
                EngineHoursFormat.format(hours, locale),
              ),
    ];
    if (parts.isEmpty) return const SizedBox.shrink();

    final overdue = maintenance.isOverdue(
      currentEngineHours: currentEngineHours,
    );
    final soon =
        (days != null && days <= _soonDays) ||
        (hours != null && hours <= _soonHours);
    final color = overdue
        ? Colors.redAccent
        : soon
        ? Colors.amber
        : Colors.white.withValues(alpha: 0.75);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          overdue ? Icons.error_outline : Icons.schedule,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            parts.join(' · '),
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
