import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../MarinaHomeScreen/widgets/marina_quick_action_tile.dart';

/// Atalhos do diário, em grade de 3 colunas.
class JournalQuickActions extends StatelessWidget {
  static const int _columns = 3;
  static const double _gap = 10;

  final VoidCallback onNewMaintenance;
  final VoidCallback onMaintenances;
  final VoidCallback onLogbook;
  final VoidCallback onReminders;
  final VoidCallback onDocuments;

  const JournalQuickActions({
    super.key,
    required this.onNewMaintenance,
    required this.onMaintenances,
    required this.onLogbook,
    required this.onReminders,
    required this.onDocuments,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tiles = [
      MarinaQuickActionTile(
        icon: Icons.add_task,
        label: l10n.maintenanceNew,
        onTap: onNewMaintenance,
      ),
      MarinaQuickActionTile(
        icon: Icons.build_outlined,
        label: l10n.journalActionMaintenances,
        onTap: onMaintenances,
      ),
      MarinaQuickActionTile(
        icon: Icons.menu_book_outlined,
        label: l10n.logbookTitle,
        onTap: onLogbook,
      ),
      MarinaQuickActionTile(
        icon: Icons.notifications_active_outlined,
        label: l10n.boatRemindersTitle,
        onTap: onReminders,
      ),
      MarinaQuickActionTile(
        icon: Icons.folder_outlined,
        label: l10n.documentsTitle,
        onTap: onDocuments,
      ),
    ];

    return Column(
      children: [
        for (var start = 0; start < tiles.length; start += _columns) ...[
          if (start > 0) const SizedBox(height: _gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = start; i < start + _columns; i++) ...[
                  if (i > start) const SizedBox(width: _gap),
                  Expanded(
                    child: i < tiles.length ? tiles[i] : const SizedBox(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
