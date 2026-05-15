import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/raster_chart.dart';
import '../services/raster_chart_service.dart';

class RasterChartsViewModel extends ChangeNotifier {
  final RasterChartService _service;

  List<RasterChartSet> _sets = [];
  // Set IDs in activation order: last = most recently activated = rendered on top
  final List<String> _renderOrder = [];
  bool _isLoading = false;
  bool _isImporting = false;
  double _importProgress = 0.0;
  String _importMessage = '';
  String? _errorMessage;

  RasterChartsViewModel({RasterChartService? service})
    : _service = service ?? RasterChartService.instance {
    loadAll();
  }

  List<RasterChartSet> get sets => List.unmodifiable(_sets);
  bool get isLoading => _isLoading;
  bool get isImporting => _isImporting;
  double get importProgress => _importProgress;
  String get importMessage => _importMessage;
  String? get errorMessage => _errorMessage;

  ({RasterChartSet set, RasterChart chart})? findChartByNumber(String number) {
    for (final set in _sets) {
      for (final chart in set.charts) {
        if (chart.number == number) return (set: set, chart: chart);
      }
    }
    return null;
  }

  /// Looks up an imported chart that matches a chart boundary entry.
  /// Tries multiple keys because BSB `NU=` may have leading zeros, suffixes
  /// like `(INT.2)`, or be missing entirely (falling back to the .KAP filename).
  ({RasterChartSet set, RasterChart chart})? findImportedChartFor({
    required String id,
    required String name,
  }) {
    final targetInt = _firstInt(id);
    final targetDigits = _digits(id);
    final targetName = _normalizeName(name);

    for (final set in _sets) {
      if (targetInt != null && _firstInt(set.number ?? '') == targetInt) {
        final chart = set.charts.isNotEmpty ? set.charts.first : null;
        if (chart != null) return (set: set, chart: chart);
      }
      for (final chart in set.charts) {
        if (targetInt != null && _firstInt(chart.number) == targetInt) {
          return (set: set, chart: chart);
        }
        if (targetInt != null && _firstInt(chart.id) == targetInt) {
          return (set: set, chart: chart);
        }
        // Marinha panel convention: parent NU is a prefix of each KAP's NU
        // (e.g. parent "1712" → panels "171202", "171203"). Only apply when
        // the boundary id has 4+ digits to avoid collisions like "10" ⊂ "100".
        if (targetDigits.length >= 4) {
          final chartDigits = _digits(chart.number);
          if (chartDigits.startsWith(targetDigits) &&
              chartDigits.length > targetDigits.length) {
            return (set: set, chart: chart);
          }
        }
        if (targetName.isNotEmpty &&
            _normalizeName(chart.name) == targetName) {
          return (set: set, chart: chart);
        }
      }
    }
    return null;
  }

  static String _digits(String value) =>
      value.replaceAll(RegExp(r'\D'), '');

  static int? _firstInt(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  static String _normalizeName(String value) =>
      value.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');

  void _bringToFront(String setId) {
    _renderOrder.remove(setId);
    _renderOrder.add(setId);
  }

  List<RasterChart> get visibleCharts {
    final inOrder = _renderOrder
        .map((id) => _sets.where((s) => s.id == id).firstOrNull)
        .whereType<RasterChartSet>()
        .toList();
    final rest = _sets.where((s) => !_renderOrder.contains(s.id)).toList();
    return [...rest, ...inOrder]
        .expand((s) => s.charts.where((c) => c.visible))
        .toList();
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _sets = await _service.loadAll();
    } catch (e) {
      _errorMessage = 'Erro ao carregar cartas: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  static const int maxSets = 2;

  Future<RasterChartSet?> importZip(File zipFile) async {
    _isImporting = true;
    _importProgress = 0.0;
    _importMessage = '';
    _errorMessage = null;
    notifyListeners();

    try {
      final visibleSets = _sets.where(
        (s) => s.charts.any((c) => c.visible),
      ).toList();
      if (visibleSets.length >= maxSets) {
        await setSetVisibility(visibleSets.last.id, false);
      }

      final set = await _service.importZip(
        zipFile,
        onProgress: (progress, message) {
          _importProgress = progress;
          _importMessage = message;
          notifyListeners();
        },
      );
      _sets = [set, ..._sets];
      _bringToFront(set.id);
      _isImporting = false;
      notifyListeners();
      return set;
    } catch (e) {
      _errorMessage = e is RasterChartImportException
          ? e.message
          : 'Erro ao importar carta: $e';
      _isImporting = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteSet(String setId) async {
    await _service.deleteSet(setId);
    _sets = _sets.where((s) => s.id != setId).toList();
    notifyListeners();
  }

  // Hides the oldest visible sets (excluding [keepSetId]) until
  // visible set count is below maxSets.
  void _hideExcessSets(String keepSetId) {
    final excess = _sets
        .where((s) => s.id != keepSetId && s.charts.any((c) => c.visible))
        .toList();
    while (excess.length >= maxSets) {
      final toHide = excess.removeLast();
      for (final chart in toHide.charts) {
        chart.visible = false;
        _service.updateChartVisibility(toHide, chart.id, false);
      }
    }
  }

  Future<void> toggleChartVisibility(String setId, String chartId) async {
    final set = _sets.firstWhere(
      (s) => s.id == setId,
      orElse: () => throw StateError('Set not found'),
    );
    final chart = set.charts.firstWhere((c) => c.id == chartId);
    final setWasHidden = set.charts.every((c) => !c.visible);
    chart.visible = !chart.visible;
    if (chart.visible && setWasHidden) {
      _hideExcessSets(setId);
      _bringToFront(setId);
    }
    notifyListeners();
    await _service.updateChartVisibility(set, chartId, chart.visible);
  }

  Future<void> setSetVisibility(String setId, bool visible) async {
    final set = _sets.firstWhere(
      (s) => s.id == setId,
      orElse: () => throw StateError('Set not found'),
    );
    if (visible) {
      _hideExcessSets(setId);
      _bringToFront(setId);
    }
    for (final chart in set.charts) {
      chart.visible = visible;
    }
    notifyListeners();
    for (final chart in set.charts) {
      await _service.updateChartVisibility(set, chart.id, visible);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
