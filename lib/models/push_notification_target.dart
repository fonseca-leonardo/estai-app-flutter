/// Para onde levar o usuário ao tocar num push ou abrir um link
/// `estai://boats/{boatId}/maintenances/{id}`.
class PushNotificationTarget {
  static const String maintenanceType = 'maintenance';

  final String type;
  final String boatId;
  final String? id;

  const PushNotificationTarget({
    required this.type,
    required this.boatId,
    this.id,
  });

  bool get isMaintenance => type == maintenanceType;

  /// Lê o `data` do push enviado pelo backend
  /// (`{type, boatId, id}`). Retorna `null` se faltar o barco.
  static PushNotificationTarget? fromData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final boatId = data['boatId'] as String?;
    if (type == null || boatId == null || boatId.isEmpty) return null;
    return PushNotificationTarget(
      type: type,
      boatId: boatId,
      id: data['id'] as String?,
    );
  }

  /// `estai://boats/{boatId}/maintenances/{id}`.
  static PushNotificationTarget? fromUri(Uri uri) {
    if (uri.scheme != 'estai' || uri.host != 'boats') return null;
    final segments = uri.pathSegments;
    if (segments.length < 2 || segments.first.isEmpty) return null;
    if (segments[1] != 'maintenances') return null;
    return PushNotificationTarget(
      type: maintenanceType,
      boatId: segments.first,
      id: segments.length > 2 ? segments[2] : null,
    );
  }
}
