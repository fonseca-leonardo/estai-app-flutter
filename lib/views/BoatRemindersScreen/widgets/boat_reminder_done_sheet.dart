import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_reminder.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/ui/app_sheet.dart';
import '../../MaintenanceDetailsScreen/widgets/details_section_card.dart';
import '../../RampBookingScreen/widgets/summary_row.dart';

/// Lembrete já feito, somente leitura. Volta `true` se o usuário pediu
/// para excluir.
Future<bool> showBoatReminderDoneSheet({
  required BuildContext context,
  required BoatReminder reminder,
}) async {
  final delete = await AppSheet.show<bool>(
    context,
    builder: (_) => BoatReminderDoneSheet(reminder: reminder),
  );
  return delete ?? false;
}

class BoatReminderDoneSheet extends StatelessWidget {
  final BoatReminder reminder;

  const BoatReminderDoneSheet({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final completedAt = reminder.completedAt;
    final notes = reminder.notes?.trim();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            reminder.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DetailsSectionCard(
            rows: [
              SummaryRow(
                icon: Icons.event_outlined,
                label: l10n.boatReminderDateLabel,
                value: DateFormat.yMMMd(
                  locale,
                ).format(reminder.dueDate.toLocal()),
              ),
              if (completedAt != null)
                SummaryRow(
                  icon: Icons.check_circle_outline,
                  label: l10n.boatReminderDoneAtLabel,
                  value: DateFormat.yMMMd(locale).format(completedAt.toLocal()),
                ),
              if (notes != null && notes.isNotEmpty)
                SummaryRow(
                  icon: Icons.sticky_note_2_outlined,
                  label: l10n.boatReminderNotesLabel,
                  value: notes,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: Text(l10n.deleteBoatReminder),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: BorderSide(color: AppColors.danger.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
