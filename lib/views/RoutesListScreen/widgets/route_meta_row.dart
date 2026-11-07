import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// Ícone pequeno + texto secundário (pontos, data, distância).
class RouteMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const RouteMetaRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}
