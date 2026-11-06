import 'ui/app_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/boat.dart';
import '../models/trip_summary.dart';
import '../utils/engine_hours_format.dart';
import '../utils/trip_format.dart';
import '../viewmodels/trip_log_viewmodel.dart';
import 'dark_input_decoration.dart';
import 'selectable_pill.dart';

/// Pergunta ao fim da navegação se a viagem vai para o diário de bordo. Não
/// fecha arrastando: o usuário escolhe salvar ou descartar.
Future<void> showSaveTripSheet({
  required BuildContext context,
  required TripSummary summary,
  required List<Boat> boats,
  String? initialBoatId,
}) {
  return AppSheet.show<void>(
    context,
    padded: false,
    useSafeArea: false,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => SaveTripSheet(
      summary: summary,
      boats: boats,
      initialBoatId: initialBoatId,
    ),
  );
}

class SaveTripSheet extends StatefulWidget {
  final TripSummary summary;
  final List<Boat> boats;
  final String? initialBoatId;

  const SaveTripSheet({
    super.key,
    required this.summary,
    required this.boats,
    this.initialBoatId,
  });

  @override
  State<SaveTripSheet> createState() => _SaveTripSheetState();
}

class _SaveTripSheetState extends State<SaveTripSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _engineHoursController = TextEditingController();
  final _passengersController = TextEditingController();
  late String _boatId;
  bool _titleInitialized = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialBoatId;
    _boatId = widget.boats.any((boat) => boat.id == initial)
        ? initial!
        : widget.boats.first.id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_titleInitialized) return;
    _titleInitialized = true;
    final locale = Localizations.localeOf(context).toString();
    _titleController.text = AppLocalizations.of(context)!.tripDefaultTitle(
      DateFormat.MMMd(locale).format(widget.summary.startedAt),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _engineHoursController.dispose();
    _passengersController.dispose();
    super.dispose();
  }

  Boat get _selectedBoat =>
      widget.boats.firstWhere((boat) => boat.id == _boatId);

  String? _validateEngineHours(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = EngineHoursFormat.parse(value);
    if (parsed == null || parsed < 0) return l10n.invalidNumber;
    final current = _selectedBoat.engineHours;
    if (current != null && parsed < current) {
      return l10n.engineHoursLowerThanCurrent(
        EngineHoursFormat.format(
          current,
          Localizations.localeOf(context).toString(),
        ),
      );
    }
    return null;
  }

  String? _validatePassengers(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = int.tryParse(value.trim());
    return parsed == null || parsed < 0 ? l10n.invalidNumber : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final notes = _notesController.text.trim();

    final result = await context.read<TripLogViewModel>().save(
      summary: widget.summary,
      boatId: _boatId,
      title: _titleController.text.trim(),
      notes: notes.isEmpty ? null : notes,
      engineHoursEnd: EngineHoursFormat.parse(_engineHoursController.text),
      passengers: int.tryParse(_passengersController.text.trim()),
    );
    if (!mounted) return;

    if (result == TripSaveResult.failed) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.tripSaveError)));
      return;
    }
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result == TripSaveResult.saved ? l10n.tripSaved : l10n.tripQueued,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final summary = widget.summary;
    final maxSpeed = summary.maxSpeedKn;
    final metrics = [
      TripFormat.distance(l10n, summary.distanceNm, locale),
      TripFormat.duration(l10n, summary.durationMinutes),
      if (maxSpeed != null)
        l10n.logbookTopSpeed(NumberFormat('#,##0.0', locale).format(maxSpeed)),
    ].join(' · ');
    final isSaving = context.watch<TripLogViewModel>().isSaving;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.tripSaveTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.tripSaveSubtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.route_outlined, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          metrics,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.tripBoatLabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final boat in widget.boats)
                      SelectablePill(
                        icon: Icons.directions_boat_outlined,
                        label: boat.name,
                        selected: boat.id == _boatId,
                        onTap: () => setState(() => _boatId = boat.id),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  maxLength: 120,
                  style: const TextStyle(color: Colors.white),
                  decoration: darkInputDecoration(l10n.logbookTitleLabel),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.logbookTitleRequired
                      : null,
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _engineHoursController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(color: Colors.white),
                        decoration: darkInputDecoration(
                          l10n.tripEngineHoursEndLabel,
                          suffixText: 'h',
                        ),
                        validator: (value) => _validateEngineHours(l10n, value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _passengersController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: darkInputDecoration(
                          l10n.tripPassengersLabel,
                        ),
                        validator: (value) => _validatePassengers(l10n, value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  maxLength: 2000,
                  style: const TextStyle(color: Colors.white),
                  decoration: darkInputDecoration(l10n.notesOptional),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: isSaving ? null : _save,
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
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(l10n.tripSave),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l10n.tripDiscard),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
