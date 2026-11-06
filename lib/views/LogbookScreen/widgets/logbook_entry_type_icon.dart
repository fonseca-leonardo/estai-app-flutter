import 'package:flutter/material.dart';
import '../../../models/logbook_entry_type.dart';

IconData logbookEntryTypeIcon(LogbookEntryType type) {
  switch (type) {
    case LogbookEntryType.trip:
      return Icons.route_outlined;
    case LogbookEntryType.note:
      return Icons.sticky_note_2_outlined;
    case LogbookEntryType.anchorage:
      return Icons.anchor;
    case LogbookEntryType.incident:
      return Icons.report_problem_outlined;
    case LogbookEntryType.event:
      return Icons.celebration_outlined;
  }
}
