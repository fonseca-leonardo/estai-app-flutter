import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_glass.dart';
import '../../theme/app_radius.dart';

/// Superfície de vidro fosco: blur do fundo, véu escuro e borda clara, tudo
/// vindo de [AppGlass]. Base de todos os elementos de vidro do mapa.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  /// Substitui o véu padrão (ex.: botão de alerta em vermelho).
  final Color? tint;

  /// Estado selecionado: véu branco e borda forte (ver [AppGlass]).
  final bool selected;

  /// Borda própria (ex.: só no topo do sheet). Sem ela, contorna tudo.
  final Border? border;
  final EdgeInsetsGeometry? padding;

  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.md)),
    this.tint,
    this.selected = false,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedBorder =
        border ??
        Border.all(color: selected ? AppGlass.selectedBorder : AppGlass.border);
    final resolvedTint =
        tint ?? (selected ? AppGlass.selectedTint : AppGlass.tint);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppGlass.blurSigma,
          sigmaY: AppGlass.blurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: resolvedTint,
            border: resolvedBorder,
            // borderRadius só é aceito em bordas uniformes; o clip já recorta.
            borderRadius: resolvedBorder.isUniform ? borderRadius : null,
          ),
          child: padding == null
              ? child
              : Padding(padding: padding!, child: child),
        ),
      ),
    );
  }
}
