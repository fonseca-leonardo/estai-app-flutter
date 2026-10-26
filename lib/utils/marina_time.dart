import 'package:intl/intl.dart';

/// Horário local da marina. A API usa `America/Sao_Paulo` fixo (UTC-3, sem
/// horário de verão) para montar os slots e filtrar por dia.
class MarinaTime {
  MarinaTime._();

  static const Duration offset = Duration(hours: -3);

  /// Converte um instante para o relógio da marina. O resultado é um
  /// `DateTime` em UTC cujos campos (dia, hora) são os da marina; use-o só
  /// para exibir ou agrupar, nunca para mandar para a API.
  static DateTime toMarinaLocal(DateTime instant) =>
      instant.toUtc().add(offset);

  /// Data de hoje no relógio da marina, sem hora.
  static DateTime today() {
    final now = toMarinaLocal(DateTime.now());
    return DateTime.utc(now.year, now.month, now.day);
  }

  /// Dia (sem hora) do instante, no relógio da marina.
  static DateTime dayOf(DateTime instant) {
    final local = toMarinaLocal(instant);
    return DateTime.utc(local.year, local.month, local.day);
  }

  /// `YYYY-MM-DD`, o formato de `from`/`to` da API.
  static String formatYmd(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  static String formatTime(DateTime instant) =>
      DateFormat.Hm().format(toMarinaLocal(instant));

  static String formatDate(DateTime instant, String locale) =>
      DateFormat.yMMMEd(locale).format(toMarinaLocal(instant));
}
