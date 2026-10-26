enum EngineHoursSource {
  manual,
  trip,
  maintenance;

  String get apiValue {
    switch (this) {
      case EngineHoursSource.manual:
        return 'Manual';
      case EngineHoursSource.trip:
        return 'Trip';
      case EngineHoursSource.maintenance:
        return 'Maintenance';
    }
  }

  static EngineHoursSource fromApiValue(String value) {
    return EngineHoursSource.values.firstWhere(
      (source) => source.apiValue == value,
      orElse: () => EngineHoursSource.manual,
    );
  }
}
