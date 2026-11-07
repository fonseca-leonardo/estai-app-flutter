import 'package:flutter/material.dart';
import '../../../../theme/app_glass.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

/// Bloco dentro do sheet de vidro: preenchimento e borda leves do
/// [AppGlass] (sem outro blur por cima do blur do sheet).
class ForecastCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ForecastCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppGlass.itemFill,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
        side: BorderSide(color: AppGlass.itemBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
