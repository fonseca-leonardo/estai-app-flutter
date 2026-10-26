import 'package:flutter/foundation.dart';
import '../models/boat.dart';
import '../models/ramp.dart';
import '../models/ramp_schedule_type.dart';
import '../models/ramp_slot.dart';
import '../services/api_exception.dart';
import '../services/ramp_schedule_service.dart';
import '../utils/marina_time.dart';

enum RampBookingStep { ramp, boat, operation, slot, returnTrip, review }

enum RampBookingError { conflict, invalid, unknown }

/// Estado do wizard "Agendar rampa". Vive só enquanto o wizard está aberto.
class RampBookingViewModel extends ChangeNotifier {
  RampBookingViewModel({RampScheduleService? rampScheduleService})
    : _rampScheduleService = rampScheduleService ?? RampScheduleService();

  final RampScheduleService _rampScheduleService;

  /// Tamanho de cada busca de disponibilidade (a API aceita até 31 dias).
  static const int _availabilityWindowDays = 14;

  List<Ramp> _ramps = [];
  bool _isInitialized = false;
  bool _isLoadingRamps = false;
  bool _hasNoMarina = false;
  String? _rampsErrorMessage;

  List<Boat> _allBoats = [];

  Ramp? _ramp;
  Boat? _boat;
  RampScheduleType? _type;

  final Map<DateTime, List<RampSlot>> _slotsByDay = {};
  DateTime? _loadedUntil;
  bool _isLoadingSlots = false;
  String? _slotsErrorMessage;

  DateTime? _day;
  RampSlot? _slot;

  bool _wantsReturn = false;
  DateTime? _returnDay;
  RampSlot? _returnSlot;

  String _notes = '';

  RampBookingStep _currentStep = RampBookingStep.ramp;
  bool _isSubmitting = false;
  RampBookingError? _submitError;
  String? _submitErrorMessage;

  List<Ramp> get ramps => List.unmodifiable(_ramps);
  bool get isInitialized => _isInitialized;
  bool get isLoadingRamps => _isLoadingRamps;
  bool get hasNoMarina => _hasNoMarina;
  String? get rampsErrorMessage => _rampsErrorMessage;

  Ramp? get ramp => _ramp;
  Boat? get boat => _boat;
  RampScheduleType? get type => _type;
  bool get isLoadingSlots => _isLoadingSlots;
  String? get slotsErrorMessage => _slotsErrorMessage;
  DateTime? get day => _day;
  RampSlot? get slot => _slot;
  bool get wantsReturn => _wantsReturn;
  DateTime? get returnDay => _returnDay;
  RampSlot? get returnSlot => _returnSlot;
  String get notes => _notes;
  RampBookingStep get currentStep => _currentStep;
  bool get isSubmitting => _isSubmitting;
  RampBookingError? get submitError => _submitError;
  String? get submitErrorMessage => _submitErrorMessage;

  /// Barcos do usuário que estão na marina da rampa escolhida.
  List<Boat> get boats {
    final marinaId = _ramp?.marinaId;
    return _allBoats
        .where(
          (boat) =>
              boat.hasMarinaAccess &&
              (marinaId == null || boat.marinaId == marinaId),
        )
        .toList();
  }

  /// Etapas visíveis. Rampa e barco somem quando só há uma opção; o retorno
  /// só aparece para descidas.
  List<RampBookingStep> get steps => [
    if (_ramps.length > 1) RampBookingStep.ramp,
    if (boats.length != 1) RampBookingStep.boat,
    RampBookingStep.operation,
    RampBookingStep.slot,
    if (_type == RampScheduleType.launch) RampBookingStep.returnTrip,
    RampBookingStep.review,
  ];

  int get currentIndex => steps.indexOf(_currentStep);
  bool get isFirstStep => currentIndex <= 0;

  bool get canContinue {
    switch (_currentStep) {
      case RampBookingStep.ramp:
        return _ramp != null;
      case RampBookingStep.boat:
        return _boat != null;
      case RampBookingStep.operation:
        return _type != null;
      case RampBookingStep.slot:
        return _slot != null;
      case RampBookingStep.returnTrip:
        return !_wantsReturn || _returnSlot != null;
      case RampBookingStep.review:
        return !_isSubmitting;
    }
  }

  /// Dias que o usuário pode escolher: de hoje até a antecedência máxima.
  List<DateTime> get selectableDays {
    final ramp = _ramp;
    if (ramp == null) return [];
    final today = MarinaTime.today();
    return List.generate(
      ramp.maxAdvanceDays + 1,
      (index) => today.add(Duration(days: index)),
    );
  }

  /// Dias possíveis para a subida de volta: do dia da descida em diante.
  List<DateTime> get returnDays {
    final launchDay = _day;
    if (launchDay == null) return [];
    return selectableDays.where((day) => !day.isBefore(launchDay)).toList();
  }

  bool isDayLoaded(DateTime day) => _slotsByDay.containsKey(day);

  List<RampSlot> slotsFor(DateTime day) => _slotsByDay[day] ?? const [];

  /// Slots do dia que servem para a subida de volta (depois da descida).
  List<RampSlot> returnSlotsFor(DateTime day) {
    final launchEnd = _slot?.endsAt;
    return slotsFor(day)
        .where(
          (slot) => launchEnd == null || !slot.startsAt.isBefore(launchEnd),
        )
        .toList();
  }

  bool dayHasAvailability(DateTime day) =>
      slotsFor(day).any((slot) => slot.isAvailable);

  bool returnDayHasAvailability(DateTime day) =>
      returnSlotsFor(day).any((slot) => slot.isAvailable);

  Future<void> initialize(List<Boat> boats) async {
    _allBoats = boats;
    _isLoadingRamps = true;
    _hasNoMarina = false;
    _rampsErrorMessage = null;
    notifyListeners();

    try {
      _ramps = await _rampScheduleService.getRamps();
    } on ApiException catch (e) {
      _hasNoMarina = e.statusCode == 400;
      _rampsErrorMessage = e.message;
    } catch (e) {
      _rampsErrorMessage = e.toString();
    }
    _isLoadingRamps = false;
    _isInitialized = true;

    if (_ramps.length == 1) {
      _applyRamp(_ramps.first);
    }
    _currentStep = steps.first;
    notifyListeners();
  }

  void updateBoats(List<Boat> boats) {
    _allBoats = boats;
    final available = this.boats;
    if (_boat == null && available.length == 1) {
      _boat = available.first;
    }
    notifyListeners();
  }

  void selectRamp(Ramp ramp) {
    _applyRamp(ramp);
    next();
  }

  void _applyRamp(Ramp ramp) {
    if (_ramp?.id == ramp.id) return;
    _ramp = ramp;
    final available = boats;
    if (_boat != null && !available.any((boat) => boat.id == _boat!.id)) {
      _boat = null;
    }
    if (_boat == null && available.length == 1) {
      _boat = available.first;
    }
    _resetSlots();
    loadMoreDays(MarinaTime.today());
  }

  void selectBoat(Boat boat) {
    _boat = boat;
    next();
  }

  void selectType(RampScheduleType type) {
    if (_type != type) {
      _type = type;
      if (type != RampScheduleType.launch) _clearReturn();
    }
    next();
  }

  void selectDay(DateTime day) {
    if (_day == day) return;
    _day = day;
    _slot = null;
    _clearReturn(keepToggle: true);
    loadMoreDays(day);
    notifyListeners();
  }

  void selectSlot(RampSlot slot) {
    _slot = slot;
    final returnSlot = _returnSlot;
    if (returnSlot != null && returnSlot.startsAt.isBefore(slot.endsAt)) {
      _returnSlot = null;
    }
    final returnDay = _returnDay;
    if (returnDay != null && returnDay.isBefore(_day!)) {
      _returnDay = _day;
    }
    notifyListeners();
  }

  void setWantsReturn(bool value) {
    _wantsReturn = value;
    if (value) {
      _returnDay ??= _day;
    } else {
      _returnSlot = null;
    }
    notifyListeners();
  }

  void selectReturnDay(DateTime day) {
    if (_returnDay == day) return;
    _returnDay = day;
    _returnSlot = null;
    loadMoreDays(day);
    notifyListeners();
  }

  void selectReturnSlot(RampSlot slot) {
    _returnSlot = slot;
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
  }

  void next() {
    final index = currentIndex;
    final visible = steps;
    if (index < visible.length - 1) {
      _currentStep = visible[index + 1];
      _submitError = null;
      if (_currentStep == RampBookingStep.slot && _day == null) {
        _selectFirstAvailableDay();
      }
    }
    notifyListeners();
  }

  /// Volta uma etapa. Retorna `false` quando já está na primeira.
  bool back() {
    final index = currentIndex;
    if (index <= 0) return false;
    _currentStep = steps[index - 1];
    _submitError = null;
    notifyListeners();
    return true;
  }

  void _selectFirstAvailableDay() {
    for (final day in selectableDays) {
      if (!isDayLoaded(day)) break;
      if (dayHasAvailability(day)) {
        _day = day;
        return;
      }
    }
    _day = selectableDays.isNotEmpty ? selectableDays.first : null;
  }

  DateTime? _pendingTarget;

  /// Garante que a disponibilidade até alguns dias depois de [day] esteja
  /// carregada, buscando em janelas de [_availabilityWindowDays] dias.
  Future<void> loadMoreDays(DateTime day) async {
    final ramp = _ramp;
    final days = selectableDays;
    if (ramp == null || days.isEmpty) return;

    final lastDay = days.last;
    var target = day.add(const Duration(days: 3));
    if (target.isAfter(lastDay)) target = lastDay;

    final pending = _pendingTarget;
    if (pending == null || target.isAfter(pending)) _pendingTarget = target;
    if (_isLoadingSlots) return;

    _isLoadingSlots = true;
    _slotsErrorMessage = null;
    notifyListeners();

    try {
      while (true) {
        final goal = _pendingTarget;
        final loadedUntil = _loadedUntil;
        if (goal == null ||
            (loadedUntil != null && !loadedUntil.isBefore(goal))) {
          break;
        }

        final from = loadedUntil?.add(const Duration(days: 1)) ?? days.first;
        var to = from.add(const Duration(days: _availabilityWindowDays - 1));
        if (to.isAfter(lastDay)) to = lastDay;

        final availability = await _rampScheduleService.getAvailability(
          rampId: ramp.id,
          from: MarinaTime.formatYmd(from),
          to: MarinaTime.formatYmd(to),
        );
        // A rampa pode ter mudado enquanto a resposta chegava.
        if (_ramp?.id != ramp.id) return;

        for (var d = from; !d.isAfter(to); d = d.add(const Duration(days: 1))) {
          _slotsByDay[d] = [];
        }
        for (final slot in availability.slots) {
          _slotsByDay
              .putIfAbsent(MarinaTime.dayOf(slot.startsAt), () => [])
              .add(slot);
        }
        _loadedUntil = to;
        notifyListeners();
      }

      _skipToAvailableDay();
    } catch (e) {
      _slotsErrorMessage = e.toString();
    } finally {
      if (_ramp?.id == ramp.id) {
        _isLoadingSlots = false;
        _pendingTarget = null;
        notifyListeners();
      }
    }
  }

  /// Ao abrir a etapa de horário, pula para o primeiro dia que tem vaga.
  void _skipToAvailableDay() {
    final day = _day;
    if (_currentStep != RampBookingStep.slot ||
        day == null ||
        _slot != null ||
        dayHasAvailability(day)) {
      return;
    }
    for (final candidate in selectableDays) {
      if (candidate.isBefore(day)) continue;
      if (!isDayLoaded(candidate)) return;
      if (dayHasAvailability(candidate)) {
        _day = candidate;
        return;
      }
    }
  }

  Future<void> reloadSlots() async {
    _resetSlots(keepDay: true);
    await loadMoreDays(_day ?? MarinaTime.today());
    final returnDay = _returnDay;
    if (returnDay != null) await loadMoreDays(returnDay);
  }

  void _resetSlots({bool keepDay = false}) {
    _slotsByDay.clear();
    _loadedUntil = null;
    _isLoadingSlots = false;
    _pendingTarget = null;
    _slotsErrorMessage = null;
    if (!keepDay) _day = null;
    _slot = null;
    _clearReturn(keepToggle: true);
  }

  void _clearReturn({bool keepToggle = false}) {
    if (!keepToggle) _wantsReturn = false;
    _returnDay = null;
    _returnSlot = null;
  }

  /// Envia o pedido. Em caso de conflito (409), recarrega os slots e volta
  /// para a escolha de horário.
  Future<CreateRampScheduleResult?> submit() async {
    final ramp = _ramp;
    final boat = _boat;
    final type = _type;
    final slot = _slot;
    if (ramp == null || boat == null || type == null || slot == null) {
      return null;
    }

    _isSubmitting = true;
    _submitError = null;
    _submitErrorMessage = null;
    notifyListeners();

    try {
      final result = await _rampScheduleService.createSchedule(
        rampId: ramp.id,
        boatId: boat.id,
        type: type,
        scheduledAt: slot.startsAt,
        returnAt: _wantsReturn ? _returnSlot?.startsAt : null,
        notes: _notes.trim(),
      );
      _isSubmitting = false;
      notifyListeners();
      return result;
    } on ApiException catch (e) {
      _isSubmitting = false;
      _submitErrorMessage = e.message;
      if (e.statusCode == 409) {
        _submitError = RampBookingError.conflict;
        _currentStep = RampBookingStep.slot;
        notifyListeners();
        await reloadSlots();
        return null;
      }
      _submitError = e.statusCode == 400
          ? RampBookingError.invalid
          : RampBookingError.unknown;
      notifyListeners();
      return null;
    } catch (e) {
      _isSubmitting = false;
      _submitError = RampBookingError.unknown;
      notifyListeners();
      return null;
    }
  }
}
