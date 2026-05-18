import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/persisted_navigation.dart';

class ResumeNavigationDialog extends StatelessWidget {
  final PersistedNavigation snapshot;

  const ResumeNavigationDialog({super.key, required this.snapshot});

  static Future<bool?> show(
    BuildContext context,
    PersistedNavigation snapshot,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResumeNavigationDialog(snapshot: snapshot),
    );
  }

  String _formatDuration(BuildContext context, Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    if (minutes > 0) {
      return '${minutes}min';
    }
    return '${duration.inSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final elapsed = snapshot.elapsedSince(DateTime.now());

    return AlertDialog(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
      ),
      title: Text(
        l10n.resumeNavigationTitle,
        style: const TextStyle(color: Colors.white),
      ),
      content: Text(
        l10n.resumeNavigationQuestion(_formatDuration(context, elapsed)),
        style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.discard,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            l10n.resume,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ),
      ],
    );
  }
}
