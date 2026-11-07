import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat_reminder.dart';
import '../../services/push_notification_service.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/boat_reminder_form_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/dark_date_picker.dart';
import '../../widgets/dark_input_decoration.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/reminder_settings_card.dart';
import '../../widgets/ui/app_scaffold.dart';
import 'widgets/boat_reminder_recurrence_card.dart';
import 'widgets/delete_boat_reminder_dialog.dart';

/// Cria ou edita um lembrete avulso. Volta `true` quando algo foi salvo ou
/// excluído.
class BoatReminderFormScreen extends StatefulWidget {
  final String boatId;
  final BoatReminder? reminder;

  const BoatReminderFormScreen({
    super.key,
    required this.boatId,
    this.reminder,
  });

  @override
  State<BoatReminderFormScreen> createState() => _BoatReminderFormScreenState();
}

class _BoatReminderFormScreenState extends State<BoatReminderFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'BoatReminderFormScreen';

  final _formKey = GlobalKey<FormState>();
  late final BoatReminderFormViewModel _viewModel;
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late final TextEditingController _monthsController;

  @override
  void initState() {
    super.initState();
    final initial = widget.reminder;
    _viewModel = BoatReminderFormViewModel(
      boatId: widget.boatId,
      initial: initial,
    );
    _titleController = TextEditingController(text: initial?.title ?? '');
    _notesController = TextEditingController(text: initial?.notes ?? '');
    _monthsController = TextEditingController(
      text: initial?.recurrenceMonths?.toString() ?? '12',
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _titleController.dispose();
    _notesController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  /// Fecha o teclado antes de abrir o seletor ou salvar, para ele não
  /// voltar quando o foco é devolvido ao campo de texto.
  void _dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  Future<void> _pickDate() async {
    _dismissKeyboard();
    final now = DateTime.now();
    final picked = await showDarkDatePicker(
      context: context,
      initialDate: _viewModel.dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) _viewModel.setDueDate(picked);
  }

  Future<void> _save() async {
    _dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final notes = _notesController.text.trim();

    final success = await _viewModel.save(
      title: _titleController.text.trim(),
      notes: notes.isEmpty ? null : notes,
      recurrenceMonths: int.tryParse(_monthsController.text.trim()),
    );
    if (!success || !mounted) return;

    // O aviso por push só chega se o aparelho estiver registrado; pede a
    // permissão aqui, no momento em que o usuário configurou um.
    if (_viewModel.reminder.usesPush) {
      await PushNotificationService.instance.requestPermissionIfNeeded(context);
    }

    messenger.showSnackBar(SnackBar(content: Text(l10n.boatReminderSaved)));
    navigator.pop(true);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDeleteBoatReminderDialog(context);
    if (!confirmed) return;

    final success = await _viewModel.delete();
    if (!mounted) return;
    if (success) {
      navigator.pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteBoatReminderError)),
      );
    }
  }

  String? _errorText(AppLocalizations l10n, BoatReminderFormError? error) {
    switch (error) {
      case BoatReminderFormError.invalid:
        return l10n.boatReminderInvalidError;
      case BoatReminderFormError.unknown:
        return l10n.saveBoatReminderError;
      case BoatReminderFormError.missingDate:
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<BoatReminderFormViewModel>(
        builder: (context, viewModel, child) {
          final errorText = _errorText(l10n, viewModel.error);

          return AppScaffold(
            appBar: AppBar(
              title: Text(
                viewModel.isEditing
                    ? l10n.boatReminderEditTitle
                    : l10n.boatReminderNew,
              ),
              backgroundColor: Colors.black.withValues(alpha: 0.78),
              foregroundColor: Colors.white,
              elevation: 0,
              actions: [
                if (viewModel.isEditing)
                  IconButton(
                    tooltip: l10n.deleteBoatReminder,
                    onPressed: viewModel.isDeleting ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
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
                          TextFormField(
                            controller: _titleController,
                            maxLength: 120,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.boatReminderTitleLabel,
                              hint: l10n.boatReminderTitleHint,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? l10n.boatReminderTitleRequired
                                : null,
                          ),
                          const SizedBox(height: 12),
                          DatePickerField(
                            label: l10n.boatReminderDateLabel,
                            value: viewModel.dueDate,
                            placeholder: l10n.boatReminderDatePlaceholder,
                            onTap: _pickDate,
                            errorText:
                                viewModel.error ==
                                    BoatReminderFormError.missingDate
                                ? l10n.boatReminderDateRequired
                                : null,
                          ),
                          const SizedBox(height: 24),
                          BoatReminderRecurrenceCard(
                            enabled: viewModel.isRecurring,
                            monthsController: _monthsController,
                            onEnabledChanged: viewModel.setRecurring,
                          ),
                          const SizedBox(height: 12),
                          ReminderSettingsCard(
                            reminder: viewModel.reminder,
                            showHoursBefore: false,
                            onEnabledChanged: viewModel.setReminderEnabled,
                            onDayToggled: viewModel.toggleReminderDay,
                            onHoursChanged: (_) {},
                            onChannelToggled: viewModel.toggleReminderChannel,
                          ),
                          const SizedBox(height: 24),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: viewModel.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(l10n.boatReminderSave),
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
