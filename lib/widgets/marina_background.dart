import 'dart:io';

import 'package:flutter/material.dart';

/// Preenche a tela com a imagem de fundo da marina (quando disponível) e
/// aplica um scrim escuro por cima para manter textos/cartões brancos
/// legíveis. Quando [backgroundFile] é `null`, apenas renderiza o [child]
/// sobre o fundo padrão da tela.
///
/// Use junto de `Scaffold(extendBodyBehindAppBar: hasBackground, ...)` e de
/// uma AppBar transparente para que a imagem ocupe a tela inteira, inclusive
/// atrás da barra de navegação.
class MarinaBackground extends StatelessWidget {
  const MarinaBackground({
    super.key,
    required this.backgroundFile,
    required this.child,
  });

  final File? backgroundFile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final file = backgroundFile;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (file != null) ...[
          Positioned.fill(
            child: Image.file(
              file,
              key: ValueKey(file.path),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          // Scrim para manter os textos brancos legíveis sobre a imagem.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
        child,
      ],
    );
  }
}
