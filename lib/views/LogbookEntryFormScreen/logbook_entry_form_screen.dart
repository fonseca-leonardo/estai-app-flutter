import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/logbook_entry.dart';
import '../../viewmodels/logbook_entry_form_viewmodel.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/dark_date_picker.dart';
import '../../widgets/dark_input_decoration.dart';
import '../MarinaHomeScreen/widgets/marina_section_title.dart';
import '../NotificationSettingsScreen/widgets/notification_toggle_tile.dart';
import 'widgets/logbook_date_time_fields.dart';
import 'widgets/logbook_type_selector.dart';

/// Cria ou edita uma entrada do diário de bordo. Volta a [LogbookEntry]
/// salva. Numa viagem só título e observações são editáveis.
class LogbookEntryFormScreen extends StatefulWidget {
  final String boatId;
  final LogbookEntry? entry;

  const LogbookEntryFormScreen({super.key, required this.boatId, this.entry});

  @override
  State<LogbookEntryFormScreen> createState() => _LogbookEntryFormScreenState();
}

class _LogbookEntryFormScreenState extends State<LogbookEntryFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'LogbookEntryFormScreen';

  final _formKey = GlobalKey<FormState>();
  late final LogbookEntryFormViewModel _viewModel;
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _viewModel = LogbookEntryFormViewModel(
      boatId: widget.boatId,
      initial: widget.entry,
    );
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final current = _viewModel.occurredAt;
    final picked = await showDarkDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(current.year - 30),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    _viewModel.setOccurredAt(
      DateTime(
        picked.year,
        picked.month,
        picked.day,
        current.hour,
        current.minute,
      ),
    );
  }

  Future<void> _pickTime() async {
    final current = _viewModel.occurredAt;
    final picked = await showDarkTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null) return;
    _viewModel.setOccurredAt(
      DateTime(
        current.year,
        current.month,
        current.day,
        picked.hour,
        picked.minute,
      ),
    );
  }

  void _togglePosition(bool value) {
    if (!value) {
      _viewModel.setPosition(null);
      return;
    }
    final position = context.read<MapViewModel>().currentPosition;
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.logbookPositionUnavailable,
          ),
        ),
      );
      return;
    }
    _viewModel.setPosition(LatLng(position.latitude, position.longitude));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final notes = _notesController.text.trim();

    final saved = await _viewModel.save(
      title: _titleController.text.trim(),
      notes: notes.isEmpty ? null : notes,
    );
    if (saved == null || !mounted) return;

    messenger.showSnackBar(SnackBar(content: Text(l10n.logbookSaved)));
    navigator.pop(saved);
  }

  String? _errorText(AppLocalizations l10n, LogbookEntryFormError? error) {
    switch (error) {
      case LogbookEntryFormError.invalid:
        return l10n.logbookInvalidError;
      case LogbookEntryFormError.unknown:
        return l10n.saveLogbookEntryError;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<LogbookEntryFormViewModel>(
        builder: (context, viewModel, child) {
          final errorText = _errorText(l10n, viewModel.error);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                viewModel.isEditing
                    ? l10n.logbookEditEntry
                    : l10n.logbookNewEntry,
              ),
              backgroundColor: Colors.black.withValues(alpha: 0.78),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Colors.black,
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
                          if (!viewModel.isTrip) ...[
                            MarinaSectionTitle(title: l10n.logbookTypeLabel),
                            LogbookTypeSelector(
                              selected: viewModel.type,
                              onChanged: viewModel.setType,
                            ),
                            const SizedBox(height: 28),
                          ],
                          TextFormField(
                            controller: _titleController,
                            maxLength: 120,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(
                              l10n.logbookTitleLabel,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? l10n.logbookTitleRequired
                                : null,
                          ),
                          if (!viewModel.isTrip) ...[
                            const SizedBox(height: 12),
                            LogbookDateTimeFields(
                              value: viewModel.occurredAt,
                              onPickDate: _pickDate,
                              onPickTime: _pickTime,
                            ),
                            const SizedBox(height: 16),
                            NotificationToggleTile(
                              icon: Icons.my_location,
                              title: l10n.logbookUseCurrentPosition,
                              subtitle: l10n.logbookUseCurrentPositionSubtitle,
                              value: viewModel.position != null,
                              onChanged: _togglePosition,
                            ),
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 5,
                            maxLength: 2000,
                            style: const TextStyle(color: Colors.white),
                            decoration: darkInputDecoration(l10n.notesOptional),
                          ),
                          if (errorText != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              errorText,
                              style: TextStyle(color: AppColors.danger),
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
                            : Text(l10n.logbookSave),
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
