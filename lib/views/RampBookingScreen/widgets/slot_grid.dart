import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_slot.dart';
import 'slot_chip.dart';

/// Horários de um dia, com os estados de carregamento, erro e vazio.
class SlotGrid extends StatelessWidget {
  final List<RampSlot> slots;
  final RampSlot? selectedSlot;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<RampSlot> onSelect;
  final VoidCallback onRetry;

  const SlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.isLoading,
    required this.errorMessage,
    required this.onSelect,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (errorMessage != null && slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              l10n.rampLoadSlotsError,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    if (isLoading && slots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.event_busy,
                size: 40,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.rampNoSlotsForDay,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots
          .map(
            (slot) => SlotChip(
              slot: slot,
              selected: selectedSlot?.startsAt == slot.startsAt,
              onTap: () => onSelect(slot),
            ),
          )
          .toList(),
    );
  }
}
