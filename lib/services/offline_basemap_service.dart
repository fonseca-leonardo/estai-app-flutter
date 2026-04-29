import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mbtiles/mbtiles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_mbtiles/vector_map_tiles_mbtiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;

class OfflineBasemapData {
  final MbTiles mbtiles;
  final MbTilesMetadata metadata;
  final vtr.Theme theme;
  final TileProviders tileProviders;

  OfflineBasemapData({
    required this.mbtiles,
    required this.metadata,
    required this.theme,
    required this.tileProviders,
  });
}

class OfflineBasemapService {
  static const String mbtilesAssetPath = 'assets/maps/world2.mbtiles';
  static const String styleAssetPath = 'assets/maps/protomaps_style.json';
  static const String sourceName = 'protomaps';

  OfflineBasemapService._();
  static final OfflineBasemapService instance = OfflineBasemapService._();

  Future<OfflineBasemapData>? _loading;

  Future<OfflineBasemapData> load() {
    return _loading ??= _doLoad();
  }

  Future<OfflineBasemapData> _doLoad() async {
    final dir = await getApplicationSupportDirectory();
    final fileName = mbtilesAssetPath.split('/').last;
    final file = File('${dir.path}/$fileName');

    final assetBytes = await rootBundle.load(mbtilesAssetPath);
    final assetLength = assetBytes.lengthInBytes;

    if (!await file.exists() || (await file.length()) != assetLength) {
      await file.writeAsBytes(
        assetBytes.buffer.asUint8List(
          assetBytes.offsetInBytes,
          assetBytes.lengthInBytes,
        ),
        flush: true,
      );
    }

    final mbtiles = MbTiles(mbtilesPath: file.path);
    final metadata = mbtiles.getMetadata();

    final styleJson =
        jsonDecode(await rootBundle.loadString(styleAssetPath))
            as Map<String, dynamic>;
    final theme = vtr.ThemeReader().read(styleJson);

    final provider = MbTilesVectorTileProvider(mbtiles: mbtiles);
    final tileProviders = TileProviders({sourceName: provider});

    return OfflineBasemapData(
      mbtiles: mbtiles,
      metadata: metadata,
      theme: theme,
      tileProviders: tileProviders,
    );
  }
}
