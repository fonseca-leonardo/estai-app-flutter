import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_schedule_status.dart';

Color rampScheduleStatusColor(RampScheduleStatus status) {
  switch (status) {
    case RampScheduleStatus.pending:
      return Colors.amber;
    case RampScheduleStatus.confirmed:
      return Colors.lightBlueAccent;
    case RampScheduleStatus.inProgress:
      return Colors.purpleAccent;
    case RampScheduleStatus.completed:
      return Colors.greenAccent;
    case RampScheduleStatus.cancelled:
      return Colors.grey;
    case RampScheduleStatus.rejected:
      return Colors.redAccent;
    case RampScheduleStatus.noShow:
      return Colors.orangeAccent;
  }
}

class RampScheduleStatusChip extends StatelessWidget {
  final RampScheduleStatus status;

  const RampScheduleStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = rampScheduleStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label(l10n),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
