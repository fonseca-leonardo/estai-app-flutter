import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/checklist.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/glass_card.dart';
import '../../../widgets/ui/icon_chip.dart';

/// Tocar executa o checklist; o lápis abre a edição.
class ChecklistCard extends StatelessWidget {
  final Checklist checklist;
  final VoidCallback onRun;
  final VoidCallback onEdit;

  const ChecklistCard({
    super.key,
    required this.checklist,
    required this.onRun,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      onTap: onRun,
      child: Row(
        children: [
          IconChip(icon: checklist.trigger.icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checklist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.checklistItemsCount(checklist.items.length),
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.checklistEdit,
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
