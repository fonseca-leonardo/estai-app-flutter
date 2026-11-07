import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Variáveis do efeito de vidro fosco (bottom sheet do mapa, botões e
/// painéis de dados sobre o mapa). Edite aqui para mudar todos de uma vez.
class AppGlass {
  AppGlass._();

  /// Intensidade do blur do que está atrás. Em aparelhos fracos, 12 a 16.
  static const double blurSigma = 20;

  /// Opacidade do preto sobre o blur. Mais alto = mais escuro/legível.
  static const double tintAlpha = 0.35;

  /// Opacidade da borda clara que contorna a superfície.
  static const double borderAlpha = 0.18;

  /// Estado selecionado (ex.: câmera travada): o vidro "acende" com um véu
  /// branco e borda forte; o ícone ganha [selectedIconColor].
  static const double selectedTintAlpha = 0.22;
  static const double selectedBorderAlpha = 0.6;
  static const Color selectedIconColor = AppColors.accent;

  /// Elementos dentro do vidro (cards da grade do bottom sheet).
  static const double itemFillAlpha = 0.08;
  static const double itemBorderAlpha = 0.14;

  static Color get tint => Colors.black.withValues(alpha: tintAlpha);
  static Color get selectedTint =>
      Colors.white.withValues(alpha: selectedTintAlpha);
  static Color get selectedBorder =>
      Colors.white.withValues(alpha: selectedBorderAlpha);
  static Color get border => Colors.white.withValues(alpha: borderAlpha);

  static Color get itemFill => Colors.white.withValues(alpha: itemFillAlpha);
  static Color get itemBorder =>
      Colors.white.withValues(alpha: itemBorderAlpha);
}
