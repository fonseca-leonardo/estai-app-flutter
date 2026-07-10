import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat.dart';
import '../../models/boat_type.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import 'widgets/boat_type_dropdown.dart';
import 'widgets/marina_access_toggle.dart';

class BoatFormScreen extends StatefulWidget {
  final Boat? boat;

  const BoatFormScreen({super.key, this.boat});

  bool get isEditing => boat != null;

  @override
  State<BoatFormScreen> createState() => _BoatFormScreenState();
}

class _BoatFormScreenState extends State<BoatFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'BoatFormScreen';

  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.boat?.name);
  late final _modelController = TextEditingController(text: widget.boat?.model);
  late final _yearController = TextEditingController(
    text: widget.boat?.year.toString(),
  );
  late final _lengthController = TextEditingController(
    text: widget.boat?.length.toString(),
  );
  late BoatType _selectedType = widget.boat?.type ?? BoatType.boat;
  String? _errorMessage;
  bool _isUpdatingMarinaAccess = false;

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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    final viewModel = context.read<BoatViewModel>();
    final name = _nameController.text.trim();
    final model = _modelController.text.trim();
    final year = int.parse(_yearController.text.trim());
    final length = double.parse(
      _lengthController.text.trim().replaceAll(',', '.'),
    );

    final boat = widget.boat;
    final success = boat == null
        ? await viewModel.addBoat(
            name: name,
            model: model,
            type: _selectedType,
            year: year,
            length: length,
          )
        : await viewModel.updateBoat(
            boat.id,
            name: name,
            model: model,
            type: _selectedType,
            year: year,
            length: length,
          );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.saveBoatError;
      });
    }
  }

  Future<void> _toggleMarinaAccess(bool access) async {
    final boat = widget.boat;
    if (boat == null) return;

    setState(() => _isUpdatingMarinaAccess = true);

    final viewModel = context.read<BoatViewModel>();
    final success = await viewModel.setMarinaAccess(boat.id, access);

    if (!mounted) return;

    setState(() {
      _isUpdatingMarinaAccess = false;
      if (!success) {
        _errorMessage = AppLocalizations.of(context)!.marinaAccessToggleError;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.editBoat : l10n.addBoat),
        backgroundColor: Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
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
                if (widget.isEditing) ...[
                  const SizedBox(height: 16),
                  Consumer<BoatViewModel>(
                    builder: (context, viewModel, child) {
                      final currentBoat = viewModel.boats.firstWhere(
                        (boat) => boat.id == widget.boat!.id,
                        orElse: () => widget.boat!,
                      );
                      return MarinaAccessToggle(
                        value: currentBoat.hasMarinaAccess,
                        isUpdating: _isUpdatingMarinaAccess,
                        onChanged: _toggleMarinaAccess,
                      );
                    },
                  ),
                ],
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
                const SizedBox(height: 24),
                Consumer<BoatViewModel>(
                  builder: (context, viewModel, child) {
                    return SizedBox(
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
                        child: viewModel.isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(l10n.save),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
