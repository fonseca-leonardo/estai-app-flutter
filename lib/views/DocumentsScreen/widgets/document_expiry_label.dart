import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/boat_document.dart';
import 'document_status_chip.dart';

/// Validade e quanto falta, na cor do status.
class DocumentExpiryLabel extends StatelessWidget {
  final BoatDocument document;

  const DocumentExpiryLabel({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final expiresAt = document.expiresAt;
    final days = document.daysRemaining();
    final status = document.status();
    final color = documentStatusColor(status);

    final text = expiresAt == null || days == null
        ? l10n.documentNoExpiryLabel
        : [
            l10n.documentExpiresOn(
              DateFormat.yMMMd(locale).format(expiresAt.toLocal()),
            ),
            if (days < 0)
              l10n.documentExpiredDaysAgo(-days)
            else if (status.needsAttention)
              days == 0
                  ? l10n.documentExpiresToday
                  : l10n.documentExpiresInDays(days),
          ].join(' · ');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          days != null && days < 0 ? Icons.error_outline : Icons.event_outlined,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
