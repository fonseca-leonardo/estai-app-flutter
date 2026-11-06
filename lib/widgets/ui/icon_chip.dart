import 'package:flutter/material.dart';

/// Quadrado arredondado com ícone, usado à esquerda de tiles e cards.
class IconChip extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;

  const IconChip({
    super.key,
    required this.icon,
    this.size = 40,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}
