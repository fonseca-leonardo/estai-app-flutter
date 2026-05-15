import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../models/chart_boundary.dart';
import '../../../viewmodels/chartplotter_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';

class ChartplotterLayer extends StatelessWidget {
  const ChartplotterLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, vm) => vm.isChartplotterMode,
      builder: (context, enabled, _) {
        if (!enabled) return const SizedBox.shrink();
        final boundaries = context.watch<ChartplotterViewModel>().allBoundaries;
        if (boundaries.isEmpty) return const SizedBox.shrink();

        final camera = MapCamera.of(context);
        final bounds = camera.visibleBounds;
        final center = camera.center;

        final polygons = <Polygon>[];
        for (final b in boundaries) {
          if (!b.intersects(
            bounds.south,
            bounds.north,
            bounds.west,
            bounds.east,
          )) {
            continue;
          }
          polygons.add(_buildPolygon(b, center));
        }
        if (polygons.isEmpty) return const SizedBox.shrink();
        return PolygonLayer(polygons: polygons);
      },
    );
  }

  Polygon _buildPolygon(ChartBoundary b, LatLng center) {
    final selected =
        center.latitude >= b.minLat &&
        center.latitude <= b.maxLat &&
        center.longitude >= b.minLon &&
        center.longitude <= b.maxLon;
    final color = selected ? Colors.greenAccent : Colors.orangeAccent;
    return Polygon(
      points: [
        LatLng(b.maxLat, b.minLon),
        LatLng(b.maxLat, b.maxLon),
        LatLng(b.minLat, b.maxLon),
        LatLng(b.minLat, b.minLon),
      ],
      borderColor: color,
      borderStrokeWidth: selected ? 2.5 : 1.5,
      color: color.withAlpha(selected ? 20 : 30),
      label: b.id,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
      ),
      labelPlacement: PolygonLabelPlacement.centroid,
    );
  }
}
