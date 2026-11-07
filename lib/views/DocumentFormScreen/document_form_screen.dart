import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat_document.dart';
import '../../services/attachment_picker_service.dart';
import '../../services/push_notification_service.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/document_form_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/dark_date_picker.dart';
import '../../widgets/dark_input_decoration.dart';
import '../../widgets/reminder_settings_card.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import 'widgets/attachment_source_sheet.dart';
import 'widgets/document_attachments_field.dart';
import 'widgets/document_dates_card.dart';
import 'widgets/document_type_selector.dart';

/// Cria ou edita um documento do barco ([boatId]) ou pessoal (sem barco).
/// Volta `true` quando algo foi salvo.
class DocumentFormScreen extends StatefulWidget {
  final String? boatId;
  final BoatDocument? document;

  const DocumentFormScreen({super.key, this.boatId, this.document});

  @override
  State<DocumentFormScreen> createState() => _DocumentFormScreenState();
}

class _DocumentFormScreenState extends State<DocumentFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'DocumentFormScreen';

  final _formKey = GlobalKey<FormState>();
  final _picker = AttachmentPickerService();
  late final DocumentFormViewModel _viewModel;
  late final TextEditingController _titleController;
  late final TextEditingController _numberController;
  late final TextEditingController _issuerController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final initial = widget.document;
    _viewModel = DocumentFormViewModel(
      boatId: initial?.boatId ?? widget.boatId,
      initial: initial,
    );
    _titleController = TextEditingController(text: initial?.title ?? '');
    _numberController = TextEditingController(text: initial?.number ?? '');
    _issuerController = TextEditingController(text: initial?.issuer ?? '');
    _notesController = TextEditingController(text: initial?.notes ?? '');
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _titleController.dispose();
    _numberController.dispose();
    _issuerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _optionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  /// Fecha o teclado antes de abrir seletores ou salvar. Sem isso, a rota
  /// do seletor devolve o foco ao campo de texto quando fecha e o teclado
  /// volta a abrir.
  void _dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  Future<DateTime?> _pickDate(DateTime? current) {
    _dismissKeyboard();
    final now = DateTime.now();
    return showDarkDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 30),
    );
  }

  Future<void> _pickIssuedAt() async {
    final picked = await _pickDate(_viewModel.issuedAt);
    if (picked != null) _viewModel.setIssuedAt(picked);
  }

  Future<void> _pickExpiresAt() async {
    final picked = await _pickDate(_viewModel.expiresAt);
    if (picked != null) _viewModel.setExpiresAt(picked);
  }

  Future<void> _addAttachment() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    _dismissKeyboard();
    final source = await showAttachmentSourceSheet(context);
    if (source == null) return;

    final files = await _picker.pick(source);
    final rejected = <AttachmentAddResult>{};
    for (final file in files) {
      final result = _viewModel.addFile(file);
      if (result != AttachmentAddResult.added) rejected.add(result);
    }
    if (rejected.isEmpty || !mounted) return;

    final message = rejected.contains(AttachmentAddResult.limitReached)
        ? l10n.attachmentLimitReached
        : rejected.contains(AttachmentAddResult.tooLarge)
        ? l10n.attachmentTooLarge
        : l10n.attachmentUnsupported;
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    _dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final success = await _viewModel.save(
      title: _optionalText(_titleController),
      number: _optionalText(_numberController),
      issuer: _optionalText(_issuerController),
      notes: _optionalText(_notesController),
    );
    if (!success || !mounted) return;

    // O aviso por push só chega se o aparelho estiver registrado; pede a
    // permissão aqui, no momento em que o usuário configurou um.
    if (_viewModel.showsReminder && _viewModel.reminder.usesPush) {
      await PushNotificationService.instance.requestPermissionIfNeeded(context);
    }

    messenger.showSnackBar(SnackBar(content: Text(l10n.documentSaved)));
    navigator.pop(true);
  }

  String? _errorText(AppLocalizations l10n, DocumentFormError? error) {
    switch (error) {
      case DocumentFormError.invalid:
        return l10n.documentInvalidError;
      case DocumentFormError.unknown:
        return l10n.saveDocumentError;
      case DocumentFormError.attachmentsFailed:
        return l10n.documentAttachmentsFailed;
      case DocumentFormError.invalidDates:
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<DocumentFormViewModel>(
        builder: (context, viewModel, child) {
          final errorText = _errorText(l10n, viewModel.error);
          final retryingAttachments =
              viewModel.error == DocumentFormError.attachmentsFailed;

          return AppScaffold(
            appBar: AppBar(
              title: Text(
                viewModel.isEditing ? l10n.documentEditTitle : l10n.documentNew,
              ),
              backgroundColor: Colors.black.withValues(alpha: 0.78),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MarinaSectionTitle(title: l10n.documentTypeLabel),
                          DocumentTypeSelector(
                            types: viewModel.availableTypes,
                            selected: viewModel.type,
                            onChanged: viewModel.setType,
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _titleController,
                            maxLength: 120,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.documentTitleLabel,
                              hint: viewModel.type.label(l10n),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _numberController,
                            maxLength: 60,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.documentNumberLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _issuerController,
                            maxLength: 120,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.documentIssuerLabel,
                              hint: l10n.documentIssuerHint,
                            ),
                          ),
                          const SizedBox(height: 16),
                          MarinaSectionTitle(title: l10n.documentDatesSection),
                          DocumentDatesCard(
                            issuedAt: viewModel.issuedAt,
                            expiresAt: viewModel.expiresAt,
                            showInvalidDatesError:
                                viewModel.error ==
                                DocumentFormError.invalidDates,
                            onPickIssuedAt: _pickIssuedAt,
                            onClearIssuedAt: () => viewModel.setIssuedAt(null),
                            onPickExpiresAt: _pickExpiresAt,
                            onClearExpiresAt: () =>
                                viewModel.setExpiresAt(null),
                          ),
                          if (viewModel.showsReminder) ...[
                            const SizedBox(height: 12),
                            ReminderSettingsCard(
                              reminder: viewModel.reminder,
                              showHoursBefore: false,
                              onEnabledChanged: viewModel.setReminderEnabled,
                              onDayToggled: viewModel.toggleReminderDay,
                              onHoursChanged: (_) {},
                              onChannelToggled: viewModel.toggleReminderChannel,
                            ),
                          ],
                          const SizedBox(height: 28),
                          MarinaSectionTitle(
                            title: l10n.documentAttachmentsSection,
                          ),
                          DocumentAttachmentsField(
                            attachments: viewModel.attachments,
                            pendingFiles: viewModel.pendingFiles,
                            canAdd: viewModel.canAddAttachment,
                            onAdd: _addAttachment,
                            onRemoveAttachment: viewModel.removeAttachment,
                            onRemovePending: viewModel.removePendingFile,
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 4,
                            maxLength: 1000,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(l10n.notesOptional),
                          ),
                          if (errorText != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              errorText,
                              style: const TextStyle(color: AppColors.danger),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.isSubmitting ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          disabledForegroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: viewModel.isUploading
                            ? Text(
                                l10n.attachmentUploadingProgress(
                                  viewModel.uploadIndex,
                                  viewModel.uploadTotal,
                                ),
                              )
                            : viewModel.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                retryingAttachments
                                    ? l10n.tryAgain
                                    : l10n.documentSave,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
