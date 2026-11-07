import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_reminder.dart';
import '../../BoatRemindersScreen/widgets/boat_reminder_card.dart';
import '../../MarinaHomeScreen/widgets/tracking_empty_state.dart';
import '../../MarinaHomeScreen/widgets/tracking_see_all_button.dart';

/// Os próximos lembretes avulsos do resumo, com atalho para a lista.
class JournalUpcomingRemindersPreview extends StatelessWidget {
  final List<BoatReminder> reminders;
  final bool isLoading;
  final VoidCallback onSeeAll;
  final VoidCallback onCreate;
  final ValueChanged<BoatReminder> onOpen;

  const JournalUpcomingRemindersPreview({
    super.key,
    required this.reminders,
    required this.isLoading,
    required this.onSeeAll,
    required this.onCreate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && reminders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (reminders.isEmpty) {
      return TrackingEmptyState(
        icon: Icons.notifications_none,
        message: l10n.journalNoReminders,
        actionLabel: l10n.boatReminderNew,
        onAction: onCreate,
      );
    }

    return Column(
      children: [
        for (final reminder in reminders)
          BoatReminderCard(reminder: reminder, onTap: () => onOpen(reminder)),
        TrackingSeeAllButton(
          label: l10n.journalSeeReminders,
          onPressed: onSeeAll,
        ),
      ],
    );
  }
}
