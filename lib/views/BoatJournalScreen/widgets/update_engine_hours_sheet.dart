import '../../../widgets/ui/app_sheet.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/engine_hours_format.dart';
import '../../../widgets/dark_input_decoration.dart';

/// Nova leitura do horímetro digitada pelo usuário, ou `null` se desistiu.
Future<double?> showUpdateEngineHoursSheet({
  required BuildContext context,
  double? currentEngineHours,
}) {
  return AppSheet.show<double>(
    context,
    padded: false,
    useSafeArea: false,
    builder: (_) =>
        UpdateEngineHoursSheet(currentEngineHours: currentEngineHours),
  );
}

class UpdateEngineHoursSheet extends StatefulWidget {
  final double? currentEngineHours;

  const UpdateEngineHoursSheet({super.key, this.currentEngineHours});

  @override
  State<UpdateEngineHoursSheet> createState() => _UpdateEngineHoursSheetState();
}

class _UpdateEngineHoursSheetState extends State<UpdateEngineHoursSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final current = widget.currentEngineHours;
    _controller = TextEditingController(
      text: current != null ? EngineHoursFormat.toInput(current) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final parsed = EngineHoursFormat.parse(value ?? '');
    if (parsed == null || parsed < 0) return l10n.invalidNumber;
    final current = widget.currentEngineHours;
    // O horímetro só anda para frente.
    if (current != null && parsed < current) {
      return l10n.engineHoursLowerThanCurrent(
        EngineHoursFormat.format(current, locale),
      );
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(EngineHoursFormat.parse(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.engineHoursSheetTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.engineHoursSheetHint,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: darkInputDecoration(
                    l10n.engineHoursFieldLabel,
                    suffixText: 'h',
                  ),
                  validator: _validate,
                  onFieldSubmitted: (_) => _submit(),
                ),
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
                  child: Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
