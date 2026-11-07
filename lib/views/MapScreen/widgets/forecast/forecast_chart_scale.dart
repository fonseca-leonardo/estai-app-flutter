import '../../../../viewmodels/weather_forecast_viewmodel.dart';

/// Converte horas em posição horizontal do gráfico: x = horas desde a
/// primeira hora da previsão, e cada hora ocupa [pixelsPerHour].
class ForecastChartScale {
  static const double pixelsPerHour = 14;

  final DateTime start;
  final int hourCount;

  const ForecastChartScale({required this.start, required this.hourCount});

  factory ForecastChartScale.of(List<ForecastHourData> hours) {
    return ForecastChartScale(
      start: hours.isEmpty ? DateTime.now() : hours.first.timeLocal,
      hourCount: hours.length,
    );
  }

  double get maxX => (hourCount - 1).clamp(0, 1 << 20).toDouble();

  /// Largura total do gráfico rolável.
  double get width => (hourCount * pixelsPerHour).clamp(1, double.infinity);

  double xOf(DateTime time) =>
      time.difference(start).inMinutes / Duration.minutesPerHour;

  DateTime timeOf(double x) => start.add(Duration(minutes: (x * 60).round()));

  /// Posição em pixels de [x] dentro da largura do gráfico.
  double pixelOf(double x) => maxX == 0 ? 0 : x / maxX * width;

  /// Deslocamento da rolagem para deixar [time] perto da borda esquerda.
  double scrollOffsetFor(DateTime time, {double leadHours = 2}) =>
      pixelOf(xOf(time) - leadHours).clamp(0, double.infinity);
}
