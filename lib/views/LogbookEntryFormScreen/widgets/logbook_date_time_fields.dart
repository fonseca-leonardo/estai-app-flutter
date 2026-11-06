import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/dark_input_decoration.dart';

/// Data e hora da entrada, lado a lado.
class LogbookDateTimeFields extends StatelessWidget {
  final DateTime value;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const LogbookDateTimeFields({
    super.key,
    required this.value,
    required this.onPickDate,
    required this.onPickTime,
  });

  Widget _field({
    required String label,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: darkInputDecoration(label),
        child: Row(
          children: [
            Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
            Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _field(
            label: l10n.logbookDateLabel,
            text: DateFormat.yMMMd(locale).format(value),
            icon: Icons.calendar_today_outlined,
            onTap: onPickDate,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _field(
            label: l10n.logbookTimeLabel,
            text: DateFormat.Hm(locale).format(value),
            icon: Icons.schedule,
            onTap: onPickTime,
          ),
        ),
      ],
    );
  }
}
