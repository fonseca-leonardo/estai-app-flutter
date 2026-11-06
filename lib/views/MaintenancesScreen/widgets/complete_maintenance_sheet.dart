import '../../../widgets/ui/app_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/maintenance.dart';
import '../../../utils/engine_hours_format.dart';
import '../../../widgets/dark_date_picker.dart';
import '../../../widgets/dark_input_decoration.dart';

/// O que o usuário informou ao concluir a manutenção.
class CompleteMaintenanceFormResult {
  final DateTime completedAt;
  final double? engineHours;
  final double? cost;
  final String? notes;

  CompleteMaintenanceFormResult({
    required this.completedAt,
    this.engineHours,
    this.cost,
    this.notes,
  });
}

Future<CompleteMaintenanceFormResult?> showCompleteMaintenanceSheet({
  required BuildContext context,
  required Maintenance maintenance,
  double? currentEngineHours,
}) {
  return AppSheet.show<CompleteMaintenanceFormResult>(
    context,
    padded: false,
    useSafeArea: false,
    builder: (_) => CompleteMaintenanceSheet(
      maintenance: maintenance,
      currentEngineHours: currentEngineHours,
    ),
  );
}

class CompleteMaintenanceSheet extends StatefulWidget {
  final Maintenance maintenance;
  final double? currentEngineHours;

  const CompleteMaintenanceSheet({
    super.key,
    required this.maintenance,
    this.currentEngineHours,
  });

  @override
  State<CompleteMaintenanceSheet> createState() =>
      _CompleteMaintenanceSheetState();
}

class _CompleteMaintenanceSheetState extends State<CompleteMaintenanceSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hoursController;
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _completedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    final hours = widget.currentEngineHours;
    _hoursController = TextEditingController(
      text: hours != null ? EngineHoursFormat.toInput(hours) : '',
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateOptionalNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = EngineHoursFormat.parse(value);
    if (parsed == null || parsed < 0) {
      return AppLocalizations.of(context)!.invalidNumber;
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDarkDatePicker(
      context: context,
      initialDate: _completedAt,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _completedAt = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final notes = _notesController.text.trim();
    Navigator.of(context).pop(
      CompleteMaintenanceFormResult(
        completedAt: _completedAt,
        engineHours: EngineHoursFormat.parse(_hoursController.text),
        cost: EngineHoursFormat.parse(_costController.text),
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.completeMaintenanceTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.maintenance.title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: darkInputDecoration(
                      l10n.completeMaintenanceDate,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat.yMMMd(locale).format(_completedAt),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hoursController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: darkInputDecoration(
                    l10n.completeMaintenanceEngineHours,
                    suffixText: 'h',
                  ),
                  validator: _validateOptionalNumber,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _costController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: darkInputDecoration(l10n.completeMaintenanceCost),
                  validator: _validateOptionalNumber,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  maxLength: 1000,
                  style: const TextStyle(color: Colors.white),
                  decoration: darkInputDecoration(l10n.notesOptional),
                ),
                if (widget.maintenance.isRecurring) ...[
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.repeat,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.completeMaintenanceRecurringHint,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.maintenanceComplete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
