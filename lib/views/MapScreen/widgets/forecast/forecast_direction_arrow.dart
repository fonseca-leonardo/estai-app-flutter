import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Seta apontando para onde o vento/onda VAI. A API informa de onde vem
/// (padrão meteorológico), por isso gira 180°.
class ForecastDirectionArrow extends StatelessWidget {
  final double degrees;
  final double size;
  final Color color;

  const ForecastDirectionArrow({
    super.key,
    required this.degrees,
    this.size = 16,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (degrees + 180) * math.pi / 180,
      child: Icon(Icons.navigation, size: size, color: color),
    );
  }
}
