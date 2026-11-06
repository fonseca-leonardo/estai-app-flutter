import 'package:flutter/material.dart';

ThemeData _darkPickerTheme() {
  return ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: Color(0xFF0A0A0A),
      onSurface: Colors.white,
    ),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0A0A0A)),
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
