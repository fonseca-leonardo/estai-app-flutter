import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// Linha de um item com checkbox. A linha inteira é tocável.
class ChecklistRunItemTile extends StatelessWidget {
  final String text;
  final bool checked;
  final VoidCallback onToggle;

  const ChecklistRunItemTile({
    super.key,
    required this.text,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: checked ? AppColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked
                      ? AppColors.success
                      : Colors.white.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: checked ? AppColors.textTertiary : Colors.white,
                  fontSize: 15,
                  decoration: checked ? TextDecoration.lineThrough : null,
                  decorationColor: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
