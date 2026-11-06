import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/logbook_entry.dart';
import '../models/logbook_entry_type.dart';
import '../services/estai_api_client.dart';
import '../services/logbook_service.dart';

enum LogbookEntryFormError { invalid, unknown }

/// Formulário de criar/editar entrada do diário de bordo. Viagens só editam
/// título e observações; o trajeto e as métricas vêm da navegação.
class LogbookEntryFormViewModel extends ChangeNotifier {
  LogbookEntryFormViewModel({
    required this.boatId,
    this.initial,
    LogbookService? logbookService,
  }) : _logbookService = logbookService ?? LogbookService(),
       _type = initial?.type ?? LogbookEntryType.note,
       _occurredAt = initial?.occurredAt.toLocal() ?? DateTime.now(),
       _position = initial?.startPoint;

  final String boatId;
  final LogbookEntry? initial;
  final LogbookService _logbookService;

  LogbookEntryType _type;
  DateTime _occurredAt;
  LatLng? _position;
  bool _isSubmitting = false;
  LogbookEntryFormError? _error;

  bool get isEditing => initial != null;
  bool get isTrip => _type == LogbookEntryType.trip;
  LogbookEntryType get type => _type;
  DateTime get occurredAt => _occurredAt;
  LatLng? get position => _position;
  bool get isSubmitting => _isSubmitting;
  LogbookEntryFormError? get error => _error;

  void setType(LogbookEntryType type) {
    if (isTrip) return;
    _type = type;
    notifyListeners();
  }

  void setOccurredAt(DateTime value) {
    _occurredAt = value;
    notifyListeners();
  }

  void setPosition(LatLng? value) {
    _position = value;
    notifyListeners();
  }

  /// Devolve a entrada salva, ou `null` se falhou.
  Future<LogbookEntry?> save({required String title, String? notes}) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    final existing = initial;
    final input = existing != null
        ? LogbookEntryInput.fromEntry(
            existing,
            type: _type,
            title: title,
            notes: notes,
            occurredAt: _occurredAt,
            startPoint: _position,
            clearStartPoint: _position == null && !existing.isTrip,
          )
        : LogbookEntryInput(
            type: _type,
            title: title,
            notes: notes,
            occurredAt: _occurredAt,
            startPoint: _position,
          );

    try {
      final saved = existing == null
          ? await _logbookService.createEntry(boatId: boatId, input: input)
          : await _logbookService.updateEntry(id: existing.id, input: input);
      _isSubmitting = false;
      notifyListeners();
      return saved;
    } on ApiException catch (e) {
      _error = e.statusCode == 400
          ? LogbookEntryFormError.invalid
          : LogbookEntryFormError.unknown;
    } catch (e) {
      _error = LogbookEntryFormError.unknown;
    }
    _isSubmitting = false;
    notifyListeners();
    return null;
  }
}
