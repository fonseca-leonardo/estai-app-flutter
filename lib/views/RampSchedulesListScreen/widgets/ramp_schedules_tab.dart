import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_schedule.dart';
import 'ramp_schedule_card.dart';

/// Uma aba da lista (próximos ou histórico) com pull-to-refresh.
class RampSchedulesTab extends StatelessWidget {
  final List<RampSchedule> schedules;
  final bool isLoading;
  final String? errorMessage;
  final String emptyMessage;
  final Future<void> Function() onRefresh;
  final ValueChanged<RampSchedule> onCancel;
  final EdgeInsets padding;

  const RampSchedulesTab({
    super.key,
    required this.schedules,
    required this.isLoading,
    required this.errorMessage,
    required this.emptyMessage,
    required this.onRefresh,
    required this.onCancel,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && schedules.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final String? message = errorMessage != null && schedules.isEmpty
        ? l10n.loadRampSchedulesError
        : (schedules.isEmpty ? emptyMessage : null);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.black,
      backgroundColor: Colors.white,
      child: message != null
          ? ListView(
              padding: padding,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                Icon(
                  Icons.event_note_outlined,
                  size: 56,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ],
            )
          : ListView.builder(
              padding: padding,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return RampScheduleCard(
                  schedule: schedule,
                  onCancel: () => onCancel(schedule),
                );
              },
            ),
    );
  }
}
