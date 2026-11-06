import 'dart:convert';

import 'package:estai/models/logbook_entry_type.dart';
import 'package:estai/services/estai_api_client.dart';
import 'package:estai/services/logbook_service.dart';
import 'package:estai/utils/polyline_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:latlong2/latlong.dart';

Map<String, dynamic> tripJson() {
  return {
    'id': 'e1',
    'boatId': 'b1',
    'type': 'Trip',
    'title': 'Ilhabela',
    'notes': null,
    'occurredAt': '2026-10-26T13:00:00.000Z',
    'endedAt': '2026-10-26T15:30:00.000Z',
    'distanceNm': 12.35,
    'durationMinutes': 150,
    'avgSpeedKn': 4.9,
    'maxSpeedKn': 18.3,
    'startPoint': {'lat': -23.98, 'lng': -46.3},
    'endPoint': {'lat': -23.98, 'lng': -46.29},
    'track': PolylineCodec.encode([
      const LatLng(-23.98, -46.3),
      const LatLng(-23.98, -46.29),
    ]),
    'engineHoursEnd': 250,
    'passengers': 4,
    'createdAt': '2026-10-26T15:31:00.000Z',
    'updatedAt': '2026-10-26T15:31:00.000Z',
  };
}

void main() {
  late List<http.Request> requests;

  LogbookService serviceReturning(int status, Object body) {
    requests = [];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode(body), status);
    });
    return LogbookService(
      apiClient: EstaiApiClient(client: client, baseUrl: 'http://test'),
    );
  }

  test('getEntries parses trips and sends the type filter', () async {
    final service = serviceReturning(200, {
      'data': {
        'items': [tripJson()],
        'total': 25,
        'page': 1,
        'limit': 20,
      },
    });

    final result = await service.getEntries(
      boatId: 'b1',
      type: LogbookEntryType.trip,
    );

    expect(requests.single.url.path, '/boats/b1/logbook');
    expect(requests.single.url.queryParameters['type'], 'Trip');
    expect(result.hasMore, isTrue);
    final entry = result.items.single;
    expect(entry.isTrip, isTrue);
    expect(entry.startPoint, const LatLng(-23.98, -46.3));
    expect(entry.trackPoints.length, 2);
    expect(entry.passengers, 4);
  });

  test('createEntry sends points as {lat, lng}', () async {
    final service = serviceReturning(201, {'data': tripJson()});

    await service.createEntry(
      boatId: 'b1',
      input: LogbookEntryInput(
        type: LogbookEntryType.anchorage,
        title: 'Saco do Sombrio',
        occurredAt: DateTime.utc(2026, 10, 26, 12),
        startPoint: const LatLng(-23.9, -45.2),
      ),
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(requests.single.method, 'POST');
    expect(body['type'], 'Anchorage');
    expect(body['startPoint'], {'lat': -23.9, 'lng': -45.2});
    expect(body['track'], isNull);
    expect(body['occurredAt'], '2026-10-26T12:00:00.000Z');
  });

  test('LogbookEntryInput survives the offline queue round-trip', () {
    final input = LogbookEntryInput.fromJson(
      LogbookEntryInput(
        type: LogbookEntryType.trip,
        title: 'Ilhabela',
        occurredAt: DateTime.utc(2026, 10, 26, 13),
        endedAt: DateTime.utc(2026, 10, 26, 15),
        distanceNm: 12.35,
        startPoint: const LatLng(-23.98, -46.3),
        track: 'abc',
        passengers: 2,
      ).toJson(),
    );

    expect(input.type, LogbookEntryType.trip);
    expect(input.endedAt, DateTime.utc(2026, 10, 26, 15));
    expect(input.distanceNm, 12.35);
    expect(input.startPoint, const LatLng(-23.98, -46.3));
    expect(input.track, 'abc');
    expect(input.passengers, 2);
  });
}
