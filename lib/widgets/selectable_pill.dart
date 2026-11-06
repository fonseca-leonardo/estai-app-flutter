import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Pílula de seleção (categoria, antecedência, canal). Selecionada ganha a
/// cor de destaque, borda cheia e um check; não selecionada fica neutra e
/// mais apagada, para a diferença ser óbvia no fundo escuro.
class SelectablePill extends StatelessWidget {
  static const Color accentColor = AppColors.accent;

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const SelectablePill({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? accentColor
        : Colors.white.withValues(alpha: 0.7);
    final leadingIcon = selected ? Icons.check : icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? accentColor.withValues(alpha: 0.16)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? accentColor
                  : Colors.white.withValues(alpha: 0.15),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
