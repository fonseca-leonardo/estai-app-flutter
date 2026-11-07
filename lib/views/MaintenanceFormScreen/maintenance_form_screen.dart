import '../../widgets/ui/app_scaffold.dart';
import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/maintenance.dart';
import '../../services/push_notification_service.dart';
import '../../utils/engine_hours_format.dart';
import '../../viewmodels/maintenance_form_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/dark_date_picker.dart';
import '../../widgets/dark_input_decoration.dart';
import '../../widgets/reminder_settings_card.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import '../NotificationSettingsScreen/widgets/notification_toggle_tile.dart';
import 'widgets/delete_maintenance_dialog.dart';
import 'widgets/maintenance_category_selector.dart';
import 'widgets/maintenance_completion_card.dart';
import 'widgets/maintenance_due_card.dart';
import 'widgets/maintenance_recurrence_card.dart';

/// Cria ou edita uma manutenção. Volta `true` quando algo foi salvo ou
/// excluído.
class MaintenanceFormScreen extends StatefulWidget {
  final String boatId;
  final Maintenance? maintenance;
  final double? currentEngineHours;

  const MaintenanceFormScreen({
    super.key,
    required this.boatId,
    this.maintenance,
    this.currentEngineHours,
  });

  @override
  State<MaintenanceFormScreen> createState() => _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MaintenanceFormScreen';

  final _formKey = GlobalKey<FormState>();
  late final MaintenanceFormViewModel _viewModel;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueHoursController;
  late final TextEditingController _recurrenceMonthsController;
  late final TextEditingController _recurrenceHoursController;
  late final TextEditingController _providerController;
  late final TextEditingController _completedHoursController;
  late final TextEditingController _costController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final initial = widget.maintenance;
    _viewModel = MaintenanceFormViewModel(
      boatId: widget.boatId,
      initial: initial,
    );
    _titleController = TextEditingController(text: initial?.title ?? '');
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _dueHoursController = TextEditingController(
      text: initial?.dueEngineHours != null
          ? EngineHoursFormat.toInput(initial!.dueEngineHours!)
          : '',
    );
    _recurrenceMonthsController = TextEditingController(
      text: initial?.recurrenceMonths?.toString() ?? '',
    );
    _recurrenceHoursController = TextEditingController(
      text: initial?.recurrenceHours != null
          ? EngineHoursFormat.toInput(initial!.recurrenceHours!)
          : '',
    );
    _providerController = TextEditingController(text: initial?.provider ?? '');
    _completedHoursController = TextEditingController();
    _costController = TextEditingController();
    _notesController = TextEditingController();
    // Já realizada: a antecedência por horímetro depende da repetição por
    // horas, então o card de lembrete acompanha o que é digitado.
    _recurrenceHoursController.addListener(_onRecurrenceHoursChanged);
  }

  void _onRecurrenceHoursChanged() {
    if (_viewModel.isCompleted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dueHoursController.dispose();
    _recurrenceMonthsController.dispose();
    _recurrenceHoursController
      ..removeListener(_onRecurrenceHoursChanged)
      ..dispose();
    _providerController.dispose();
    _completedHoursController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _optionalText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDarkDatePicker(
      context: context,
      initialDate: _viewModel.dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) _viewModel.setDueDate(picked);
  }

  Future<void> _pickCompletedAt() async {
    final now = DateTime.now();
    final picked = await showDarkDatePicker(
      context: context,
      initialDate: _viewModel.completedAt,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked != null) _viewModel.setCompletedAt(picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final success = await _viewModel.save(
      title: _titleController.text.trim(),
      description: _optionalText(_descriptionController),
      dueEngineHours: EngineHoursFormat.parse(_dueHoursController.text),
      recurrenceMonths: int.tryParse(_recurrenceMonthsController.text.trim()),
      recurrenceHours: EngineHoursFormat.parse(_recurrenceHoursController.text),
      provider: _optionalText(_providerController),
      completedEngineHours: EngineHoursFormat.parse(
        _completedHoursController.text,
      ),
      cost: EngineHoursFormat.parse(_costController.text),
      notes: _optionalText(_notesController),
    );
    if (!success || !mounted) return;

    // O lembrete por push só chega se o aparelho estiver registrado; pede a
    // permissão aqui, no momento em que o usuário configurou um.
    if (_viewModel.showsReminder && _viewModel.reminder.usesPush) {
      await PushNotificationService.instance.requestPermissionIfNeeded(context);
    }

    messenger.showSnackBar(SnackBar(content: Text(l10n.maintenanceSaved)));
    navigator.pop(true);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDeleteMaintenanceDialog(context);
    if (!confirmed) return;

    final success = await _viewModel.delete();
    if (!mounted) return;
    if (success) {
      navigator.pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteMaintenanceError)),
      );
    }
  }

  String? _errorText(AppLocalizations l10n, MaintenanceFormError? error) {
    switch (error) {
      case MaintenanceFormError.invalid:
        return l10n.maintenanceInvalidError;
      case MaintenanceFormError.unknown:
        return l10n.saveMaintenanceError;
      case MaintenanceFormError.missingDue:
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<MaintenanceFormViewModel>(
        builder: (context, viewModel, child) {
          final errorText = _errorText(l10n, viewModel.error);

          return AppScaffold(
            appBar: AppBar(
              title: Text(
                viewModel.isEditing
                    ? l10n.maintenanceEditTitle
                    : l10n.maintenanceNew,
              ),
              backgroundColor: Colors.black.withValues(alpha: 0.78),
              foregroundColor: Colors.white,
              elevation: 0,
              actions: [
                if (viewModel.isEditing)
                  IconButton(
                    tooltip: l10n.deleteMaintenance,
                    onPressed: viewModel.isDeleting ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              l10n.maintenanceTitleLabel,
                              hint: l10n.maintenanceTitleHint,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? l10n.maintenanceTitleRequired
                                : null,
                          ),
                          const SizedBox(height: 12),
                          MarinaSectionTitle(
                            title: l10n.maintenanceCategoryLabel,
                          ),
                          MaintenanceCategorySelector(
                            selected: viewModel.category,
                            onChanged: viewModel.setCategory,
                          ),
                          const SizedBox(height: 28),
                          if (viewModel.canToggleCompleted)
                            NotificationToggleTile(
                              icon: Icons.task_alt,
                              title: l10n.maintenanceAlreadyDone,
                              subtitle: l10n.maintenanceAlreadyDoneSubtitle,
                              value: viewModel.isCompleted,
                              onChanged: viewModel.setCompleted,
                            ),
                          if (viewModel.isCompleted) ...[
                            const SizedBox(height: 16),
                            MarinaSectionTitle(
                              title: l10n.maintenanceCompletionSection,
                            ),
                            MaintenanceCompletionCard(
                              completedAt: viewModel.completedAt,
                              engineHoursController: _completedHoursController,
                              costController: _costController,
                              notesController: _notesController,
                              onPickDate: _pickCompletedAt,
                            ),
                          ] else ...[
                            const SizedBox(height: 16),
                            MarinaSectionTitle(
                              title: l10n.maintenanceDueSection,
                            ),
                            MaintenanceDueCard(
                              dueDate: viewModel.dueDate,
                              dueHoursController: _dueHoursController,
                              currentEngineHours: widget.currentEngineHours,
                              showMissingDueError:
                                  viewModel.error ==
                                  MaintenanceFormError.missingDue,
                              onPickDate: _pickDueDate,
                              onClearDate: () => viewModel.setDueDate(null),
                              onDueHoursChanged: (_) {
                                viewModel.onDueEngineHoursChanged();
                                // Mostra/esconde a antecedência por horímetro.
                                setState(() {});
                              },
                            ),
                          ],
                          const SizedBox(height: 12),
                          MaintenanceRecurrenceCard(
                            enabled: viewModel.isRecurring,
                            monthsController: _recurrenceMonthsController,
                            hoursController: _recurrenceHoursController,
                            onEnabledChanged: viewModel.setRecurring,
                            fromCompletion: viewModel.isCompleted,
                          ),
                          if (viewModel.showsReminder) ...[
                            const SizedBox(height: 12),
                            ReminderSettingsCard(
                              reminder: viewModel.reminder,
                              // Já realizada e recorrente: a próxima vence
                              // por horas se a repetição for por horas.
                              showHoursBefore: viewModel.isCompleted
                                  ? _recurrenceHoursController.text
                                        .trim()
                                        .isNotEmpty
                                  : _dueHoursController.text.trim().isNotEmpty,
                              onEnabledChanged: viewModel.setReminderEnabled,
                              onDayToggled: viewModel.toggleReminderDay,
                              onHoursChanged: viewModel.setReminderHours,
                              onChannelToggled: viewModel.toggleReminderChannel,
                            ),
                          ],
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            maxLength: 1000,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.maintenanceDescriptionLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _providerController,
                            maxLength: 120,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.maintenanceProviderLabel,
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
                            : Text(l10n.maintenanceSave),
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
