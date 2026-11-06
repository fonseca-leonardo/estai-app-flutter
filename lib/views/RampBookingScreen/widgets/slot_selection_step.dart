import '../../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import 'day_strip.dart';
import 'inline_alert.dart';
import 'slot_grid.dart';
import 'step_title.dart';

/// "1h", "1h30", "45 min".
String formatAdvance(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0
      ? '${hours}h'
      : '${hours}h${rest.toString().padLeft(2, '0')}';
}

class SlotSelectionStep extends StatelessWidget {
  const SlotSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final viewModel = context.watch<RampBookingViewModel>();
    final ramp = viewModel.ramp;
    final day = viewModel.day;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: StepTitle(
            title: l10n.rampSlotTitle,
            subtitle: ramp != null && ramp.minAdvanceMinutes > 0
                ? l10n.rampMinAdvanceHint(formatAdvance(ramp.minAdvanceMinutes))
                : null,
          ),
        ),
        if (viewModel.submitError == RampBookingError.conflict)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: InlineAlert(
              icon: Icons.error_outline,
              message: l10n.rampConflictError,
              color: AppColors.danger,
            ),
          ),
        DayStrip(
          days: viewModel.selectableDays,
          selectedDay: day,
          isLoaded: viewModel.isDayLoaded,
          hasAvailability: viewModel.dayHasAvailability,
          onSelect: viewModel.selectDay,
          onNeedDay: viewModel.loadMoreDays,
        ),
        const SizedBox(height: 24),
        if (day != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.MMMMEEEEd(locale).format(day),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                SlotGrid(
                  slots: viewModel.slotsFor(day),
                  selectedSlot: viewModel.slot,
                  isLoading:
                      viewModel.isLoadingSlots || !viewModel.isDayLoaded(day),
                  errorMessage: viewModel.slotsErrorMessage,
                  onSelect: viewModel.selectSlot,
                  onRetry: viewModel.reloadSlots,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
