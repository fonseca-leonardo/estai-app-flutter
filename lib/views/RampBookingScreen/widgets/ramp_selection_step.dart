import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import 'selectable_card.dart';
import 'step_title.dart';

class RampSelectionStep extends StatelessWidget {
  const RampSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<RampBookingViewModel>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StepTitle(title: l10n.rampSelectRampTitle),
        ...viewModel.ramps.map(
          (ramp) => SelectableCard(
            icon: Icons.signpost_outlined,
            title: ramp.name,
            subtitle: ramp.marinaLocationName,
            selected: viewModel.ramp?.id == ramp.id,
            onTap: () => viewModel.selectRamp(ramp),
          ),
        ),
      ],
    );
  }
}
