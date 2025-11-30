class CoordinateFormatter {
  /// Formata a latitude em formato DMS (graus, minutos, segundos)
  ///
  /// Exemplo: -23.5505 -> "23º 33' 1.80" S"
  static String formatLatitude(double latitude) {
    final absLat = latitude.abs();
    final degrees = absLat.floor();
    final minutes = ((absLat - degrees) * 60).floor();
    final seconds = ((absLat - degrees) * 60 - minutes) * 60;
    final direction = latitude >= 0 ? 'N' : 'S';
    return '$degreesº $minutes\' ${seconds.toStringAsFixed(2)}" $direction';
  }

  /// Formata a longitude em formato DMS (graus, minutos, segundos)
  ///
  /// Exemplo: -46.6333 -> "46º 37' 59.88" W"
  static String formatLongitude(double longitude) {
    final absLon = longitude.abs();
    final degrees = absLon.floor();
    final minutes = ((absLon - degrees) * 60).floor();
    final seconds = ((absLon - degrees) * 60 - minutes) * 60;
    final direction = longitude >= 0 ? 'E' : 'W';
    return '$degreesº $minutes\' ${seconds.toStringAsFixed(2)}" $direction';
  }

  /// Converte velocidade de m/s para nós (kt)
  ///
  /// 1 nó = 1.852 km/h = 0.514444 m/s
  /// Então: velocidade em nós = velocidade em m/s / 0.514444
  ///
  /// Exemplo: 5.14 m/s -> 10.0 kt
  static double metersPerSecondToKnots(double speedMs) {
    // 1 nó = 0.514444 m/s
    return speedMs / 0.514444;
  }

  /// Formata velocidade em nós (kt)
  ///
  /// Exemplo: 5.14 m/s -> "10.0 kt"
  static String formatSpeedInKnots(double? speedMs) {
    if (speedMs == null || speedMs < 0) {
      return '0.0 kt';
    }
    final knots = metersPerSecondToKnots(speedMs);
    return '${knots.toStringAsFixed(1)} kt';
  }

  /// Formata heading (direção) em graus
  ///
  /// O heading vem em graus (0-360), onde 0 é Norte
  /// Exemplo: 90.0 -> "90º"
  static String formatHeading(double? heading) {
    if (heading == null || heading < 0 || heading >= 360) {
      return '--º';
    }
    return '${heading.toStringAsFixed(0)}º';
  }
}
