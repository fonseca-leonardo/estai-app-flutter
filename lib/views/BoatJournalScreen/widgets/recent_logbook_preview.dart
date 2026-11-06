import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/logbook_entry.dart';
import '../../LogbookScreen/widgets/logbook_entry_card.dart';
import '../../MarinaHomeScreen/widgets/tracking_see_all_button.dart';

/// As últimas entradas do diário de bordo no resumo da embarcação.
class RecentLogbookPreview extends StatelessWidget {
  final List<LogbookEntry> entries;
  final bool isLoading;
  final VoidCallback onSeeAll;
  final ValueChanged<LogbookEntry> onOpen;

  const RecentLogbookPreview({
    super.key,
    required this.entries,
    required this.isLoading,
    required this.onSeeAll,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading && entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 36,
              color: Colors.white.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.journalNoLogbookEntries,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 8),
            TrackingSeeAllButton(
              label: l10n.journalSeeLogbook,
              onPressed: onSeeAll,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final entry in entries)
          LogbookEntryCard(entry: entry, onTap: () => onOpen(entry)),
        TrackingSeeAllButton(
          label: l10n.journalSeeLogbook,
          onPressed: onSeeAll,
        ),
      ],
    );
  }
}
