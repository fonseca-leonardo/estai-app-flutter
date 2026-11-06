import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

enum _BoatMenuAction { edit, delete }

/// Menu da AppBar do diário com as ações sobre o cadastro do barco.
class JournalBoatMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const JournalBoatMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<_BoatMenuAction>(
      icon: const Icon(Icons.more_vert),
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      onSelected: (action) {
        switch (action) {
          case _BoatMenuAction.edit:
            onEdit();
          case _BoatMenuAction.delete:
            onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _BoatMenuAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(l10n.editBoat, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem(
          value: _BoatMenuAction.delete,
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                color: AppColors.danger,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(l10n.deleteBoat, style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
      ],
    );
  }
}
