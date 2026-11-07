import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_reminder.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/icon_chip.dart';
import 'boat_reminder_due_label.dart';

class BoatReminderCard extends StatelessWidget {
  final BoatReminder reminder;
  final bool highlighted;
  final VoidCallback? onTap;
  final VoidCallback? onMarkDone;

  const BoatReminderCard({
    super.key,
    required this.reminder,
    this.highlighted = false,
    this.onTap,
    this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final done = reminder.isDone;
    final notes = reminder.notes?.trim();
    final markDone = onMarkDone;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconChip(
                    icon: done
                        ? Icons.check_circle_outline
                        : Icons.notifications_active_outlined,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: done ? 0.7 : 1,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (notes != null && notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            notes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        BoatReminderDueLabel(reminder: reminder),
                      ],
                    ),
                  ),
                  if (reminder.isRecurring && !done) ...[
                    const SizedBox(width: 8),
                    Tooltip(
                      message: l10n.boatReminderEveryMonths(
                        reminder.recurrenceMonths!,
                      ),
                      child: Icon(
                        Icons.repeat,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              if (markDone != null && !done) ...[
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: markDone,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(l10n.boatReminderMarkDone),
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
