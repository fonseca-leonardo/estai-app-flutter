import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_glass.dart';

/// Fundo de vidro para barras (AppBar via `flexibleSpace`, rodapés fixos):
/// blur, véu do [AppGlass] e uma linha clara no lado [edge].
class GlassBarBackground extends StatelessWidget {
  final Widget? child;
  final AxisDirection edge;

  const GlassBarBackground({
    super.key,
    this.child,
    this.edge = AxisDirection.down,
  });

  @override
  Widget build(BuildContext context) {
    final line = BorderSide(color: AppGlass.border);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppGlass.blurSigma,
          sigmaY: AppGlass.blurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppGlass.tint,
            border: edge == AxisDirection.down
                ? Border(bottom: line)
                : Border(top: line),
          ),
          child: child ?? const SizedBox.expand(),
        ),
      ),
    );
  }
}
