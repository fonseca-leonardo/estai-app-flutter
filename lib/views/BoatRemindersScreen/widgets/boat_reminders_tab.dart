import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_reminder.dart';
import '../../../widgets/ui/empty_state.dart';
import '../../../widgets/ui/skeleton_list.dart';
import 'boat_reminder_card.dart';

/// Uma aba da lista (pendentes ou feitos) com pull-to-refresh.
class BoatRemindersTab extends StatelessWidget {
  final List<BoatReminder> reminders;
  final bool isLoading;
  final String? errorMessage;
  final String emptyMessage;
  final String? highlightedId;
  final Future<void> Function() onRefresh;
  final ValueChanged<BoatReminder> onOpen;
  final ValueChanged<BoatReminder>? onMarkDone;
  final EdgeInsets padding;

  const BoatRemindersTab({
    super.key,
    required this.reminders,
    required this.isLoading,
    required this.errorMessage,
    required this.emptyMessage,
    this.highlightedId,
    required this.onRefresh,
    required this.onOpen,
    this.onMarkDone,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && reminders.isEmpty) {
      return const SkeletonList(count: 3, itemHeight: 96);
    }

    final String? message = errorMessage != null && reminders.isEmpty
        ? l10n.loadBoatRemindersError
        : (reminders.isEmpty ? emptyMessage : null);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.black,
      backgroundColor: Colors.white,
      child: message != null
          ? ListView(
              padding: padding,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 48),
                EmptyState(
                  icon: errorMessage != null
                      ? Icons.cloud_off_outlined
                      : Icons.notifications_none,
                  message: message,
                  bordered: false,
                ),
              ],
            )
          : ListView.builder(
              padding: padding,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                final markDone = onMarkDone;
                return BoatReminderCard(
                  reminder: reminder,
                  highlighted: reminder.id == highlightedId,
                  onTap: () => onOpen(reminder),
                  onMarkDone: markDone != null
                      ? () => markDone(reminder)
                      : null,
                );
              },
            ),
    );
  }
}
