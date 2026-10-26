import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/ramp_booking_viewmodel.dart';
import 'booking_summary_card.dart';
import 'inline_alert.dart';
import 'step_title.dart';

class ReviewStep extends StatelessWidget {
  final TextEditingController notesController;

  const ReviewStep({super.key, required this.notesController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<RampBookingViewModel>();
    final autoConfirm = viewModel.ramp?.autoConfirmAppBookings ?? false;
    final error = viewModel.submitError;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StepTitle(title: l10n.rampReviewTitle),
        const BookingSummaryCard(),
        const SizedBox(height: 16),
        InlineAlert(
          icon: autoConfirm ? Icons.check_circle_outline : Icons.schedule,
          message: autoConfirm
              ? l10n.rampAutoConfirmInfo
              : l10n.rampPendingInfo,
          color: autoConfirm ? Colors.greenAccent : Colors.amber,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: notesController,
          onChanged: viewModel.setNotes,
          maxLines: 3,
          maxLength: 1000,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.rampNotesHint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            counterStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        if (error == RampBookingError.invalid ||
            error == RampBookingError.unknown) ...[
          const SizedBox(height: 12),
          InlineAlert(
            icon: Icons.error_outline,
            // No 400 a API explica o motivo (ex.: bloqueio da rampa).
            message:
                error == RampBookingError.invalid &&
                    viewModel.submitErrorMessage != null
                ? viewModel.submitErrorMessage!
                : l10n.rampCreateError,
            color: Colors.redAccent,
          ),
        ],
      ],
    );
  }
}
