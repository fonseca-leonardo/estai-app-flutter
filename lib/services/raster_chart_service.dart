import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/raster_chart.dart';

class RasterChartImportException implements Exception {
  final String message;
  RasterChartImportException(this.message);
  @override
  String toString() => message;
}

class RasterChartService {
  RasterChartService._();
  static final RasterChartService instance = RasterChartService._();

  static const _rootDir = 'raster_charts';
  static const _manifestFile = 'manifest.json';

  Future<Directory> _rootDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _rootDir));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<List<RasterChartSet>> loadAll() async {
    final root = await _rootDirectory();
    final sets = <RasterChartSet>[];
    await for (final entry in root.list()) {
      if (entry is! Directory) continue;
      final manifest = File(p.join(entry.path, _manifestFile));
      if (!await manifest.exists()) continue;
      try {
        final json =
            jsonDecode(await manifest.readAsString()) as Map<String, dynamic>;
        sets.add(RasterChartSet.fromJson(json));
      } catch (_) {
        // ignore corrupted manifests
      }
    }
    sets.sort((a, b) => b.importedAt.compareTo(a.importedAt));
    return sets;
  }

  Future<void> deleteSet(String setId) async {
    final root = await _rootDirectory();
    final dir = Directory(p.join(root.path, setId));
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  Future<void> updateChartVisibility(
    RasterChartSet set,
    String chartId,
    bool visible,
  ) async {
    for (final c in set.charts) {
      if (c.id == chartId) c.visible = visible;
    }
    await _saveManifest(set);
  }

  Future<void> _saveManifest(RasterChartSet set) async {
    final root = await _rootDirectory();
    final manifest = File(p.join(root.path, set.id, _manifestFile));
    await manifest.writeAsString(jsonEncode(set.toJson()));
  }

  Future<RasterChartSet> importZip(
    File zipFile, {
    void Function(double progress, String message)? onProgress,
  }) async {
    onProgress?.call(0.0, 'Lendo arquivo .zip...');

    final root = await _rootDirectory();
    final setId = DateTime.now().millisecondsSinceEpoch.toString();
    final setDir = Directory(p.join(root.path, setId));
    await setDir.create(recursive: true);

    try {
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      String? bsbPath;
      final kapFiles = <String, String>{};
      for (final entry in archive) {
        if (!entry.isFile) continue;
        final name = p.basename(entry.name);
        if (name.startsWith('.') || name.startsWith('_')) continue;
        final outPath = p.join(setDir.path, name);
        final out = File(outPath);
        await out.writeAsBytes(entry.content as List<int>);
        final upper = name.toUpperCase();
        if (upper.endsWith('.BSB')) {
          bsbPath = outPath;
        } else if (upper.endsWith('.KAP')) {
          kapFiles[upper] = outPath;
        }
      }

      if (kapFiles.isEmpty) {
        throw RasterChartImportException(
          'Nenhum arquivo .KAP encontrado no .zip',
        );
      }

      final catalog = bsbPath != null
          ? await _parseBsbCatalog(File(bsbPath))
          : const _BsbCatalog(entries: []);

      final charts = <RasterChart>[];
      final total = kapFiles.length;
      var index = 0;

      for (final entry in kapFiles.entries) {
        index++;
        final kapName = entry.key;
        final kapPath = entry.value;
        onProgress?.call(
          (index - 1) / total,
          'Decodificando $kapName...',
        );

        final catEntry = catalog.entries.firstWhere(
          (e) => e.fileName.toUpperCase() == kapName,
          orElse: () => _BsbCatalogEntry(
            number: p.basenameWithoutExtension(kapName),
            name: p.basenameWithoutExtension(kapName),
            type: 'Base',
            fileName: kapName,
          ),
        );

        final chart = await _processKap(
          kapPath: kapPath,
          outputDir: setDir.path,
          catalogEntry: catEntry,
        );
        charts.add(chart);
      }

      charts.sort((a, b) {
        if (a.type == b.type) return a.number.compareTo(b.number);
        return a.type == 'Base' ? -1 : 1;
      });

      final setName = catalog.parentName ?? charts.first.name;
      final setNumber = catalog.parentNumber ?? charts.first.number;
      final set = RasterChartSet(
        id: setId,
        name: setName,
        number: setNumber,
        directory: setDir.path,
        charts: charts,
        importedAt: DateTime.now(),
      );

      await _saveManifest(set);
      onProgress?.call(1.0, 'Concluído');
      return set;
    } catch (e) {
      if (await setDir.exists()) {
        await setDir.delete(recursive: true);
      }
      if (e is RasterChartImportException) rethrow;
      throw RasterChartImportException('Erro ao importar carta: $e');
    }
  }

  Future<RasterChart> _processKap({
    required String kapPath,
    required String outputDir,
    required _BsbCatalogEntry catalogEntry,
  }) async {
    final kapBytes = await File(kapPath).readAsBytes();
    final header = _parseKapHeader(kapBytes);

    if (header.width <= 0 || header.height <= 0) {
      throw RasterChartImportException(
        'Header inválido em ${p.basename(kapPath)}',
      );
    }
    if (header.refs.length < 3) {
      throw RasterChartImportException(
        'Pontos de referência insuficientes em ${p.basename(kapPath)}',
      );
    }
    if (header.palette.isEmpty) {
      throw RasterChartImportException(
        'Paleta de cores ausente em ${p.basename(kapPath)}',
      );
    }

    final corners = _computeCorners(header);

    final pngPath = p.join(
      outputDir,
      '${p.basenameWithoutExtension(kapPath)}.png',
    );

    await compute<_DecodeRequest, void>(
      _decodeKapRasterIsolate,
      _DecodeRequest(
        kapPath: kapPath,
        outputPngPath: pngPath,
        headerEnd: header.headerEnd,
        width: header.width,
        height: header.height,
        palette: header.palette,
      ),
    );

    final projection = header.projection.toUpperCase();
    final supported = projection.isEmpty || projection.contains('MERCATOR');

    return RasterChart(
      id: '${catalogEntry.number}_${p.basenameWithoutExtension(kapPath)}',
      name: catalogEntry.name,
      number: catalogEntry.number,
      type: catalogEntry.type,
      pngPath: pngPath,
      width: header.width,
      height: header.height,
      nw: corners.nw,
      ne: corners.ne,
      se: corners.se,
      sw: corners.sw,
      polygon: header.polygon,
      projection: projection.isEmpty ? 'MERCATOR' : projection,
      projectionSupported: supported,
      visible: true,
    );
  }

  Future<_BsbCatalog> _parseBsbCatalog(File bsbFile) async {
    final text = await bsbFile.readAsString(encoding: latin1);
    final lines = _foldLogicalLines(text);
    final entries = <_BsbCatalogEntry>[];
    String? parentName;
    String? parentNumber;
    for (final line in lines) {
      if (line.startsWith('CHT/')) {
        final fields = _parseFields(line.substring(4));
        final nu = fields['NU'];
        final na = fields['NA'];
        if (nu != null && nu.isNotEmpty) parentNumber = nu;
        if (na != null && na.isNotEmpty) parentName = na;
        continue;
      }
      final m = RegExp(r'^K\d+/').firstMatch(line);
      if (m == null) continue;
      final body = line.substring(m.end);
      final fields = _parseFields(body);
      final fn = fields['FN'];
      if (fn == null) continue;
      entries.add(
        _BsbCatalogEntry(
          number: fields['NU'] ?? '',
          name: fields['NA'] ?? p.basenameWithoutExtension(fn),
          type: fields['TY'] ?? 'Base',
          fileName: fn,
        ),
      );
    }
    return _BsbCatalog(
      parentName: parentName,
      parentNumber: parentNumber,
      entries: entries,
    );
  }

  _KapHeader _parseKapHeader(Uint8List bytes) {
    final headerEnd = _findHeaderEnd(bytes);
    if (headerEnd < 0) {
      throw RasterChartImportException('Separador de header KAP não encontrado');
    }
    final headerText = latin1.decode(bytes.sublist(0, headerEnd - 2));
    final lines = _foldLogicalLines(headerText);

    int width = 0, height = 0;
    String name = '';
    String number = '';
    String projection = '';
    final refs = <_RefPoint>[];
    final palette = <int>[0xFF000000];
    final polygon = <LatLng>[];

    for (final line in lines) {
      final slash = line.indexOf('/');
      if (slash < 0) continue;
      final key = line.substring(0, slash);
      final body = line.substring(slash + 1);

      if (key == 'BSB' || key == 'NOS') {
        final fields = _parseFields(body);
        if (fields['NA'] != null) name = fields['NA']!;
        if (fields['NU'] != null) number = fields['NU']!;
        final ra = fields['RA'];
        if (ra != null) {
          final parts = ra.split(',');
          if (parts.length >= 2) {
            width = int.tryParse(parts[0].trim()) ?? width;
            height = int.tryParse(parts[1].trim()) ?? height;
          }
        }
      } else if (key == 'KNP') {
        final fields = _parseFields(body);
        if (fields['PR'] != null) projection = fields['PR']!;
      } else if (key == 'REF') {
        final ref = _parseRef(body);
        if (ref != null) refs.add(ref);
      } else if (key == 'RGB') {
        final rgb = _parseRgb(body);
        if (rgb != null) {
          while (palette.length <= rgb.index) {
            palette.add(0xFF000000);
          }
          palette[rgb.index] = rgb.argb;
        }
      } else if (key == 'PLY') {
        final pt = _parsePly(body);
        if (pt != null) polygon.add(pt);
      }
    }

    return _KapHeader(
      width: width,
      height: height,
      name: name,
      number: number,
      projection: projection,
      refs: refs,
      palette: palette,
      polygon: polygon,
      headerEnd: headerEnd,
    );
  }

  int _findHeaderEnd(Uint8List bytes) {
    for (var i = 0; i < bytes.length - 1; i++) {
      if (bytes[i] == 0x1A && bytes[i + 1] == 0x00) return i + 2;
    }
    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] == 0x1A) return i + 1;
    }
    return -1;
  }

  List<String> _foldLogicalLines(String text) {
    final raw = text.split(RegExp(r'\r\n|\n|\r'));
    final logical = <String>[];
    for (final line in raw) {
      if (line.isEmpty) continue;
      if (line.startsWith(' ') || line.startsWith('\t')) {
        if (logical.isNotEmpty) {
          logical[logical.length - 1] =
              '${logical.last}${line.trimLeft()}';
        }
      } else {
        logical.add(line);
      }
    }
    return logical;
  }

  Map<String, String> _parseFields(String body) {
    final result = <String, String>{};
    String? currentKey;
    for (final part in body.split(',')) {
      final eq = part.indexOf('=');
      if (eq > 0) {
        currentKey = part.substring(0, eq).trim();
        if (!result.containsKey(currentKey)) {
          result[currentKey] = part.substring(eq + 1).trim();
        }
      } else if (currentKey != null) {
        final extra = part.trim();
        if (extra.isEmpty) continue;
        result[currentKey] = '${result[currentKey]},$extra';
      }
    }
    return result;
  }

  _RefPoint? _parseRef(String body) {
    final parts = body.split(',');
    if (parts.length < 5) return null;
    final px = double.tryParse(parts[1].trim());
    final py = double.tryParse(parts[2].trim());
    final lat = double.tryParse(parts[3].trim());
    final lon = double.tryParse(parts[4].trim());
    if (px == null || py == null || lat == null || lon == null) return null;
    return _RefPoint(px: px, py: py, lat: lat, lon: lon);
  }

  _RgbEntry? _parseRgb(String body) {
    final parts = body.split(',');
    if (parts.length < 4) return null;
    final i = int.tryParse(parts[0].trim());
    final r = int.tryParse(parts[1].trim());
    final g = int.tryParse(parts[2].trim());
    final b = int.tryParse(parts[3].trim());
    if (i == null || r == null || g == null || b == null) return null;
    return _RgbEntry(
      index: i,
      argb: 0xFF000000 | (r << 16) | (g << 8) | b,
    );
  }

  LatLng? _parsePly(String body) {
    final parts = body.split(',');
    if (parts.length < 3) return null;
    final lat = double.tryParse(parts[1].trim());
    final lon = double.tryParse(parts[2].trim());
    if (lat == null || lon == null) return null;
    return LatLng(lat, lon);
  }

  _ChartCorners _computeCorners(_KapHeader header) {
    final n = header.refs.length;
    final ax = <List<double>>[];
    final bx = <double>[];
    final by = <double>[];
    for (final r in header.refs) {
      ax.add([1, r.px, r.py]);
      bx.add(r.lon);
      by.add(_latToMercatorY(r.lat));
    }

    final lonCoeffs = _solveLeastSquares3(ax, bx);
    final mercYCoeffs = _solveLeastSquares3(ax, by);

    LatLng cornerAt(double px, double py) {
      final lon = lonCoeffs[0] + lonCoeffs[1] * px + lonCoeffs[2] * py;
      final mercY =
          mercYCoeffs[0] + mercYCoeffs[1] * px + mercYCoeffs[2] * py;
      return LatLng(_mercatorYToLat(mercY), lon);
    }

    final w = header.width.toDouble();
    final h = header.height.toDouble();
    return _ChartCorners(
      nw: cornerAt(0, 0),
      ne: cornerAt(w, 0),
      se: cornerAt(w, h),
      sw: cornerAt(0, h),
      pointCount: n,
    );
  }

  static double _latToMercatorY(double lat) {
    final rad = lat * math.pi / 180.0;
    return math.log(math.tan(math.pi / 4 + rad / 2));
  }

  static double _mercatorYToLat(double y) {
    return (2 * math.atan(math.exp(y)) - math.pi / 2) * 180.0 / math.pi;
  }

  static List<double> _solveLeastSquares3(
    List<List<double>> a,
    List<double> b,
  ) {
    final ata = List<List<double>>.generate(
      3,
      (_) => List<double>.filled(3, 0.0),
    );
    final atb = List<double>.filled(3, 0.0);
    for (var k = 0; k < a.length; k++) {
      for (var i = 0; i < 3; i++) {
        atb[i] += a[k][i] * b[k];
        for (var j = 0; j < 3; j++) {
          ata[i][j] += a[k][i] * a[k][j];
        }
      }
    }
    return _solve3x3(ata, atb);
  }

  static List<double> _solve3x3(List<List<double>> m, List<double> v) {
    final a = [
      [m[0][0], m[0][1], m[0][2], v[0]],
      [m[1][0], m[1][1], m[1][2], v[1]],
      [m[2][0], m[2][1], m[2][2], v[2]],
    ];
    for (var i = 0; i < 3; i++) {
      var pivot = i;
      for (var k = i + 1; k < 3; k++) {
        if (a[k][i].abs() > a[pivot][i].abs()) pivot = k;
      }
      if (pivot != i) {
        final tmp = a[i];
        a[i] = a[pivot];
        a[pivot] = tmp;
      }
      final p = a[i][i];
      if (p.abs() < 1e-12) {
        return [0, 0, 0];
      }
      for (var j = i; j < 4; j++) {
        a[i][j] /= p;
      }
      for (var k = 0; k < 3; k++) {
        if (k == i) continue;
        final f = a[k][i];
        for (var j = i; j < 4; j++) {
          a[k][j] -= f * a[i][j];
        }
      }
    }
    return [a[0][3], a[1][3], a[2][3]];
  }
}

class _BsbCatalog {
  final String? parentName;
  final String? parentNumber;
  final List<_BsbCatalogEntry> entries;
  const _BsbCatalog({
    this.parentName,
    this.parentNumber,
    required this.entries,
  });
}

class _BsbCatalogEntry {
  final String number;
  final String name;
  final String type;
  final String fileName;
  _BsbCatalogEntry({
    required this.number,
    required this.name,
    required this.type,
    required this.fileName,
  });
}

class _RefPoint {
  final double px;
  final double py;
  final double lat;
  final double lon;
  _RefPoint({
    required this.px,
    required this.py,
    required this.lat,
    required this.lon,
  });
}

class _RgbEntry {
  final int index;
  final int argb;
  _RgbEntry({required this.index, required this.argb});
}

class _KapHeader {
  final int width;
  final int height;
  final String name;
  final String number;
  final String projection;
  final List<_RefPoint> refs;
  final List<int> palette;
  final List<LatLng> polygon;
  final int headerEnd;
  _KapHeader({
    required this.width,
    required this.height,
    required this.name,
    required this.number,
    required this.projection,
    required this.refs,
    required this.palette,
    required this.polygon,
    required this.headerEnd,
  });
}

class _ChartCorners {
  final LatLng nw;
  final LatLng ne;
  final LatLng se;
  final LatLng sw;
  final int pointCount;
  _ChartCorners({
    required this.nw,
    required this.ne,
    required this.se,
    required this.sw,
    required this.pointCount,
  });
}

class _DecodeRequest {
  final String kapPath;
  final String outputPngPath;
  final int headerEnd;
  final int width;
  final int height;
  final List<int> palette;
  _DecodeRequest({
    required this.kapPath,
    required this.outputPngPath,
    required this.headerEnd,
    required this.width,
    required this.height,
    required this.palette,
  });
}

Future<void> _decodeKapRasterIsolate(_DecodeRequest req) async {
  final bytes = File(req.kapPath).readAsBytesSync();
  var pos = req.headerEnd;
  if (pos >= bytes.length) {
    throw RasterChartImportException('KAP sem dados raster');
  }

  final depth = bytes[pos];
  pos += 1;
  if (depth < 1 || depth > 7) {
    throw RasterChartImportException('Profundidade inválida: $depth');
  }

  final width = req.width;
  final height = req.height;
  final lenMask = (1 << (7 - depth)) - 1;
  final colorShift = 7 - depth;

  final image = img.Image(width: width, height: height, numChannels: 4);
  final palette = req.palette;

  var rowsDecoded = 0;
  while (pos < bytes.length && rowsDecoded < height) {
    int rowIdx = 0;
    int b;
    do {
      if (pos >= bytes.length) break;
      b = bytes[pos++];
      rowIdx = (rowIdx << 7) | (b & 0x7F);
    } while ((b & 0x80) != 0);

    final y = rowIdx - 1;
    var x = 0;

    while (pos < bytes.length) {
      final first = bytes[pos++];
      if (first == 0) break;
      final color = (first & 0x7F) >> colorShift;
      var length = first & lenMask;
      var more = (first & 0x80) != 0;
      while (more && pos < bytes.length) {
        final c = bytes[pos++];
        length = (length << 7) | (c & 0x7F);
        more = (c & 0x80) != 0;
      }
      length += 1;

      final argb = color < palette.length ? palette[color] : 0xFF000000;
      final a = (argb >> 24) & 0xFF;
      final r = (argb >> 16) & 0xFF;
      final g = (argb >> 8) & 0xFF;
      final bb = argb & 0xFF;

      if (y >= 0 && y < height && x < width) {
        final endX = math.min(x + length, width);
        for (var px = x; px < endX; px++) {
          image.setPixelRgba(px, y, r, g, bb, a);
        }
      }
      x += length;
    }

    rowsDecoded++;
  }

  final png = img.encodePng(image);
  File(req.outputPngPath).writeAsBytesSync(png);
}
