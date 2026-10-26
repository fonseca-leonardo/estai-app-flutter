import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_schedule_type.dart';
import '../../../models/ramp_slot.dart';
import '../../../utils/marina_time.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import 'summary_row.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key});

  String _slotLabel(RampSlot slot, String locale) =>
      '${MarinaTime.formatDate(slot.startsAt, locale)} · '
      '${MarinaTime.formatTime(slot.startsAt)}–${MarinaTime.formatTime(slot.endsAt)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final viewModel = context.watch<RampBookingViewModel>();
    final ramp = viewModel.ramp;
    final slot = viewModel.slot;
    final returnSlot = viewModel.wantsReturn ? viewModel.returnSlot : null;
    final type = viewModel.type;

    final divider = Divider(
      color: Colors.white.withValues(alpha: 0.08),
      height: 1,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          if (ramp != null) ...[
            SummaryRow(
              icon: Icons.signpost_outlined,
              label: l10n.rampReviewRamp,
              value: ramp.name,
              detail: ramp.marinaLocationName,
            ),
            divider,
          ],
          SummaryRow(
            icon: Icons.directions_boat,
            label: l10n.rampReviewBoat,
            value: viewModel.boat?.name ?? '—',
          ),
          divider,
          SummaryRow(
            icon: type == RampScheduleType.haul ? Icons.north : Icons.south,
            label: l10n.rampReviewOperation,
            value: type == RampScheduleType.haul
                ? l10n.rampHaulTitle
                : l10n.rampLaunchTitle,
          ),
          divider,
          SummaryRow(
            icon: Icons.event,
            label: l10n.rampReviewWhen,
            value: slot != null ? _slotLabel(slot, locale) : '—',
          ),
          if (returnSlot != null) ...[
            divider,
            SummaryRow(
              icon: Icons.north,
              label: l10n.rampReviewReturn,
              value: _slotLabel(returnSlot, locale),
            ),
          ],
        ],
      ),
    );
  }
}
