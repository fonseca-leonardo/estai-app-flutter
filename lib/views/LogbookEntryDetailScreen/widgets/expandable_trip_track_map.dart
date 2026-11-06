import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../l10n/app_localizations.dart';
import '../../TripTrackMapScreen/trip_track_map_screen.dart';
import 'trip_track_map.dart';

/// Preview estático do trajeto com o botão que abre o mapa em tela cheia,
/// onde é possível mexer no mapa.
class ExpandableTripTrackMap extends StatelessWidget {
  final List<LatLng> track;
  final LatLng? singlePoint;

  const ExpandableTripTrackMap({
    super.key,
    this.track = const [],
    this.singlePoint,
  });

  void _expand(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            TripTrackMapScreen(track: track, singlePoint: singlePoint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        TripTrackMap(track: track, singlePoint: singlePoint),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _expand(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_full, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      l10n.logbookTripMapExpand,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
