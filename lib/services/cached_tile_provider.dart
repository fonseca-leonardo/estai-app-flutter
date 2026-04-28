import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'tile_cache_service.dart';

class CachedTileProvider extends TileProvider {
  final String mapId;
  final bool darkMode;
  final TileCacheService cacheService;
  final http.Client _httpClient;

  CachedTileProvider({
    required this.mapId,
    required this.darkMode,
    required this.cacheService,
    super.headers,
  }) : _httpClient = http.Client();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final url = getTileUrl(coordinates, options);
    return _CachedTileImageProvider(
      url: url,
      mapId: mapId,
      z: coordinates.z,
      x: coordinates.x,
      y: coordinates.y,
      darkMode: darkMode,
      cacheService: cacheService,
      client: _httpClient,
    );
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}

@immutable
class _CachedTileImageProvider
    extends ImageProvider<_CachedTileImageProvider> {
  final String url;
  final String mapId;
  final int z, x, y;
  final bool darkMode;
  final TileCacheService cacheService;
  final http.Client client;

  const _CachedTileImageProvider({
    required this.url,
    required this.mapId,
    required this.z,
    required this.x,
    required this.y,
    required this.darkMode,
    required this.cacheService,
    required this.client,
  });

  @override
  Future<_CachedTileImageProvider> obtainKey(
      ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
      _CachedTileImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
      informationCollector: () => [DiagnosticsProperty('URL', url)],
    );
  }

  Future<ui.Codec> _loadAsync(ImageDecoderCallback decode) async {
    final cachedFile =
        await cacheService.getTileFile(mapId, z, x, y, darkMode);
    if (cachedFile != null) {
      try {
        final bytes = await cachedFile.readAsBytes();
        if (bytes.isNotEmpty) {
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
          return decode(buffer);
        }
      } catch (_) {
        // arquivo corrompido — tenta rede
      }
    }

    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      await cacheService.saveTile(
          mapId, z, x, y, darkMode, response.bodyBytes);
      final buffer =
          await ui.ImmutableBuffer.fromUint8List(response.bodyBytes);
      return decode(buffer);
    }

    throw NetworkImageLoadException(
        statusCode: response.statusCode, uri: Uri.parse(url));
  }

  @override
  bool operator ==(Object other) =>
      other is _CachedTileImageProvider &&
      url == other.url &&
      darkMode == other.darkMode;

  @override
  int get hashCode => Object.hash(url, darkMode);
}
