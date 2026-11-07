import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dark_input_decoration.dart';

/// Campo de data no estilo dos inputs escuros: toca para escolher e, com
/// [onClear], mostra um "x" para limpar.
class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String placeholder;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;

  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.onClear,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final date = value;
    final clear = onClear;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: darkInputDecoration(label).copyWith(errorText: errorText),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null
                    ? DateFormat.yMMMd(locale).format(date)
                    : placeholder,
                style: TextStyle(
                  color: date != null
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
            if (date != null && clear != null)
              GestureDetector(
                onTap: clear,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              )
            else
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Colors.white.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }
}
