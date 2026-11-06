import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Campo de formulário no tema escuro (borda sutil, branca ao focar), igual
/// aos formulários de ordem de serviço.
InputDecoration darkInputDecoration(
  String label, {
  String? hint,
  String? suffixText,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixText: suffixText,
    labelStyle: const TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
    suffixStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.danger),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.transparent,
  );
}
