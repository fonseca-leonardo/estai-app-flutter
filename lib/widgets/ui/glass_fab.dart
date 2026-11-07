import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_glass.dart';
import '../../theme/app_radius.dart';
import 'glass_surface.dart';

/// Botão flutuante de vidro fosco usado sobre o mapa.
class GlassFab extends StatelessWidget {
  final String heroTag;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget child;

  /// Botão com estado (ligado/desligado): acende o vidro e o ícone.
  final bool selected;
  final Color? tint;

  const GlassFab({
    super.key,
    required this.heroTag,
    required this.child,
    this.tooltip,
    this.onPressed,
    this.selected = false,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: GlassSurface(
        tint: tint,
        selected: selected,
        child: FloatingActionButton(
          foregroundColor: selected ? AppGlass.selectedIconColor : Colors.white,
          heroTag: heroTag,
          elevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          backgroundColor: Colors.transparent,
          tooltip: tooltip,
          onPressed: onPressed == null
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                },
          child: child,
        ),
      ),
    );
  }
}
