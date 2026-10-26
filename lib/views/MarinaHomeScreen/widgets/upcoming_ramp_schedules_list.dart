import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/ramp_schedule_viewmodel.dart';
import '../../RampBookingScreen/ramp_booking_screen.dart';
import '../../RampSchedulesListScreen/ramp_schedules_list_screen.dart';
import '../../RampSchedulesListScreen/widgets/ramp_schedule_card.dart';
import 'tracking_empty_state.dart';
import 'tracking_see_all_button.dart';

/// Aba "Rampa" do acompanhamento: os 3 próximos agendamentos ativos.
class UpcomingRampSchedulesList extends StatelessWidget {
  const UpcomingRampSchedulesList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<RampScheduleViewModel>();
    final schedules = viewModel.activeUpcoming.take(3).toList();

    if (viewModel.isLoadingUpcoming && schedules.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (schedules.isEmpty) {
      return TrackingEmptyState(
        icon: Icons.event_available_outlined,
        message: l10n.noUpcomingRampSchedules,
        actionLabel: l10n.rampBookingTitle,
        onAction: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const RampBookingScreen())),
      );
    }

    return Column(
      children: [
        ...schedules.map((schedule) => RampScheduleCard(schedule: schedule)),
        TrackingSeeAllButton(
          label: l10n.marinaSeeAllRampSchedules,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RampSchedulesListScreen()),
          ),
        ),
      ],
    );
  }
}
