import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/marina_time.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import 'day_strip.dart';
import 'slot_grid.dart';
import 'step_title.dart';

/// Etapa opcional da descida: já reservar a subida de volta.
class ReturnStep extends StatelessWidget {
  const ReturnStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final viewModel = context.watch<RampBookingViewModel>();
    final returnDay = viewModel.returnDay;
    final launchSlot = viewModel.slot;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepTitle(title: l10n.rampReturnTitle),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: SwitchListTile.adaptive(
                  value: viewModel.wantsReturn,
                  onChanged: viewModel.setWantsReturn,
                  activeTrackColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    l10n.rampReturnToggle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.rampReturnDescription,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (viewModel.wantsReturn) ...[
          const SizedBox(height: 24),
          DayStrip(
            days: viewModel.returnDays,
            selectedDay: returnDay,
            isLoaded: viewModel.isDayLoaded,
            hasAvailability: viewModel.returnDayHasAvailability,
            onSelect: viewModel.selectReturnDay,
            onNeedDay: viewModel.loadMoreDays,
          ),
          const SizedBox(height: 24),
          if (returnDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.MMMMEEEEd(locale).format(returnDay),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (launchSlot != null && returnDay == viewModel.day) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.rampReturnAfter(
                        MarinaTime.formatTime(launchSlot.endsAt),
                      ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SlotGrid(
                    slots: viewModel.returnSlotsFor(returnDay),
                    selectedSlot: viewModel.returnSlot,
                    isLoading:
                        viewModel.isLoadingSlots ||
                        !viewModel.isDayLoaded(returnDay),
                    errorMessage: viewModel.slotsErrorMessage,
                    onSelect: viewModel.selectReturnSlot,
                    onRetry: viewModel.reloadSlots,
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
