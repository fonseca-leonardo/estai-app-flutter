import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'glass_surface.dart';

/// Versão de vidro fosco do [AppCard]: mesma API, com o blur e a borda do
/// [GlassSurface].
class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool selected;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = GlassSurface(
      borderRadius: AppRadius.mdAll,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    return margin == null ? card : Padding(padding: margin!, child: card);
  }
}
