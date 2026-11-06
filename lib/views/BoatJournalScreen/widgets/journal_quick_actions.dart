import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../MarinaHomeScreen/widgets/marina_quick_action_tile.dart';

/// Atalhos do diário, lado a lado.
class JournalQuickActions extends StatelessWidget {
  final VoidCallback onNewMaintenance;
  final VoidCallback onMaintenances;
  final VoidCallback onLogbook;

  const JournalQuickActions({
    super.key,
    required this.onNewMaintenance,
    required this.onMaintenances,
    required this.onLogbook,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: MarinaQuickActionTile(
              icon: Icons.add_task,
              label: l10n.maintenanceNew,
              onTap: onNewMaintenance,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MarinaQuickActionTile(
              icon: Icons.build_outlined,
              label: l10n.journalActionMaintenances,
              onTap: onMaintenances,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MarinaQuickActionTile(
              icon: Icons.menu_book_outlined,
              label: l10n.logbookTitle,
              onTap: onLogbook,
            ),
          ),
        ],
      ),
    );
  }
}
