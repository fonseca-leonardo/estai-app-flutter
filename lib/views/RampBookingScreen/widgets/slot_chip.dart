import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/ramp_slot.dart';
import '../../../utils/marina_time.dart';

class SlotChip extends StatelessWidget {
  final RampSlot slot;
  final bool selected;
  final VoidCallback onTap;

  const SlotChip({
    super.key,
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  String? _caption(AppLocalizations l10n) {
    if (slot.blocked) return l10n.rampSlotBlocked;
    if (slot.isFull) return l10n.rampSlotFull;
    if (!slot.isAvailable) return l10n.rampSlotUnavailable;
    if (slot.capacity > 1) return l10n.rampSlotsLeft(slot.available);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = slot.isAvailable;
    final caption = _caption(l10n);
    final foreground = selected
        ? Colors.black
        : Colors.white.withValues(alpha: enabled ? 1 : 0.35);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 96,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.white.withValues(alpha: enabled ? 0.05 : 0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: enabled ? 0.15 : 0.06),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              MarinaTime.formatTime(slot.startsAt),
              style: TextStyle(
                color: foreground,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: enabled ? null : TextDecoration.lineThrough,
                decorationColor: foreground,
              ),
            ),
            if (caption != null) ...[
              const SizedBox(height: 2),
              Text(
                caption,
                style: TextStyle(
                  color: foreground.withValues(alpha: selected ? 0.7 : 0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
