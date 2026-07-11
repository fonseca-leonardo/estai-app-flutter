import 'package:flutter/foundation.dart';

import '../models/estai_session.dart';
import '../models/marina.dart';
import '../services/estai_api_client.dart';
import '../services/marina_storage_service.dart';

/// Orquestra o fluxo de sessão do Estai na camada de UI.
///
/// Dispare [authenticate] após o login e ao entrar na tela de mapas. Os
/// services consomem diretamente [EstaiApiClient.instance] — esta view model
/// apenas expõe o estado da sessão e o carregamento para a UI.
class EstaiSessionViewModel extends ChangeNotifier {
  EstaiSessionViewModel({
    EstaiApiClient? client,
    MarinaStorageService? marinaStorageService,
  }) : _client = client ?? EstaiApiClient.instance,
       _marinaStorageService = marinaStorageService ?? MarinaStorageService();

  final EstaiApiClient _client;
  final MarinaStorageService _marinaStorageService;

  bool _isLoading = false;
  String? _errorMessage;
  Marina? _storedMarina;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  EstaiSession? get session => _client.session;
  EstaiUser? get user => _client.session?.user;
  EstaiMarina? get marina => _client.session?.user.marina;
  bool get isAuthenticated => _client.isAuthenticated;

  /// Marina associada ao usuário, combinando a sessão atual com o que está
  /// persistido localmente (cobre o caso de associação feita durante a
  /// sessão, sem precisar reautenticar).
  Marina? get activeMarina {
    final sessionMarina = marina;
    if (sessionMarina != null) {
      return Marina(id: sessionMarina.id, name: sessionMarina.name);
    }
    return _storedMarina;
  }

  bool get hasMarina => activeMarina != null;

  /// Recarrega a marina persistida localmente e notifica os observadores.
  /// Chamar após qualquer fluxo que possa ter associado o usuário a uma
  /// marina durante a sessão (ex.: [MarinaAccessScreen]).
  Future<void> refreshStoredMarina() async {
    _storedMarina = await _marinaStorageService.getSaved();
    notifyListeners();
  }

  /// Autentica no Estai. É idempotente: se já houver sessão ativa não refaz a
  /// chamada, a menos que [force] seja `true`.
  Future<bool> authenticate({bool force = false}) async {
    if (_isLoading) return _client.isAuthenticated;
    if (_client.isAuthenticated && !force) return true;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _client.authenticate();
      final marina = session.user.marina;
      if (marina != null) {
        _storedMarina = Marina(id: marina.id, name: marina.name);
        await _marinaStorageService.save(_storedMarina!);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Limpa a sessão do Estai (usar no logout).
  void clear() {
    _client.clearSession();
    _storedMarina = null;
    _errorMessage = null;
    notifyListeners();
  }
}
