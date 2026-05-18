import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/anchor_alarm_viewmodel.dart';

class AnchorAlarmLayer extends StatelessWidget {
  const AnchorAlarmLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<
      AnchorAlarmViewModel,
      ({double? lat, double? lng, double? radius})
    >(
      selector: (_, vm) => (
        lat: vm.alarm?.latitude,
        lng: vm.alarm?.longitude,
        radius: vm.alarm?.radiusMeters,
      ),
      builder: (context, data, child) {
        if (data.lat == null) return const SizedBox.shrink();

        final center = LatLng(data.lat!, data.lng!);

        return Stack(
          children: [
            CircleLayer(
              circles: [
                CircleMarker(
                  point: center,
                  radius: data.radius!,
                  useRadiusInMeter: true,
                  color: Colors.green.withValues(alpha: 0.25),
                  borderColor: Colors.purple,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.anchor,
                    color: Colors.purple,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
