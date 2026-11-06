import 'package:flutter/foundation.dart';
import '../models/logbook_entry_type.dart';
import '../models/trip_summary.dart';
import '../services/estai_api_client.dart';
import '../services/logbook_service.dart';
import '../services/pending_trip_queue_service.dart';
import '../utils/polyline_codec.dart';
import '../utils/track_simplifier.dart';

enum TripSaveResult { saved, queued, failed }

/// Salva a viagem do fim da navegação no diário de bordo. Sem conexão, a
/// viagem vai para a fila local e é reenviada por [flushPending].
class TripLogViewModel extends ChangeNotifier {
  TripLogViewModel({
    LogbookService? logbookService,
    PendingTripQueueService? queueService,
  }) : _logbookService = logbookService ?? LogbookService(),
       _queueService = queueService ?? PendingTripQueueService();

  final LogbookService _logbookService;
  final PendingTripQueueService _queueService;

  bool _isSaving = false;
  bool _isFlushing = false;

  bool get isSaving => _isSaving;

  /// Entrada `Trip` com o trajeto simplificado e codificado.
  static LogbookEntryInput buildTripInput({
    required TripSummary summary,
    required String title,
    String? notes,
    double? engineHoursEnd,
    int? passengers,
  }) {
    return LogbookEntryInput(
      type: LogbookEntryType.trip,
      title: title,
      notes: notes,
      occurredAt: summary.startedAt,
      endedAt: summary.endedAt,
      distanceNm: _round(summary.distanceNm, 2),
      durationMinutes: summary.durationMinutes,
      avgSpeedKn: _round(summary.avgSpeedKn, 1),
      maxSpeedKn: summary.maxSpeedKn != null
          ? _round(summary.maxSpeedKn!, 1)
          : null,
      startPoint: summary.startPoint,
      endPoint: summary.endPoint,
      track: PolylineCodec.encode(TrackSimplifier.simplify(summary.track)),
      engineHoursEnd: engineHoursEnd,
      passengers: passengers,
    );
  }

  Future<TripSaveResult> save({
    required TripSummary summary,
    required String boatId,
    required String title,
    String? notes,
    double? engineHoursEnd,
    int? passengers,
  }) async {
    _isSaving = true;
    notifyListeners();

    final input = buildTripInput(
      summary: summary,
      title: title,
      notes: notes,
      engineHoursEnd: engineHoursEnd,
      passengers: passengers,
    );

    TripSaveResult result;
    try {
      await _logbookService.createEntry(boatId: boatId, input: input);
      result = TripSaveResult.saved;
    } on ApiException catch (e) {
      // Sem status é falha de rede: guarda para reenviar depois.
      if (e.statusCode == null) {
        await _queueService.add(
          PendingTrip(
            localId: DateTime.now().microsecondsSinceEpoch.toString(),
            boatId: boatId,
            input: input,
          ),
        );
        result = TripSaveResult.queued;
      } else {
        result = TripSaveResult.failed;
      }
    }

    _isSaving = false;
    notifyListeners();
    return result;
  }

  /// Reenvia as viagens da fila. Para no primeiro erro de rede; viagens que
  /// a API recusa (4xx) saem da fila para não travar as demais. Retorna
  /// quantas foram enviadas.
  Future<int> flushPending() async {
    if (_isFlushing) return 0;
    _isFlushing = true;

    var sent = 0;
    try {
      for (final trip in await _queueService.getAll()) {
        try {
          await _logbookService.createEntry(
            boatId: trip.boatId,
            input: trip.input,
          );
          await _queueService.remove(trip.localId);
          sent++;
        } on ApiException catch (e) {
          final status = e.statusCode;
          if (status == null || status >= 500 || status == 401) break;
          await _queueService.remove(trip.localId);
        }
      }
    } finally {
      _isFlushing = false;
    }
    return sent;
  }

  static double _round(double value, int decimals) {
    final factor = decimals == 1 ? 10 : 100;
    return (value * factor).round() / factor;
  }
}
