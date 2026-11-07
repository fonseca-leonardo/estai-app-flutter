import 'package:flutter/material.dart';

/// Véu escuro em degradê sobre imagens de fundo, para manter textos e cards
/// brancos legíveis. Compartilhado entre o fundo da marina e o do app.
class BackgroundScrim extends StatelessWidget {
  const BackgroundScrim({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
    );
  }
}
