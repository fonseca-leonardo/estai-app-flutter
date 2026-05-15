import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/chart_boundary.dart';

class ChartBoundaryService {
  ChartBoundaryService._();
  static final ChartBoundaryService instance = ChartBoundaryService._();

  static const _assetPath = 'assets/coordenate-charts.json';

  List<ChartBoundary>? _cache;
  Future<List<ChartBoundary>>? _loading;

  Future<List<ChartBoundary>> loadAll() {
    final cached = _cache;
    if (cached != null) return Future.value(cached);
    return _loading ??= _load();
  }

  Future<List<ChartBoundary>> _load() async {
    final raw = await rootBundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List<dynamic>;
    final parsed = list
        .map((e) => ChartBoundary.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _cache = parsed;
    return parsed;
  }
}
