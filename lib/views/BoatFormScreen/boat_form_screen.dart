import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat_type.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import 'widgets/boat_type_dropdown.dart';

class BoatFormScreen extends StatefulWidget {
  const BoatFormScreen({super.key});

  @override
  State<BoatFormScreen> createState() => _BoatFormScreenState();
}

class _BoatFormScreenState extends State<BoatFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'BoatFormScreen';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _lengthController = TextEditingController();
  BoatType _selectedType = BoatType.boat;

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(AppLocalizations l10n, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    context.read<BoatViewModel>().addBoat(
      name: _nameController.text.trim(),
      model: _modelController.text.trim(),
      type: _selectedType,
      year: int.parse(_yearController.text.trim()),
      length: double.parse(_lengthController.text.trim().replaceAll(',', '.')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addBoat),
        backgroundColor: Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration(l10n, l10n.boatName),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterBoatName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration(l10n, l10n.boatModel),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterBoatModel;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                BoatTypeDropdown(
                  value: _selectedType,
                  decoration: _decoration(l10n, l10n.boatType),
                  onChanged: (type) => setState(() => _selectedType = type),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration(l10n, l10n.boatYear),
                  validator: (value) {
                    final year = int.tryParse(value?.trim() ?? '');
                    if (year == null || year < 1900 || year > currentYear + 1) {
                      return l10n.pleaseEnterValidYear;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lengthController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration(l10n, l10n.boatLength),
                  validator: (value) {
                    final length = double.tryParse(
                      value?.trim().replaceAll(',', '.') ?? '',
                    );
                    if (length == null || length <= 0) {
                      return l10n.pleaseEnterValidLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
