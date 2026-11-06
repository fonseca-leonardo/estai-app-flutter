import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat.dart';
import '../../../widgets/ui/app_card.dart';
import '../../../widgets/ui/icon_chip.dart';

/// Item da lista de embarcações; tocar abre o diário, onde ficam editar e
/// excluir.
class BoatCard extends StatelessWidget {
  final Boat boat;
  final VoidCallback onTap;

  const BoatCard({super.key, required this.boat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Row(
        children: [
          Hero(
            tag: 'boat-icon-${boat.id}',
            child: const IconChip(
              icon: Icons.directions_boat,
              size: 44,
              iconSize: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boat.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${boat.model} · ${boat.year}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${boat.type.label(l10n)} · ${boat.length.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}
