import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat.dart';
import '../../../utils/engine_hours_format.dart';

/// Barco e horímetro atual, com o atalho para atualizar a leitura.
class JournalHeaderCard extends StatelessWidget {
  final Boat boat;
  final double? engineHours;
  final DateTime? engineHoursReadAt;

  /// `null` desabilita o botão (leitura sendo salva).
  final VoidCallback? onUpdateEngineHours;

  const JournalHeaderCard({
    super.key,
    required this.boat,
    required this.engineHours,
    required this.engineHoursReadAt,
    required this.onUpdateEngineHours,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final hours = engineHours;
    final readAt = engineHoursReadAt;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_boat,
                  color: Colors.white,
                  size: 28,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${boat.type.label(l10n)} · ${boat.model} · ${boat.year}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.speed_outlined,
                color: Colors.white.withValues(alpha: 0.6),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.journalEngineHours,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hours != null
                          ? l10n.engineHoursValue(
                              EngineHoursFormat.format(hours, locale),
                            )
                          : l10n.journalEngineHoursUnknown,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: hours != null ? 1 : 0.5,
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (readAt != null)
                      Text(
                        l10n.journalEngineHoursReadAt(
                          DateFormat.yMMMd(locale).format(readAt.toLocal()),
                        ),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: onUpdateEngineHours,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(l10n.journalUpdateEngineHours),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
