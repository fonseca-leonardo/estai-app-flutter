import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/navigation_status_viewmodel.dart';

class TrackedRouteLine extends StatelessWidget {
  const TrackedRouteLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<NavigationStatusViewModel, List<LatLng>>(
      selector: (_, viewModel) => viewModel.trackedRoute,
      builder: (context, trackedRoute, child) {
        if (trackedRoute.length < 2) {
          return const SizedBox.shrink();
        }
        return PolylineLayer(
          polylines: [
            Polyline(
              points: trackedRoute,
              strokeWidth: 4.0,
              borderStrokeWidth: 4,
              color: Colors.pink,
              borderColor: Colors.grey.withAlpha(10),
            ),
          ],
        );
      },
    );
  }
}
