import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'logbook_service.dart';

/// Viagem salva sem conexão, esperando para ir para a API.
class PendingTrip {
  final String localId;
  final String boatId;
  final LogbookEntryInput input;

  PendingTrip({
    required this.localId,
    required this.boatId,
    required this.input,
  });

  factory PendingTrip.fromJson(Map<String, dynamic> json) {
    return PendingTrip(
      localId: json['localId'] as String,
      boatId: json['boatId'] as String,
      input: LogbookEntryInput.fromJson(json['input'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'localId': localId, 'boatId': boatId, 'input': input.toJson()};
  }
}

/// Fila local (SharedPreferences) das viagens que não puderam ser enviadas.
/// No mar é comum ficar sem sinal ao encerrar a navegação.
class PendingTripQueueService {
  static const String _key = 'pending_trips';

  Future<List<PendingTrip>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((item) => PendingTrip.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> add(PendingTrip trip) async {
    final trips = await getAll();
    await _save([...trips, trip]);
  }

  Future<void> remove(String localId) async {
    final trips = await getAll();
    await _save(trips.where((trip) => trip.localId != localId).toList());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _save(List<PendingTrip> trips) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(trips.map((trip) => trip.toJson()).toList()),
    );
  }
}
