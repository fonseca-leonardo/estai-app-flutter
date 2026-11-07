import '../l10n/app_localizations.dart';
import 'document_attachment.dart';
import 'document_status.dart';
import 'document_type.dart';
import 'reminder_settings.dart';

/// Documento com validade: do barco ([boatId] preenchido) ou pessoal, como
/// a habilitação ([boatId] nulo). O backend avisa antes do vencimento.
class BoatDocument {
  final String id;
  final String? boatId;
  final DocumentType type;
  final String? title;
  final String? number;
  final String? issuer;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final String? notes;
  final ReminderSettings reminder;
  final List<DocumentAttachment> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  BoatDocument({
    required this.id,
    this.boatId,
    required this.type,
    this.title,
    this.number,
    this.issuer,
    this.issuedAt,
    this.expiresAt,
    this.notes,
    required this.reminder,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPersonal => boatId == null;

  /// O título informado ou, sem ele, o nome do tipo.
  String displayTitle(AppLocalizations l10n) {
    final custom = title?.trim();
    return custom == null || custom.isEmpty ? type.label(l10n) : custom;
  }

  DocumentStatus status({DateTime? now}) =>
      DocumentStatus.of(expiresAt, now: now);

  /// Dias até o vencimento (negativo se já venceu), ou `null` sem validade.
  int? daysRemaining({DateTime? now}) {
    final expires = expiresAt;
    return expires == null ? null : DocumentStatus.daysUntil(expires, now: now);
  }

  factory BoatDocument.fromJson(Map<String, dynamic> json) {
    final reminder = json['reminder'] as Map<String, dynamic>?;
    return BoatDocument(
      id: json['id'] as String,
      boatId: json['boatId'] as String?,
      type: DocumentType.fromApiValue(json['type'] as String),
      title: json['title'] as String?,
      number: json['number'] as String?,
      issuer: json['issuer'] as String?,
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? ''),
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? ''),
      notes: json['notes'] as String?,
      reminder: reminder != null
          ? ReminderSettings.fromJson(reminder)
          : const ReminderSettings.disabled(),
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map(
            (item) => DocumentAttachment.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
