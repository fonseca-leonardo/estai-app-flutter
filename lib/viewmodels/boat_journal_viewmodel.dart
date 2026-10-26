import 'package:flutter/foundation.dart';
import '../models/boat_overview.dart';
import '../services/boat_journal_service.dart';

/// Hub do Diário da Embarcação: resumo do barco e horímetro.
///
/// Criada pela própria tela com o [boatId] (escopo de tela).
class BoatJournalViewModel extends ChangeNotifier {
  BoatJournalViewModel({
    required this.boatId,
    double? initialEngineHours,
    BoatJournalService? boatJournalService,
  }) : _initialEngineHours = initialEngineHours,
       _boatJournalService = boatJournalService ?? BoatJournalService();

  final String boatId;
  final double? _initialEngineHours;
  final BoatJournalService _boatJournalService;

  BoatOverview? _overview;
  bool _isLoading = false;
  bool _isSavingEngineHours = false;
  String? _errorMessage;

  BoatOverview? get overview => _overview;
  bool get isLoading => _isLoading;
  bool get isSavingEngineHours => _isSavingEngineHours;
  String? get errorMessage => _errorMessage;

  /// Leitura mais recente: a do resumo, ou a que veio no cadastro do barco
  /// enquanto o resumo não carrega.
  double? get engineHours => _overview?.engineHours ?? _initialEngineHours;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _overview = await _boatJournalService.getOverview(boatId);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateEngineHours(double hours) async {
    _isSavingEngineHours = true;
    notifyListeners();

    try {
      final reading = await _boatJournalService.addEngineHoursReading(
        boatId: boatId,
        hours: hours,
      );
      _overview = _overview?.copyWith(
        engineHours: reading.hours,
        engineHoursReadAt: reading.readAt,
      );
      _isSavingEngineHours = false;
      notifyListeners();
      // Atrasos por horímetro mudam com a nova leitura.
      load();
      return true;
    } catch (e) {
      _isSavingEngineHours = false;
      notifyListeners();
      return false;
    }
  }
}
