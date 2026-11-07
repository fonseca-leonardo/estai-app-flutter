import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat_document.dart';
import '../../models/document_attachment.dart';
import '../../viewmodels/document_detail_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/error_state.dart';
import '../AttachmentViewerScreen/attachment_viewer_screen.dart';
import '../DocumentFormScreen/document_form_screen.dart';
import '../DocumentFormScreen/widgets/delete_document_dialog.dart';
import '../MaintenanceDetailsScreen/widgets/details_section_card.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import '../RampBookingScreen/widgets/summary_row.dart';
import 'widgets/document_attachments_gallery.dart';
import 'widgets/document_details_header.dart';

/// Detalhe de um documento: dados, validade, aviso e anexos, com editar e
/// excluir. Volta `true` se algo mudou, para a lista recarregar.
///
/// Abre com o documento da lista ([initial]) ou só com o id, vindo de um
/// push; nos dois casos busca de novo para renovar as URLs dos anexos.
class DocumentDetailScreen extends StatefulWidget {
  final String documentId;
  final BoatDocument? initial;

  const DocumentDetailScreen({
    super.key,
    required this.documentId,
    this.initial,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'DocumentDetailScreen';

  late final DocumentDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DocumentDetailViewModel(
      documentId: widget.documentId,
      initial: widget.initial,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _viewModel.load());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _edit(BoatDocument document) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => DocumentFormScreen(document: document)),
    );
    if (saved == true) _viewModel.onEdited();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDeleteDocumentDialog(context);
    if (!confirmed) return;

    final success = await _viewModel.delete();
    if (!mounted) return;
    if (success) {
      navigator.pop(true);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteDocumentError)));
    }
  }

  Future<void> _openAttachment(DocumentAttachment attachment) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final url = attachment.url;
    if (url == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.attachmentOpenError)));
      return;
    }

    if (attachment.isImage) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              AttachmentViewerScreen(url: url, title: attachment.fileName),
        ),
      );
      return;
    }

    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.attachmentOpenError)));
    }
  }

  String? _text(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();

  List<Widget> _detailRows(
    AppLocalizations l10n,
    String locale,
    BoatDocument document,
  ) {
    final number = _text(document.number);
    final issuer = _text(document.issuer);
    final issuedAt = document.issuedAt;
    final expiresAt = document.expiresAt;
    final reminder = document.reminder;
    final format = DateFormat.yMMMd(locale);

    return [
      if (number != null)
        SummaryRow(
          icon: Icons.tag,
          label: l10n.documentNumberLabel,
          value: number,
        ),
      if (issuer != null)
        SummaryRow(
          icon: Icons.account_balance_outlined,
          label: l10n.documentIssuerLabel,
          value: issuer,
        ),
      SummaryRow(
        icon: Icons.event_outlined,
        label: l10n.documentExpiresAtLabel,
        value: expiresAt != null
            ? format.format(expiresAt.toLocal())
            : l10n.documentNoExpiryLabel,
      ),
      if (issuedAt != null)
        SummaryRow(
          icon: Icons.event_available_outlined,
          label: l10n.documentIssuedAtLabel,
          value: format.format(issuedAt.toLocal()),
        ),
      if (expiresAt != null)
        SummaryRow(
          icon: Icons.notifications_outlined,
          label: l10n.documentReminderLabel,
          value: reminder.enabled && reminder.daysBefore.isNotEmpty
              ? l10n.documentReminderDaysBefore(
                  reminder.daysBefore.map((days) => '$days').join(', '),
                )
              : l10n.documentReminderOff,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<DocumentDetailViewModel>(
        builder: (context, viewModel, child) {
          final document = viewModel.document;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) Navigator.of(context).pop(viewModel.changed);
            },
            child: AppScaffold(
              appBar: AppBar(
                title: Text(l10n.documentDetailsTitle),
                backgroundColor: Colors.black.withValues(alpha: 0.78),
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  if (document != null) ...[
                    IconButton(
                      tooltip: l10n.documentEditTitle,
                      onPressed: () => _edit(document),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: l10n.deleteDocument,
                      onPressed: viewModel.isDeleting ? null : _delete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ],
              ),
              body: document == null
                  ? (viewModel.isLoading || viewModel.errorMessage == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ErrorState(
                            message: l10n.loadDocumentError,
                            onRetry: viewModel.load,
                          ))
                  : RefreshIndicator(
                      onRefresh: viewModel.load,
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                        children: [
                          DocumentDetailsHeader(document: document),
                          const SizedBox(height: 28),
                          MarinaSectionTitle(
                            title: l10n.documentDetailsInfoSection,
                          ),
                          DetailsSectionCard(
                            rows: _detailRows(l10n, locale, document),
                          ),
                          if (document.attachments.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            MarinaSectionTitle(
                              title: l10n.documentAttachmentsSection,
                            ),
                            DocumentAttachmentsGallery(
                              attachments: document.attachments,
                              onOpen: _openAttachment,
                            ),
                          ],
                          if (_text(document.notes) case final notes?) ...[
                            const SizedBox(height: 28),
                            MarinaSectionTitle(
                              title: l10n.documentNotesSection,
                            ),
                            DetailsSectionCard(
                              rows: [
                                SummaryRow(
                                  icon: Icons.sticky_note_2_outlined,
                                  label: l10n.documentNotesSection,
                                  value: notes,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
