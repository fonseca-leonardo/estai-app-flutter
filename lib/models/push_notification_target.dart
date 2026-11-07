/// Para onde levar o usuário ao tocar num push ou abrir um link do Diário
/// da Embarcação:
///
/// - `estai://boats/{boatId}/maintenances/{id}`
/// - `estai://boats/{boatId}/reminders/{id}`
/// - `estai://boats/{boatId}/documents/{id}`
/// - `estai://me/documents/{id}` (documento pessoal, sem barco)
class PushNotificationTarget {
  static const String maintenanceType = 'maintenance';
  static const String reminderType = 'reminder';
  static const String documentType = 'document';

  static const Map<String, String> _typeBySegment = {
    'maintenances': maintenanceType,
    'reminders': reminderType,
    'documents': documentType,
  };

  final String type;

  /// Ausente só em documento pessoal.
  final String? boatId;
  final String? id;

  const PushNotificationTarget({required this.type, this.boatId, this.id});

  bool get isMaintenance => type == maintenanceType && boatId != null;
  bool get isReminder => type == reminderType && boatId != null;
  bool get isDocument => type == documentType && id != null;

  /// Lê o `data` do push enviado pelo backend (`{type, boatId, id}`).
  /// Retorna `null` se faltar o barco (ou, num documento, o id).
  static PushNotificationTarget? fromData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final rawBoatId = data['boatId'] as String?;
    final boatId = rawBoatId == null || rawBoatId.isEmpty ? null : rawBoatId;
    final id = data['id'] as String?;
    if (type == null) return null;
    if (type == documentType ? id == null : boatId == null) return null;
    return PushNotificationTarget(type: type, boatId: boatId, id: id);
  }

  static PushNotificationTarget? fromUri(Uri uri) {
    if (uri.scheme != 'estai') return null;
    final segments = uri.pathSegments;

    if (uri.host == 'me') {
      if (segments.length < 2 || segments.first != 'documents') return null;
      return PushNotificationTarget(type: documentType, id: segments[1]);
    }

    if (uri.host != 'boats') return null;
    if (segments.length < 2 || segments.first.isEmpty) return null;
    final type = _typeBySegment[segments[1]];
    if (type == null) return null;
    final id = segments.length > 2 ? segments[2] : null;
    if (type == documentType && id == null) return null;
    return PushNotificationTarget(type: type, boatId: segments.first, id: id);
  }
}
