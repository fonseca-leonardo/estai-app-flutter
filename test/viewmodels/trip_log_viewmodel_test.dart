import 'package:estai/models/logbook_entry.dart';
import 'package:estai/models/logbook_entry_type.dart';
import 'package:estai/models/trip_summary.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/services/logbook_service.dart';
import 'package:estai/services/pending_trip_queue_service.dart';
import 'package:estai/utils/polyline_codec.dart';
import 'package:estai/viewmodels/trip_log_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

class _FakeLogbookService extends LogbookService {
  _FakeLogbookService()
    : super(apiClient: EstaiApiClient(baseUrl: 'http://test'));

  /// Erros a lançar, na ordem; vazio = sucesso.
  final List<ApiException> errors = [];
  final List<(String, LogbookEntryInput)> created = [];

  @override
  Future<LogbookEntry> createEntry({
    required String boatId,
    required LogbookEntryInput input,
  }) async {
    if (errors.isNotEmpty) throw errors.removeAt(0);
    created.add((boatId, input));
    return LogbookEntry(
      id: 'e${created.length}',
      boatId: boatId,
      type: input.type,
      title: input.title,
      occurredAt: input.occurredAt,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
  }
}

class _MemoryQueue extends PendingTripQueueService {
  final List<PendingTrip> trips = [];

  @override
  Future<List<PendingTrip>> getAll() async => List.of(trips);

  @override
  Future<void> add(PendingTrip trip) async => trips.add(trip);

  @override
  Future<void> remove(String localId) async =>
      trips.removeWhere((trip) => trip.localId == localId);
}

TripSummary _summary() => TripSummary(
  startedAt: DateTime.utc(2026, 10, 26, 13),
  endedAt: DateTime.utc(2026, 10, 26, 15, 30),
  track: [for (var i = 0; i <= 10; i++) LatLng(-23.98, -46.30 + i * 0.001)],
  distanceNm: 12.3456,
  maxSpeedKn: 18.27,
);

PendingTrip _pending(String id) => PendingTrip(
  localId: id,
  boatId: 'b1',
  input: TripLogViewModel.buildTripInput(summary: _summary(), title: id),
);

void main() {
  late _FakeLogbookService service;
  late _MemoryQueue queue;
  late TripLogViewModel viewModel;

  setUp(() {
    service = _FakeLogbookService();
    queue = _MemoryQueue();
    viewModel = TripLogViewModel(logbookService: service, queueService: queue);
  });

  test('buildTripInput rounds metrics and sends a simplified track', () {
    final input = TripLogViewModel.buildTripInput(
      summary: _summary(),
      title: 'Ilhabela',
      engineHoursEnd: 250,
      passengers: 4,
    );

    expect(input.type, LogbookEntryType.trip);
    expect(input.distanceNm, 12.35);
    expect(input.maxSpeedKn, 18.3);
    expect(input.avgSpeedKn, 4.9);
    expect(input.durationMinutes, 150);
    // Pontos alinhados: sobra só o início e o fim.
    expect(PolylineCodec.decode(input.track!).length, 2);
    expect(input.startPoint, const LatLng(-23.98, -46.30));
    expect(input.engineHoursEnd, 250);
    expect(input.passengers, 4);
  });

  test('save posts the trip', () async {
    final result = await viewModel.save(
      summary: _summary(),
      boatId: 'b1',
      title: 'Ilhabela',
    );

    expect(result, TripSaveResult.saved);
    expect(service.created.single.$1, 'b1');
    expect(queue.trips, isEmpty);
  });

  test('save queues the trip when there is no connection', () async {
    service.errors.add(ApiException('Network error'));

    final result = await viewModel.save(
      summary: _summary(),
      boatId: 'b1',
      title: 'Ilhabela',
    );

    expect(result, TripSaveResult.queued);
    expect(queue.trips.single.boatId, 'b1');
    expect(queue.trips.single.input.title, 'Ilhabela');
  });

  test('save fails without queueing when the API rejects the trip', () async {
    service.errors.add(ApiException('invalid', statusCode: 400));

    final result = await viewModel.save(
      summary: _summary(),
      boatId: 'b1',
      title: 'Ilhabela',
    );

    expect(result, TripSaveResult.failed);
    expect(queue.trips, isEmpty);
  });

  test('flushPending sends queued trips and stops on network errors', () async {
    queue.trips.addAll([_pending('t1'), _pending('t2'), _pending('t3')]);
    service.errors.addAll([ApiException('invalid', statusCode: 400)]);

    // t1 é recusada (sai da fila), t2 é enviada, t3 também.
    expect(await viewModel.flushPending(), 2);
    expect(queue.trips, isEmpty);
    expect(service.created.map((c) => c.$2.title), ['t2', 't3']);

    queue.trips.addAll([_pending('t4'), _pending('t5')]);
    service.errors.add(ApiException('Network error'));

    // Sem rede: para e mantém tudo para a próxima tentativa.
    expect(await viewModel.flushPending(), 0);
    expect(queue.trips.map((t) => t.localId), ['t4', 't5']);
  });
}
