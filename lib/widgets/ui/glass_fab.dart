import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_radius.dart';

/// Botão flutuante translúcido usado sobre o mapa.
class GlassFab extends StatelessWidget {
  final String heroTag;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget child;
  final bool emphasized;
  final Color? tint;

  const GlassFab({
    super.key,
    required this.heroTag,
    required this.child,
    this.tooltip,
    this.onPressed,
    this.emphasized = true,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
      ),
      backgroundColor:
          tint ?? Colors.black.withValues(alpha: emphasized ? 0.55 : 0.25),
      tooltip: tooltip,
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
      child: child,
    );
  }
}
