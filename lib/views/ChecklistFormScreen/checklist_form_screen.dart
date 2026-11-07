import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/checklist.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/checklist_form_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/dark_input_decoration.dart';
import '../../widgets/ui/app_scaffold.dart';
import '../../widgets/ui/glass_bar_background.dart';
import '../../widgets/ui/glass_card.dart';
import '../../widgets/ui/section_label.dart';
import 'widgets/checklist_items_editor.dart';
import 'widgets/checklist_trigger_selector.dart';
import 'widgets/delete_checklist_dialog.dart';

/// Cria ou edita um checklist. Volta `true` quando salvou ou excluiu.
class ChecklistFormScreen extends StatefulWidget {
  final Checklist? checklist;

  const ChecklistFormScreen({super.key, this.checklist});

  @override
  State<ChecklistFormScreen> createState() => _ChecklistFormScreenState();
}

class _ChecklistFormScreenState extends State<ChecklistFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ChecklistFormScreen';

  late final ChecklistFormViewModel _viewModel;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _viewModel = ChecklistFormViewModel(initial: widget.checklist);
    _nameController = TextEditingController(text: widget.checklist?.name ?? '');
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// Fecha o teclado antes de diálogos e de salvar, para ele não voltar
  /// quando o foco é devolvido ao campo.
  void _dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  Future<void> _save() async {
    _dismissKeyboard();
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final success = await _viewModel.save(name: _nameController.text);
    if (!success || !mounted) return;

    messenger.showSnackBar(SnackBar(content: Text(l10n.checklistSaved)));
    navigator.pop(true);
  }

  Future<void> _delete() async {
    _dismissKeyboard();
    final navigator = Navigator.of(context);
    final confirmed = await showDeleteChecklistDialog(context);
    if (!confirmed || !mounted) return;
    if (await _viewModel.delete()) navigator.pop(true);
  }

  String? _errorText(AppLocalizations l10n, ChecklistFormError? error) {
    switch (error) {
      case ChecklistFormError.noItems:
        return l10n.checklistNoItemsError;
      case ChecklistFormError.unknown:
        return l10n.checklistSaveError;
      case ChecklistFormError.missingName:
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ChecklistFormViewModel>(
        builder: (context, viewModel, child) {
          final errorText = _errorText(l10n, viewModel.error);

          return AppScaffold(
            appBar: AppBar(
              title: Text(
                viewModel.isEditing ? l10n.checklistEdit : l10n.checklistNew,
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              flexibleSpace: const GlassBarBackground(),
              actions: [
                if (viewModel.isEditing)
                  IconButton(
                    tooltip: l10n.checklistDelete,
                    onPressed: _delete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.danger,
                    ),
                  ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GlassCard(
                          child: TextField(
                            controller: _nameController,
                            maxLength: Checklist.maxNameLength,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.white),
                            decoration:
                                darkInputDecoration(
                                  l10n.checklistNameLabel,
                                  hint: l10n.checklistNameHint,
                                ).copyWith(
                                  errorText:
                                      viewModel.error ==
                                          ChecklistFormError.missingName
                                      ? l10n.checklistNameRequired
                                      : null,
                                ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SectionLabel(l10n.checklistTriggerLabel),
                        GlassCard(
                          child: ChecklistTriggerSelector(
                            selected: viewModel.trigger,
                            onChanged: viewModel.setTrigger,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SectionLabel(l10n.checklistItemsSection),
                        GlassCard(
                          padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                          child: ChecklistItemsEditor(
                            items: viewModel.items,
                            focusedItemId: viewModel.lastAddedId,
                            canAdd: viewModel.canAddItem,
                            onAdd: viewModel.addItem,
                            onChanged: viewModel.updateItem,
                            onRemove: viewModel.removeItem,
                            onReorder: viewModel.reorder,
                          ),
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
                GlassBarBackground(
                  edge: AxisDirection.up,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: viewModel.isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(l10n.checklistSave),
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
