import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance.dart';
import '../../MaintenancesScreen/widgets/maintenance_card.dart';
import '../../MarinaHomeScreen/widgets/tracking_empty_state.dart';
import '../../MarinaHomeScreen/widgets/tracking_see_all_button.dart';

/// As próximas manutenções do resumo, com atalho para a lista completa.
class UpcomingMaintenancesPreview extends StatelessWidget {
  final List<Maintenance> maintenances;
  final double? currentEngineHours;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onSeeAll;
  final VoidCallback onCreate;
  final ValueChanged<Maintenance> onOpen;

  const UpcomingMaintenancesPreview({
    super.key,
    required this.maintenances,
    required this.currentEngineHours,
    required this.isLoading,
    required this.hasError,
    required this.onSeeAll,
    required this.onCreate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && maintenances.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (maintenances.isEmpty) {
      return TrackingEmptyState(
        icon: hasError ? Icons.cloud_off_outlined : Icons.build_circle_outlined,
        message: hasError ? l10n.journalLoadError : l10n.noUpcomingMaintenances,
        actionLabel: l10n.maintenanceScheduleFirst,
        onAction: onCreate,
      );
    }

    return Column(
      children: [
        for (final maintenance in maintenances)
          MaintenanceCard(
            maintenance: maintenance,
            currentEngineHours: currentEngineHours,
            onTap: () => onOpen(maintenance),
          ),
        TrackingSeeAllButton(
          label: l10n.journalSeeAllMaintenances,
          onPressed: onSeeAll,
        ),
      ],
    );
  }
}
