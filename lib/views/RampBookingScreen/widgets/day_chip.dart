import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Um dia da faixa de dias. [day] já está no relógio da marina.
class DayChip extends StatelessWidget {
  final DateTime day;
  final bool selected;
  final bool hasAvailability;
  final bool loaded;
  final VoidCallback onTap;

  static const double spacing = 8;

  /// Largura do chip; cresce com o tamanho de fonte do sistema.
  static double widthFor(TextScaler textScaler) =>
      textScaler.scale(60).clamp(60.0, 110.0);

  /// Altura do chip: espaçamentos fixos mais as três linhas de texto
  /// (11 + 20 + 11 pt) com folga para a altura de linha da fonte.
  static double heightFor(TextScaler textScaler) =>
      40 + textScaler.scale(42 * 1.5);

  const DayChip({
    super.key,
    required this.day,
    required this.selected,
    required this.hasAvailability,
    required this.loaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dimmed = loaded && !hasAvailability && !selected;
    final foreground = selected
        ? Colors.black
        : Colors.white.withValues(alpha: dimmed ? 0.3 : 1);

    final textScaler = MediaQuery.textScalerOf(context);

    return Padding(
      padding: const EdgeInsets.only(right: spacing),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widthFor(textScaler),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: dimmed ? 0.02 : 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: dimmed ? 0.06 : 0.12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat.E(locale).format(day).toUpperCase(),
                style: TextStyle(
                  color: foreground.withValues(alpha: selected ? 0.7 : 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${day.day}',
                style: TextStyle(
                  color: foreground,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat.MMM(locale).format(day),
                style: TextStyle(
                  color: foreground.withValues(alpha: selected ? 0.7 : 0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: loaded && hasAvailability
                      ? (selected ? Colors.black : Colors.greenAccent)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
