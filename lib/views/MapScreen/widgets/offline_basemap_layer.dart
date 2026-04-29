import 'package:flutter/material.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import '../../../services/offline_basemap_service.dart';

class OfflineBasemapLayer extends StatefulWidget {
  const OfflineBasemapLayer({super.key});

  @override
  State<OfflineBasemapLayer> createState() => _OfflineBasemapLayerState();
}

class _OfflineBasemapLayerState extends State<OfflineBasemapLayer> {
  late final Future<OfflineBasemapData> _future;

  @override
  void initState() {
    super.initState();
    _future = OfflineBasemapService.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OfflineBasemapData>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final data = snapshot.data!;
        return VectorTileLayer(
          tileProviders: data.tileProviders,
          theme: data.theme,
          maximumZoom: 22,
        );
      },
    );
  }
}
