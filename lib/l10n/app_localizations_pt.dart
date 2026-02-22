// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Estai - Mapa';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Senha';

  @override
  String get name => 'Nome';

  @override
  String get pleaseEnterEmail => 'Por favor, insira seu email';

  @override
  String get pleaseEnterValidEmail => 'Por favor, insira um email válido';

  @override
  String get pleaseEnterPassword => 'Por favor, insira sua senha';

  @override
  String get pleaseEnterName => 'Por favor, insira seu nome';

  @override
  String get nameMinLength => 'Nome deve ter pelo menos 2 caracteres';

  @override
  String get passwordMinLength => 'Senha deve ter pelo menos 6 caracteres';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get enter => 'Entrar';

  @override
  String get dontHaveAccount => 'Não tenho uma conta. ';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get continueWithoutLogin => 'Continuar sem login';

  @override
  String get createAccountTitle => 'Criar Conta';

  @override
  String get alreadyHaveAccount => 'Já tenho uma conta. ';

  @override
  String get signIn => 'Fazer login';

  @override
  String get recoverPassword => 'Recuperar Senha';

  @override
  String get forgotPasswordTitle => 'Esqueceu sua senha?';

  @override
  String get forgotPasswordDescription => 'Digite seu email e enviaremos um link para redefinir sua senha.';

  @override
  String get sendEmail => 'Enviar Email';

  @override
  String get backToLogin => 'Voltar para login';

  @override
  String get passwordResetEmailSent => 'Email de recuperação enviado! Verifique sua caixa de entrada.';

  @override
  String get settings => 'Configurações';

  @override
  String get account => 'Conta';

  @override
  String get notAuthenticated => 'Você não está autenticado.';

  @override
  String get logout => 'Sair';

  @override
  String minimumDistance(String value) {
    return 'Distância mínima: $value m';
  }

  @override
  String get minimumDistanceDescription => 'Define a distância mínima em metros que o usuário precisa percorrer para que um novo ponto seja adicionado à rota rastreada durante a navegação. Valores maiores resultam em rotas com menos pontos, enquanto valores menores criam rotas mais detalhadas.';

  @override
  String meters(String value) {
    return '$value m';
  }

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get locationServicesDisabled => 'Serviços de localização estão desabilitados.';

  @override
  String get locationPermissionDenied => 'Permissão de localização negada.';

  @override
  String get locationPermissionDeniedForever => 'Permissão de localização negada permanentemente.';

  @override
  String errorGettingLocation(String error) {
    return 'Erro ao obter localização: $error';
  }

  @override
  String errorUpdatingLocation(String error) {
    return 'Erro ao atualizar localização: $error';
  }

  @override
  String get finishNavigation => 'Finalizar Navegação';

  @override
  String get finishNavigationQuestion => 'Deseja realmente finalizar a navegação?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get finish => 'Finalizar';

  @override
  String get unlockCamera => 'Desbloquear câmera';

  @override
  String get lockCamera => 'Bloquear câmera na posição';

  @override
  String get hideCustomTiles => 'Ocultar tiles customizados';

  @override
  String get showCustomTiles => 'Mostrar tiles customizados';

  @override
  String get navigate => 'Navegar';

  @override
  String get newRoute => 'Nova Rota';

  @override
  String get tides => 'Marés';

  @override
  String get adjustments => 'Ajustes';

  @override
  String get improvementsAndSuggestions => 'Sugestões';

  @override
  String get feedbackSuggestionPlaceholder => 'Compartilhe sua sugestão ou melhoria (máx. 500 caracteres)';

  @override
  String get feedbackSentSuccess => 'Obrigado! Seu feedback foi enviado.';

  @override
  String get feedbackError => 'Não foi possível enviar o feedback. Tente novamente.';

  @override
  String feedbackMaxCharacters(String current, String max) {
    return '$current/$max';
  }

  @override
  String get addPoint => 'Adicionar ponto?';

  @override
  String get confirmPoint => 'Confirmar ponto';

  @override
  String get tideTables => 'Tábuas de Maré';

  @override
  String get noTideTablesFound => 'Nenhuma tábua de maré encontrada';

  @override
  String errorLoadingTideTables(String error) {
    return 'Erro ao carregar tábuas de maré: $error';
  }

  @override
  String get velocity => 'VEL';

  @override
  String get heading => 'HDG';

  @override
  String get latitude => 'LAT';

  @override
  String get longitude => 'LON';

  @override
  String get distance => 'DIST';

  @override
  String get time => 'TEMPO';

  @override
  String get invalidEmailOrPassword => 'Email ou senha inválido';

  @override
  String get invalidEmail => 'Email inválido';

  @override
  String get userDisabled => 'Usuário desabilitado';

  @override
  String get tooManyRequests => 'Muitas tentativas. Tente novamente mais tarde';

  @override
  String loginError(String message) {
    return 'Erro ao fazer login: $message';
  }

  @override
  String get weakPassword => 'Senha muito fraca';

  @override
  String get emailAlreadyInUse => 'Email já está em uso';

  @override
  String signUpError(String message) {
    return 'Erro ao criar conta: $message';
  }

  @override
  String get emailNotFound => 'Email não encontrado';

  @override
  String sendEmailError(String message) {
    return 'Erro ao enviar email: $message';
  }

  @override
  String logoutError(String error) {
    return 'Erro ao fazer logout: $error';
  }

  @override
  String get navigationSettings => 'Configurações de Navegação';

  @override
  String get navigationSettingsDescription => 'Configure as opções de navegação e rastreamento';

  @override
  String get navigationPermission => 'Permissões GPS';

  @override
  String get navigationPermissionDescription => 'Veja o status atual da permissão de localização e altere nas configurações do sistema se necessário.';

  @override
  String get locationPermissionAlways => 'Sempre permitir';

  @override
  String get locationPermissionAlwaysSubtitle => 'Localização disponível em primeiro e segundo plano.';

  @override
  String get locationPermissionWhileInUse => 'Enquanto usa o app';

  @override
  String get locationPermissionWhileInUseSubtitle => 'Ative \"Sempre\" para rastrear durante a navegação.';

  @override
  String get openAppSettings => 'Abrir configurações';

  @override
  String get locationPermissionChecking => 'Verificando...';

  @override
  String get locationPermissionCheckingSubtitle => 'Aguarde enquanto verificamos.';

  @override
  String get locationPermissionDeniedSubtitle => 'O app não pode acessar sua localização.';

  @override
  String get locationPermissionDeniedForeverSubtitle => 'Você negou a permissão. Altere nas configurações do sistema.';

  @override
  String get userAccount => 'Conta do Usuário';

  @override
  String get manageAccountInfo => 'Gerencie suas informações de conta';

  @override
  String get logoutAccount => 'Sair da conta';

  @override
  String get logoutAccountDescription => 'Você precisará fazer login novamente';

  @override
  String get loginToAccessInfo => 'Faça login para acessar suas informações';

  @override
  String get myRoutes => 'Minhas Rotas';

  @override
  String get routesList => 'Lista de Rotas';

  @override
  String get noRoutesFound => 'Nenhuma rota encontrada';

  @override
  String get routeName => 'Nome da Rota';

  @override
  String get saveRoute => 'Salvar Rota';

  @override
  String get deleteRoute => 'Apagar Rota';

  @override
  String get routeSaved => 'Rota salva com sucesso';

  @override
  String get errorSavingRoute => 'Erro ao salvar rota';

  @override
  String get editRouteName => 'Editar nome da rota';

  @override
  String get pleaseEnterRouteName => 'Por favor, insira um nome para a rota';

  @override
  String get loadRoute => 'Carregar Rota';

  @override
  String get points => 'pontos';

  @override
  String get confirmRoute => 'Confirmar Rota';

  @override
  String get startNavigationWithRoute => 'Iniciar Navegação';

  @override
  String get routeDetails => 'Detalhes da Rota';

  @override
  String get totalDistance => 'Distância Total';

  @override
  String get maps => 'Mapas';

  @override
  String get mapsSelectionDescription => 'Selecione os mapas que deseja exibir na tela principal. Os mapas selecionados serão sobrepostos ao mapa base.';

  @override
  String get mapsSelectionPerformanceWarning => 'Atenção: Selecionar muitos mapas pode impactar o desempenho do aplicativo e aumentar o uso de dados.';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get darkModeDescription => 'Ative o modo escuro para mapas customizados para reduzir o cansaço visual em condições de pouca luz.';

  @override
  String get saveRouteForReuse => 'Salvar para reutilização';

  @override
  String get saveRouteForReuseDescription => 'Salve esta rota para poder usá-la novamente no futuro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get plannedRoute => 'Rota Planejada';

  @override
  String get errorLoadingMaps => 'Não foi possível buscar a lista de mapas agora. Verifique sua conexão com a internet e tente novamente mais tarde.';

  @override
  String get signInWithGoogle => 'Continuar com Google';

  @override
  String get orContinueWith => 'ou continuar com';

  @override
  String googleSignInError(String message) {
    return 'Erro ao fazer login com Google: $message';
  }

  @override
  String get googleSignInCancelled => 'Login com Google cancelado';

  @override
  String googleSignInFailed(String error) {
    return 'Falha ao fazer login com Google: $error';
  }

  @override
  String get networkError => 'Erro de rede. Verifique sua conexão com a internet.';

  @override
  String get accountExistsWithDifferentCredential => 'Uma conta já existe com o mesmo endereço de email, mas usando um método de login diferente.';

  @override
  String get operationNotAllowed => 'Login com Google não está habilitado. Entre em contato com o suporte.';

  @override
  String get signInWithApple => 'Continuar com Apple';

  @override
  String appleSignInError(String message) {
    return 'Erro ao fazer login com Apple: $message';
  }

  @override
  String get appleSignInCancelled => 'Login com Apple cancelado';

  @override
  String appleSignInFailed(String error) {
    return 'Falha ao fazer login com Apple: $error';
  }

  @override
  String get tideDataDisclaimer => 'Os dados oficiais de maré são de responsabilidade da Marinha do Brasil.';

  @override
  String get tideExternalBrowserNotice => 'Ao selecionar um das tábuas, você será redirecionado para o site oficial da Marinha do Brasil';

  @override
  String get weatherForecast => 'Previsão do Tempo';

  @override
  String get errorLoadingForecast => 'Erro ao carregar previsões';

  @override
  String get noForecastAvailable => 'Nenhuma previsão disponível';

  @override
  String get marine => 'Mar';

  @override
  String get weather => 'Clima';

  @override
  String get waveHeight => 'Altura';

  @override
  String get wavePeriod => 'Período';

  @override
  String get waveDirection => 'Direção';

  @override
  String get temperature => 'Temp';

  @override
  String get dewPoint => 'P. Orvalho';

  @override
  String get windSpeed => 'Vento';

  @override
  String get windDirection => 'Direção';

  @override
  String get windGusts => 'Rajadas';

  @override
  String get pressure => 'Pressão';

  @override
  String get humidity => 'Umidade';

  @override
  String get precipitation => 'Chuva';

  @override
  String get precipitationProbability => 'Prob. Chuva';

  @override
  String get loginRequiredForForecast => 'Para acessar a previsão do tempo, você precisa estar logado.';

  @override
  String get loginRequiredForAction => 'Para realizar esta ação é preciso estar logado.';

  @override
  String get goToLogin => 'Ir para Login';

  @override
  String get addWeatherPin => 'Adicionar Pin de Clima';

  @override
  String get weatherPinsList => 'Clima';

  @override
  String get pinName => 'Nome do Pin';

  @override
  String get enterPinName => 'Digite o nome do pin';

  @override
  String get deletePin => 'Remover';

  @override
  String get editPinName => 'Editar Nome';

  @override
  String get noPinsAdded => 'Nenhum pin adicionado';

  @override
  String get addingPinMode => 'Modo de Adição Ativo';

  @override
  String get tapMapToAddPin => 'Segure no mapa para adicionar';

  @override
  String get currentLocation => 'Localização atual';

  @override
  String get save => 'Salvar';

  @override
  String confirmDeletePin(String pinName) {
    return 'Tem certeza que deseja remover o pin \"$pinName\"?';
  }

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get deleteAccountDescription => 'Excluir permanentemente sua conta e todos os dados associados';

  @override
  String get deleteAccountWarning => 'Esta ação não pode ser desfeita. Todos os seus dados serão perdidos permanentemente.';

  @override
  String get deleteAccountConfirmTitle => 'Confirmar Exclusão de Conta';

  @override
  String get deleteAccountConfirmMessage => 'Tem certeza que deseja excluir sua conta? Esta ação é irreversível e removerá:';

  @override
  String get deleteAccountConfirmItems => '• Sua conta de autenticação\n• Todas as rotas salvas\n• Todos os dados associados';

  @override
  String get deleteAccountSuccess => 'Conta excluída com sucesso';

  @override
  String deleteAccountError(String error) {
    return 'Erro ao excluir conta: $error';
  }

  @override
  String get deleteAccountRequiresRecentLogin => 'Para excluir sua conta, você precisa fazer login novamente por segurança.';

  @override
  String get typeDeleteToConfirm => 'Digite EXCLUIR para confirmar';
}
