import '../l10n/app_localizations.dart';

enum LogbookEntryType {
  trip,
  note,
  anchorage,
  incident,
  event;

  String get apiValue {
    switch (this) {
      case LogbookEntryType.trip:
        return 'Trip';
      case LogbookEntryType.note:
        return 'Note';
      case LogbookEntryType.anchorage:
        return 'Anchorage';
      case LogbookEntryType.incident:
        return 'Incident';
      case LogbookEntryType.event:
        return 'Event';
    }
  }

  static LogbookEntryType fromApiValue(String value) {
    return LogbookEntryType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => LogbookEntryType.note,
    );
  }

  /// Tipos que o usuário cria à mão; a viagem vem do fim da navegação.
  static const List<LogbookEntryType> manualTypes = [
    LogbookEntryType.note,
    LogbookEntryType.anchorage,
    LogbookEntryType.incident,
    LogbookEntryType.event,
  ];

  String label(AppLocalizations l10n) {
    switch (this) {
      case LogbookEntryType.trip:
        return l10n.logbookTypeTrip;
      case LogbookEntryType.note:
        return l10n.logbookTypeNote;
      case LogbookEntryType.anchorage:
        return l10n.logbookTypeAnchorage;
      case LogbookEntryType.incident:
        return l10n.logbookTypeIncident;
      case LogbookEntryType.event:
        return l10n.logbookTypeEvent;
    }
  }
}
