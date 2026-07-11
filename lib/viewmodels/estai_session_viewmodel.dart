import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/estai_session.dart';
import '../models/marina.dart';
import '../services/estai_api_client.dart';
import '../services/marina_image_storage_service.dart';
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
    MarinaImageStorageService? logoStorageService,
    MarinaImageStorageService? backgroundStorageService,
  }) : _client = client ?? EstaiApiClient.instance,
       _marinaStorageService = marinaStorageService ?? MarinaStorageService(),
       _logoStorageService =
           logoStorageService ?? MarinaImageStorageService.logo(),
       _backgroundStorageService =
           backgroundStorageService ??
           MarinaImageStorageService.background() {
    _loadSavedImages();
  }

  final EstaiApiClient _client;
  final MarinaStorageService _marinaStorageService;
  final MarinaImageStorageService _logoStorageService;
  final MarinaImageStorageService _backgroundStorageService;

  bool _isLoading = false;
  String? _errorMessage;
  Marina? _storedMarina;
  File? _logoFile;
  File? _backgroundFile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Arquivo local da logo da marina, se já baixada. Usado no mapa no lugar
  /// do ícone de âncora.
  File? get logoFile => _logoFile;

  /// Arquivo local da imagem de fundo da marina, se já baixada. Usado como
  /// background da MarinaHomeScreen.
  File? get backgroundFile => _backgroundFile;

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
      // Baixa/atualiza as imagens em background para não atrasar o login.
      _syncLogo(marina?.logoUrl);
      _syncBackground(marina?.backgroundUrl);
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
    _logoFile = null;
    _backgroundFile = null;
    _logoStorageService.clear();
    _backgroundStorageService.clear();
    notifyListeners();
  }

  /// Carrega as imagens persistidas localmente (se houver) para exibição
  /// imediata, inclusive offline, antes de qualquer novo download.
  Future<void> _loadSavedImages() async {
    final logo = await _logoStorageService.getSaved();
    final background = await _backgroundStorageService.getSaved();
    var changed = false;
    if (logo != null) {
      _logoFile = logo;
      changed = true;
    }
    if (background != null) {
      _backgroundFile = background;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  /// Baixa/atualiza a logo da marina a partir de [url] e notifica a UI.
  Future<void> _syncLogo(String? url) async {
    final file = await _logoStorageService.syncFromUrl(url);
    if (file?.path != _logoFile?.path) {
      _logoFile = file;
      notifyListeners();
    }
  }

  /// Baixa/atualiza a imagem de fundo da marina a partir de [url] e notifica
  /// a UI.
  Future<void> _syncBackground(String? url) async {
    final file = await _backgroundStorageService.syncFromUrl(url);
    if (file?.path != _backgroundFile?.path) {
      _backgroundFile = file;
      notifyListeners();
    }
  }
}
