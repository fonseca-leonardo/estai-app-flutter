import 'package:intl/intl.dart';

/// Formatação e leitura de horas de motor e valores decimais digitados.
class EngineHoursFormat {
  EngineHoursFormat._();

  /// `1.234,5` (pt) / `1,234.5` (en), sem casas decimais quando inteiro.
  static String format(double hours, String locale) =>
      NumberFormat('#,##0.#', locale).format(hours);

  /// Valor para preencher um campo de texto: sem separador de milhar, para
  /// que [parse] leia de volta.
  static String toInput(double hours) => hours == hours.roundToDouble()
      ? hours.toStringAsFixed(0)
      : hours.toString();

  /// Aceita vírgula ou ponto como separador decimal. Retorna `null` para
  /// texto vazio ou inválido.
  static double? parse(String text) {
    final normalized = text.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }
}
