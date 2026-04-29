import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import '../../services/offline_basemap_service.dart';
import '../../widgets/analytics_screen_mixin.dart';

class MbtilesTestScreen extends StatefulWidget {
  const MbtilesTestScreen({super.key});

  @override
  State<MbtilesTestScreen> createState() => _MbtilesTestScreenState();
}

class _MbtilesTestScreenState extends State<MbtilesTestScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MbtilesTestScreen';

  final MapController _mapController = MapController();
  late final Future<OfflineBasemapData> _futureData;
  bool _showMbtiles = true;

  @override
  void initState() {
    super.initState();
    _futureData = OfflineBasemapService.instance.load();
  }

  LatLng _initialCenter(MbTilesMetadata metadata) {
    if (metadata.defaultCenter != null) return metadata.defaultCenter!;
    final bounds = metadata.bounds;
    if (bounds != null) {
      return LatLng(
        (bounds.top + bounds.bottom) / 2,
        (bounds.left + bounds.right) / 2,
      );
    }
    return const LatLng(0, 0);
  }

  double _initialZoom(MbTilesMetadata metadata) {
    if (metadata.defaultZoom != null) return metadata.defaultZoom!;
    if (metadata.minZoom != null && metadata.maxZoom != null) {
      return (metadata.minZoom! + metadata.maxZoom!) / 2;
    }
    return metadata.minZoom ?? metadata.maxZoom ?? 12.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MBTiles Test'),
        actions: [
          IconButton(
            tooltip: _showMbtiles ? 'Ocultar MBTiles' : 'Mostrar MBTiles',
            icon: Icon(_showMbtiles ? Icons.layers : Icons.layers_clear),
            onPressed: () => setState(() => _showMbtiles = !_showMbtiles),
          ),
        ],
      ),
      body: FutureBuilder<OfflineBasemapData>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erro ao carregar MBTiles:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final center = _initialCenter(data.metadata);
          final zoom = _initialZoom(data.metadata);
          final minZoom = data.metadata.minZoom;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: zoom,
                  minZoom: minZoom,
                  maxZoom: 22,
                ),
                children: [
                  if (_showMbtiles)
                    VectorTileLayer(
                      tileProviders: data.tileProviders,
                      theme: data.theme,
                      maximumZoom: data.metadata.maxZoom,
                    ),
                ],
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Card(
                  color: Colors.white.withValues(alpha: 0.85),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '${data.metadata.name} (${data.metadata.format}) '
                      'z${data.metadata.minZoom}–${data.metadata.maxZoom}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
