import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/glass_card.dart';

/// "3 de 8" com barra de progresso; fica verde quando completo.
class ChecklistProgressHeader extends StatelessWidget {
  final int checked;
  final int total;

  const ChecklistProgressHeader({
    super.key,
    required this.checked,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final complete = total > 0 && checked == total;
    final color = complete ? AppColors.success : AppColors.accent;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  complete
                      ? l10n.checklistRunComplete
                      : l10n.checklistRunProgress(checked, total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (complete)
                const Icon(Icons.check_circle, color: AppColors.success),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : checked / total,
              minHeight: 6,
              color: color,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
