import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_radius.dart';
import 'glass_surface.dart';

/// Botão flutuante com ícone e texto, de vidro fosco (par do [GlassFab]).
class GlassExtendedFab extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const GlassExtendedFab({
    super.key,
    required this.heroTag,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      borderRadius: AppRadius.mdAll,
      child: FloatingActionButton.extended(
        heroTag: heroTag,
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
