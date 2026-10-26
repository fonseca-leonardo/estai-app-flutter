import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance_status.dart';

Color maintenanceStatusColor(MaintenanceStatus status) {
  switch (status) {
    case MaintenanceStatus.scheduled:
      return Colors.lightBlueAccent;
    case MaintenanceStatus.overdue:
      return Colors.redAccent;
    case MaintenanceStatus.done:
      return Colors.greenAccent;
  }
}

class MaintenanceStatusChip extends StatelessWidget {
  final MaintenanceStatus status;

  const MaintenanceStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = maintenanceStatusColor(status);

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
