import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat_document.dart';
import '../../viewmodels/documents_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/empty_state.dart';
import '../../widgets/ui/section_label.dart';
import '../../widgets/ui/skeleton_list.dart';
import '../DocumentDetailScreen/document_detail_screen.dart';
import '../DocumentFormScreen/document_form_screen.dart';
import 'widgets/document_card.dart';

/// Documentos do barco ([boatId]) ou, sem barco, os pessoais ("Meus
/// documentos"). Os que pedem atenção (vencidos e vencendo) vêm primeiro.
class DocumentsScreen extends StatefulWidget {
  final String? boatId;
  final String? boatName;

  const DocumentsScreen({super.key, this.boatId, this.boatName});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'DocumentsScreen';

  late final DocumentsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DocumentsViewModel(boatId: widget.boatId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _viewModel.load());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openNew() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DocumentFormScreen(boatId: widget.boatId),
      ),
    );
    if (saved == true) _viewModel.load();
  }

  Future<void> _openDocument(BoatDocument document) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            DocumentDetailScreen(documentId: document.id, initial: document),
      ),
    );
    if (changed == true) _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.boatId == null
        ? l10n.myDocumentsTitle
        : l10n.documentsTitle;

    return AppScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (widget.boatName != null)
              Text(
                widget.boatName!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.78),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNew,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: Text(l10n.documentNew),
      ),
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<DocumentsViewModel>(
          builder: (context, viewModel, child) {
            final documents = viewModel.documents;

            if (viewModel.isLoading && documents.isEmpty) {
              return const SkeletonList(count: 4, itemHeight: 96);
            }

            final attention = viewModel.needingAttention;
            final others = viewModel.others;
            final String? message = documents.isEmpty
                ? (viewModel.errorMessage != null
                      ? l10n.loadDocumentsError
                      : (viewModel.isPersonal
                            ? l10n.noPersonalDocuments
                            : l10n.noBoatDocuments))
                : null;

            return RefreshIndicator(
              onRefresh: viewModel.load,
              color: Colors.black,
              backgroundColor: Colors.white,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  if (message != null) ...[
                    const SizedBox(height: 48),
                    EmptyState(
                      icon: viewModel.errorMessage != null
                          ? Icons.cloud_off_outlined
                          : Icons.folder_open_outlined,
                      message: message,
                      bordered: false,
                    ),
                  ],
                  if (attention.isNotEmpty) ...[
                    SectionLabel(l10n.documentsAttentionSection),
                    for (final document in attention)
                      DocumentCard(
                        document: document,
                        onTap: () => _openDocument(document),
                      ),
                    const SizedBox(height: 12),
                  ],
                  if (others.isNotEmpty) ...[
                    if (attention.isNotEmpty)
                      SectionLabel(l10n.documentsOthersSection),
                    for (final document in others)
                      DocumentCard(
                        document: document,
                        onTap: () => _openDocument(document),
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
