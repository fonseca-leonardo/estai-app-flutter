import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../l10n/app_localizations.dart';
import '../LogbookEntryDetailScreen/widgets/trip_track_map.dart';

/// Trajeto da viagem em tela cheia, com o mapa interativo (zoom e arrasto).
class TripTrackMapScreen extends StatelessWidget {
  final List<LatLng> track;
  final LatLng? singlePoint;

  const TripTrackMapScreen({
    super.key,
    this.track = const [],
    this.singlePoint,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(l10n.logbookTripMapTitle)),
      body: TripTrackMap(
        track: track,
        singlePoint: singlePoint,
        interactive: true,
        height: null,
      ),
    );
  }
}
