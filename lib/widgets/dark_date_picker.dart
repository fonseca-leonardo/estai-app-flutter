import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData _darkPickerTheme() {
  return ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: AppColors.surfaceElevated,
      onSurface: Colors.white,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceElevated,
    ),
  );
}

/// `showTimePicker` com o tema escuro do app.
Future<TimeOfDay?> showDarkTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) => Theme(data: _darkPickerTheme(), child: child!),
  );
}

/// `showDatePicker` com o tema escuro do app.
Future<DateTime?> showDarkDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) => Theme(data: _darkPickerTheme(), child: child!),
  );
}
