import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TileCacheService {
  static final TileCacheService instance = TileCacheService._();
  TileCacheService._();

  Future<Directory> _mapDir(String mapId) async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/tile_cache/$mapId');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  String _filename(int z, int x, int y, bool darkMode) =>
      darkMode ? '${z}_${x}_${y}_dark.png' : '${z}_${x}_${y}.png';

  Future<File?> getTileFile(
      String mapId, int z, int x, int y, bool darkMode) async {
    final dir = await _mapDir(mapId);
    final file = File('${dir.path}/${_filename(z, x, y, darkMode)}');
    return file.existsSync() ? file : null;
  }

  Future<void> saveTile(
      String mapId, int z, int x, int y, bool darkMode, List<int> bytes) async {
    try {
      final dir = await _mapDir(mapId);
      final file = File('${dir.path}/${_filename(z, x, y, darkMode)}');
      await file.writeAsBytes(bytes, flush: true);
    } catch (_) {}
  }

  Future<int> getCacheSizeBytes(String mapId) async {
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/tile_cache/$mapId');
      if (!dir.existsSync()) return 0;
      int total = 0;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) total += await entity.length();
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  Future<void> clearCache(String mapId) async {
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/tile_cache/$mapId');
      if (dir.existsSync()) await dir.delete(recursive: true);
    } catch (_) {}
  }
}

String formatCacheBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
