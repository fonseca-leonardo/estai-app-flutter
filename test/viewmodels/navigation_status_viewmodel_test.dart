import 'package:estai/models/trip_summary.dart';
import 'package:estai/viewmodels/navigation_status_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pontos ~100 m para leste, acima do filtro de distância padrão (50 m).
List<LatLng> _eastwardTrack(int count) => [
  for (var i = 0; i < count; i++) LatLng(-23.98, -46.30 + i * 0.001),
];

void main() {
  late NavigationStatusViewModel viewModel;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    viewModel = NavigationStatusViewModel();
  });

  tearDown(() => viewModel.dispose());

  test('finishNavigation returns the trip summary and clears the state', () {
    viewModel.startNavigation();
    final track = _eastwardTrack(10);
    final speeds = [2.0, 5.0, 8.0, 6.0, 4.0, 3.0, 3.0, 2.0, 1.0, 0.5];
    for (var i = 0; i < track.length; i++) {
      viewModel.addTrackedPoint(track[i], speedMps: speeds[i]);
    }

    final summary = viewModel.finishNavigation(
      now: DateTime.now().add(const Duration(minutes: 10)),
    );

    expect(summary, isNotNull);
    expect(summary!.track.length, 10);
    expect(summary.distanceNm, closeTo(0.49, 0.02));
    expect(
      summary.maxSpeedKn,
      closeTo(8 * TripSummary.knotsPerMeterPerSecond, 1e-9),
    );
    expect(summary.durationMinutes, inInclusiveRange(9, 10));
    expect(summary.startPoint, track.first);
    expect(summary.endPoint, track.last);
    expect(viewModel.isNavigating, isFalse);
    expect(viewModel.trackedRoute, isEmpty);
  });

  test('ignores implausible GPS speed spikes', () {
    viewModel.startNavigation();
    final track = _eastwardTrack(5);
    viewModel.addTrackedPoint(track[0], speedMps: 4);
    viewModel.addTrackedPoint(track[1], speedMps: 120);
    for (final point in track.skip(2)) {
      viewModel.addTrackedPoint(point, speedMps: 3);
    }

    final summary = viewModel.finishNavigation(
      now: DateTime.now().add(const Duration(minutes: 5)),
    );

    expect(
      summary?.maxSpeedKn,
      closeTo(4 * TripSummary.knotsPerMeterPerSecond, 1e-9),
    );
  });

  test('counts speed even when the point is filtered by distance', () {
    viewModel.startNavigation();
    final track = _eastwardTrack(5);
    viewModel.addTrackedPoint(track[0], speedMps: 2);
    // ~10 m do anterior: não entra no trajeto, mas a velocidade conta.
    viewModel.addTrackedPoint(const LatLng(-23.98, -46.29991), speedMps: 9);
    for (final point in track.skip(1)) {
      viewModel.addTrackedPoint(point, speedMps: 3);
    }

    final summary = viewModel.finishNavigation(
      now: DateTime.now().add(const Duration(minutes: 5)),
    );

    expect(summary?.track.length, 5);
    expect(
      summary?.maxSpeedKn,
      closeTo(9 * TripSummary.knotsPerMeterPerSecond, 1e-9),
    );
  });

  test('short trips do not become a logbook entry', () {
    viewModel.startNavigation();
    for (final point in _eastwardTrack(10)) {
      viewModel.addTrackedPoint(point, speedMps: 3);
    }
    expect(
      viewModel.finishNavigation(
        now: DateTime.now().add(const Duration(minutes: 1)),
      ),
      isNull,
    );

    viewModel.startNavigation();
    viewModel.addTrackedPoint(const LatLng(-23.98, -46.30), speedMps: 3);
    expect(
      viewModel.finishNavigation(
        now: DateTime.now().add(const Duration(minutes: 30)),
      ),
      isNull,
    );
    expect(viewModel.isNavigating, isFalse);
  });
}
