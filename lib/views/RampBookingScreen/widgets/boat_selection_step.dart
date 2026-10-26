import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import '../../ServiceOrderFormScreen/widgets/no_marina_boats_placeholder.dart';
import 'selectable_card.dart';
import 'step_title.dart';

class BoatSelectionStep extends StatelessWidget {
  const BoatSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<RampBookingViewModel>();
    final boats = viewModel.boats;

    if (boats.isEmpty) {
      return const NoMarinaBoatsPlaceholder();
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StepTitle(title: l10n.rampSelectBoatTitle),
        ...boats.map(
          (boat) => SelectableCard(
            icon: Icons.directions_boat,
            title: boat.name,
            subtitle: '${boat.model} · ${boat.year}',
            selected: viewModel.boat?.id == boat.id,
            onTap: () => viewModel.selectBoat(boat),
          ),
        ),
      ],
    );
  }
}
