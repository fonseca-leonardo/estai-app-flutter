import 'package:flutter/material.dart';

/// Tokens de cor do app (tema escuro).
class AppColors {
  AppColors._();

  static const Color background = Colors.black;
  static const Color surfaceElevated = Color(0xFF0A0A0A);

  /// Preenchimento sutil de cards e tiles.
  static Color get surface => Colors.white.withValues(alpha: 0.05);
  static Color get surfaceStrong => Colors.white.withValues(alpha: 0.1);
  static Color get border => Colors.white.withValues(alpha: 0.12);

  static const Color textPrimary = Colors.white;
  static Color get textSecondary => Colors.white.withValues(alpha: 0.7);
  static Color get textTertiary => Colors.white.withValues(alpha: 0.5);

  static const Color accent = Color(0xFF38BDF8);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
}
