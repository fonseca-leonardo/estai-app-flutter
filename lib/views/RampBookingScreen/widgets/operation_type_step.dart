import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_schedule_type.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import 'selectable_card.dart';
import 'step_title.dart';

class OperationTypeStep extends StatelessWidget {
  const OperationTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<RampBookingViewModel>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StepTitle(
          title: l10n.rampOperationTitle,
          subtitle: viewModel.boat?.name,
        ),
        SelectableCard(
          icon: Icons.south,
          title: l10n.rampLaunchTitle,
          subtitle: l10n.rampLaunchDescription,
          selected: viewModel.type == RampScheduleType.launch,
          onTap: () => viewModel.selectType(RampScheduleType.launch),
        ),
        SelectableCard(
          icon: Icons.north,
          title: l10n.rampHaulTitle,
          subtitle: l10n.rampHaulDescription,
          selected: viewModel.type == RampScheduleType.haul,
          onTap: () => viewModel.selectType(RampScheduleType.haul),
        ),
      ],
    );
  }
}
