import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_reminder.dart';
import '../../../theme/app_colors.dart';

/// Data do lembrete e quanto falta. Vermelho se atrasado, âmbar se está
/// perto; nos feitos, quando foi feito.
class BoatReminderDueLabel extends StatelessWidget {
  static const int _soonDays = 7;

  final BoatReminder reminder;

  const BoatReminderDueLabel({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(locale).format(reminder.dueDate.toLocal());
    final completedAt = reminder.completedAt;

    if (reminder.isDone) {
      return Text(
        completedAt != null
            ? l10n.boatReminderDoneOn(
                DateFormat.yMMMd(locale).format(completedAt.toLocal()),
              )
            : date,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
      );
    }

    final days = reminder.daysRemaining();
    final relative = days < 0
        ? l10n.boatReminderOverdueDays(-days)
        : days == 0
        ? l10n.boatReminderDueToday
        : l10n.boatReminderDueInDays(days);
    final color = days < 0
        ? AppColors.danger
        : days <= _soonDays
        ? AppColors.warning
        : Colors.white.withValues(alpha: 0.75);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          days < 0 ? Icons.error_outline : Icons.schedule,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '$date · $relative',
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
