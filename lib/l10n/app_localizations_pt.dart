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
  String get resumeNavigationTitle => 'Retomar navegação?';

  @override
  String resumeNavigationQuestion(String duration) {
    return 'Detectamos uma navegação iniciada há $duration. Deseja retomar?';
  }

  @override
  String get resume => 'Retomar';

  @override
  String get discard => 'Descartar';

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
  String get mapsSelectionPerformanceWarning => 'Atenção: Selecionar muitos mapas pode impactar o desempenho do aplicativo.';

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

  @override
  String get backgroundLocationDisclosureTitle => 'Acesso à Localização em Segundo Plano';

  @override
  String get backgroundLocationDisclosureBody => 'Este aplicativo coleta seus dados de localização para permitir o rastreamento de rotas e navegação mesmo quando o app está em segundo plano ou a tela está desligada.\n\nIsso permite que você:\n• Rastreie sua rota durante a navegação sem manter a tela ligada\n• Receba atualizações de posição precisas continuamente\n\nSeus dados de localização são usados apenas para navegação e não são compartilhados com terceiros.';

  @override
  String get backgroundLocationAllow => 'Permitir';

  @override
  String get backgroundLocationNotNow => 'Agora não';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get signalKConfiguration => 'Configuração SignalK';

  @override
  String get signalKConfigurationDescription => 'Configure o servidor SignalK local para receber dados de navegação do barco.';

  @override
  String get signalKHost => 'Endereço do servidor';

  @override
  String get signalKHostHint => 'ex: este.signalk.local:3000';

  @override
  String get signalKHostRequired => 'Informe o endereço do servidor';

  @override
  String get signalKToken => 'Token de acesso';

  @override
  String get signalKTokenHint => 'Cole aqui o token gerado no SignalK';

  @override
  String get signalKConfigurationSaved => 'Configuração SignalK salva';

  @override
  String get signalKClearConfiguration => 'Limpar configuração';

  @override
  String get rasterCharts => 'Cartas Raster (BSB/KAP)';

  @override
  String get rasterChartsEmptyTitle => 'Nenhuma carta importada';

  @override
  String get rasterChartsEmptyMessage => 'Importe um .zip de carta raster (BSB/KAP) da Marinha do Brasil para visualizá-la sobre o mapa.';

  @override
  String get rasterChartImport => 'Importar carta';

  @override
  String get rasterChartImporting => 'Importando carta...';

  @override
  String get rasterChartImportSuccess => 'Carta importada com sucesso';

  @override
  String get rasterChartRemoveTitle => 'Remover carta';

  @override
  String rasterChartRemoveMessage(String name) {
    return 'Tem certeza que deseja remover \"$name\"?';
  }

  @override
  String get remove => 'Remover';

  @override
  String rasterChartCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cartas',
      one: 'carta',
    );
    return '$_temp0';
  }

  @override
  String rasterChartProjectionWarning(String projection) {
    return 'Projeção $projection não totalmente suportada — alinhamento aproximado.';
  }

  @override
  String get anchorAlarm => 'Alarme Âncora';

  @override
  String get anchorAlarmActive => 'Alarme de âncora ativo';

  @override
  String get anchorAlarmSetTitle => 'Definir Alarme de Âncora';

  @override
  String get anchorAlarmRadius => 'Raio de segurança (metros)';

  @override
  String get anchorAlarmRadiusHint => 'ex: 50';

  @override
  String get anchorAlarmRadiusError => 'Insira um valor entre 1 e 9999';

  @override
  String get anchorAlarmUseCurrentPosition => 'Usar posição atual';

  @override
  String get anchorAlarmTapToSet => 'Toque no mapa para posicionar a âncora';

  @override
  String get anchorAlarmTriggered => 'Âncora Arrastou!';

  @override
  String get anchorAlarmTriggeredMessage => 'Você saiu do raio de segurança definido para a âncora.';

  @override
  String get anchorAlarmDisable => 'Desativar Alarme';

  @override
  String get anchorAlarmDisableConfirmTitle => 'Desativar o alarme de âncora?';

  @override
  String get anchorAlarmDisableConfirmMessage => 'Você deixará de ser avisado se a âncora arrastar.';

  @override
  String get anchorAlarmDismiss => 'Ignorar';

  @override
  String get anchorAlarmNotificationRationaleTitle => 'Permissão de Notificações';

  @override
  String get anchorAlarmNotificationRationaleBody => 'O alarme de âncora precisa enviar notificações para alertá-lo quando a âncora arrastar, mesmo com o app em segundo plano ou a tela desligada.';

  @override
  String get anchorAlarmNotificationBlockedTitle => 'Notificações Bloqueadas';

  @override
  String get anchorAlarmNotificationBlockedBody => 'As notificações estão bloqueadas para este app. Para receber o alarme de âncora, ative as notificações nas configurações do sistema.';

  @override
  String get notNow => 'Agora não';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao Estai';

  @override
  String get onboardingWelcomeDescription => 'Um tour rápido pelas funcionalidades disponíveis na tela do mapa.';

  @override
  String get onboardingRoutesTitle => 'Planeje suas rotas';

  @override
  String get onboardingRoutesDescription => 'Inicie uma nova rota pelo menu de ações, segure no mapa para adicionar pontos e salve para reutilizar em outras viagens.';

  @override
  String get onboardingNavigationTitle => 'Inicie a navegação';

  @override
  String get onboardingNavigationDescription => 'Inicie a navegação para acompanhar o andamento da viagem em tempo real: mantenha o rumo, veja distância, velocidade e o trajeto percorrido no mapa.';

  @override
  String get onboardingRasterChartsTitle => 'Cartas raster da Marinha';

  @override
  String get onboardingRasterChartsDescription => 'Importe as cartas oficiais BSB/KAP da Marinha do Brasil e sobreponha no mapa para uma navegação mais precisa.';

  @override
  String get onboardingWeatherTitle => 'Previsão do tempo';

  @override
  String get onboardingWeatherDescription => 'Adicione pins de clima ao longo do trajeto e acompanhe previsão marinha, vento, ondas e chuva com antecedência.';

  @override
  String get onboardingAnchorAlarmTitle => 'Alarme de âncora';

  @override
  String get onboardingAnchorAlarmDescription => 'Defina um raio de segurança após ancorar e receba um alerta caso o barco saia desse raio, mesmo com a tela desligada.';

  @override
  String get onboardingBoatsTitle => 'Meus barcos';

  @override
  String get onboardingBoatsDescription => 'Cadastre seus barcos e acompanhe tudo em um só lugar: diário de bordo com as viagens salvas, manutenções, horímetro e lembretes por push ou e-mail.';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingPrevious => 'Voltar';

  @override
  String get onboardingFinish => 'Começar';

  @override
  String onboardingStepProgress(String current, String total) {
    return '$current de $total';
  }

  @override
  String get myBoats => 'Meus Barcos';

  @override
  String get myBoatsTooltip => 'Meus Barcos';

  @override
  String get addBoat => 'Adicionar Barco';

  @override
  String get noBoatsFound => 'Nenhum barco cadastrado';

  @override
  String get boatName => 'Nome';

  @override
  String get boatModel => 'Modelo';

  @override
  String get boatYear => 'Ano';

  @override
  String get boatType => 'Tipo';

  @override
  String get boatLength => 'Comprimento (pés)';

  @override
  String get pleaseEnterBoatName => 'Por favor, insira o nome do barco';

  @override
  String get pleaseEnterBoatModel => 'Por favor, insira o modelo do barco';

  @override
  String get pleaseEnterValidYear => 'Por favor, insira um ano válido';

  @override
  String get pleaseEnterValidLength => 'Por favor, insira um comprimento válido';

  @override
  String get deleteBoat => 'Excluir Barco';

  @override
  String get confirmDeleteBoat => 'Tem certeza que deseja excluir este barco?';

  @override
  String get boatTypeJetski => 'Jet Ski';

  @override
  String get boatTypeSailboat => 'Veleiro';

  @override
  String get boatTypeBoat => 'Barco';

  @override
  String get boatTypeYacht => 'Iate';

  @override
  String get editBoat => 'Editar Barco';

  @override
  String get loadBoatsError => 'Não foi possível carregar seus barcos.';

  @override
  String get saveBoatError => 'Não foi possível salvar o barco. Tente novamente.';

  @override
  String get deleteBoatError => 'Não foi possível excluir o barco. Tente novamente.';

  @override
  String get signalKIosLocalNetworkNotice => 'Na primeira conexão, o iOS solicitará permissão de acesso à rede local. Permita para que o app possa se comunicar com o servidor SignalK.';

  @override
  String get marinaAccessTitle => 'Associar à Marina';

  @override
  String get marinaAccessInviteMessage => 'Você foi convidado a se associar a esta marina. Selecione as embarcações que deseja vincular.';

  @override
  String get selectBoatsToAssociate => 'Selecione as embarcações';

  @override
  String get noBoatsAvailable => 'Você ainda não possui embarcações cadastradas. É possível continuar sem selecionar nenhuma.';

  @override
  String get confirmAssociation => 'Confirmar associação';

  @override
  String get associationSuccessTitle => 'Associação concluída!';

  @override
  String associationSuccessMessage(String marinaName) {
    return 'Você agora está associado à $marinaName.';
  }

  @override
  String get backToApp => 'Voltar para o app';

  @override
  String get loadMarinaError => 'Não foi possível carregar os dados da marina.';

  @override
  String get associationError => 'Não foi possível concluir a associação. Tente novamente.';

  @override
  String get marinaAccessToggleLabel => 'Acesso da marina';

  @override
  String get marinaAccessToggleDescription => 'Permita que a marina visualize e gerencie esta embarcação.';

  @override
  String get marinaAccessToggleError => 'Não foi possível atualizar o acesso da marina. Tente novamente.';

  @override
  String get marinaHubTooltip => 'Minha marina';

  @override
  String get marinaHomeTitle => 'Minha Marina';

  @override
  String get marinaHomeMyBoatsSubtitle => 'Gerencie suas embarcações';

  @override
  String get newServiceOrder => 'Nova ordem de serviço';

  @override
  String get newServiceOrderSubtitle => 'Solicite um serviço para o seu barco';

  @override
  String get myServiceOrders => 'Minhas ordens de serviço';

  @override
  String get myServiceOrdersSubtitle => 'Acompanhe o andamento das suas ordens';

  @override
  String get recentServiceOrders => 'Ordens recentes';

  @override
  String get seeAllServiceOrders => 'Ver todas';

  @override
  String get noServiceOrders => 'Nenhuma ordem de serviço ainda';

  @override
  String get noServiceOrdersWithFilter => 'Nenhuma ordem de serviço com esse status';

  @override
  String get loadServiceOrdersError => 'Não foi possível carregar suas ordens de serviço.';

  @override
  String get serviceOrderStatusAll => 'Todas';

  @override
  String get filterByStatus => 'Filtrar por status';

  @override
  String get serviceOrderStatusPending => 'Pendente';

  @override
  String get serviceOrderStatusScheduled => 'Agendada';

  @override
  String get serviceOrderStatusInProgress => 'Em andamento';

  @override
  String get serviceOrderStatusCompleted => 'Concluída';

  @override
  String get serviceOrderStatusCancelled => 'Cancelada';

  @override
  String get selectBoat => 'Barco';

  @override
  String get pleaseSelectBoat => 'Selecione um barco';

  @override
  String get selectService => 'Serviço';

  @override
  String get pleaseSelectService => 'Selecione um serviço';

  @override
  String get notesOptional => 'Observações (opcional)';

  @override
  String get estimatedPrice => 'Preço de tabela';

  @override
  String get createServiceOrder => 'Criar ordem';

  @override
  String get serviceOrderCreated => 'Ordem de serviço criada';

  @override
  String get createServiceOrderError => 'Não foi possível criar a ordem de serviço. Tente novamente.';

  @override
  String get noMarinaBoats => 'Nenhum barco vinculado à marina';

  @override
  String get noMarinaBoatsDescription => 'Vincule um barco à marina para poder solicitar serviços.';

  @override
  String get manageBoatsCta => 'Gerenciar meus barcos';

  @override
  String get emptyServiceCatalog => 'A marina ainda não cadastrou serviços';

  @override
  String get loadPriceItemsError => 'Não foi possível carregar os serviços disponíveis.';

  @override
  String get cancelServiceOrder => 'Cancelar ordem';

  @override
  String get cancelServiceOrderConfirm => 'Cancelar esta ordem de serviço?';

  @override
  String get cancelServiceOrderError => 'Não foi possível cancelar a ordem de serviço. Tente novamente.';

  @override
  String get keepOrder => 'Manter';

  @override
  String get unitPerUnit => 'un.';

  @override
  String get unitPerHour => 'hora';

  @override
  String get unitPerDay => 'dia';

  @override
  String get unitPerMonth => 'mês';

  @override
  String get selectBoatTitle => 'Selecione seu barco';

  @override
  String get selectBoatSubtitle => 'Sua marina acompanhará a posição deste barco durante a navegação.';

  @override
  String get startNavigationAction => 'Iniciar navegação';

  @override
  String get startWithoutMonitoring => 'Iniciar sem monitoria';

  @override
  String get noBoatsMonitoringWarning => 'Você não tem barcos vinculados à marina, então ela não fará a monitoria desta navegação.';

  @override
  String get registerBoat => 'Cadastrar barco';

  @override
  String get startAnyway => 'Iniciar mesmo assim';

  @override
  String get rampTypeLaunch => 'Descida';

  @override
  String get rampTypeHaul => 'Subida';

  @override
  String get rampStatusPending => 'Pendente';

  @override
  String get rampStatusConfirmed => 'Confirmado';

  @override
  String get rampStatusInProgress => 'Em andamento';

  @override
  String get rampStatusCompleted => 'Concluído';

  @override
  String get rampStatusCancelled => 'Cancelado';

  @override
  String get rampStatusRejected => 'Recusado';

  @override
  String get rampStatusNoShow => 'Não compareceu';

  @override
  String get rampBookingTitle => 'Agendar rampa';

  @override
  String get rampBookingSubtitle => 'Desça ou suba seu barco na rampa da marina';

  @override
  String get myRampSchedules => 'Meus agendamentos de rampa';

  @override
  String get myRampSchedulesSubtitle => 'Acompanhe a aprovação dos seus pedidos';

  @override
  String get upcomingRampSchedules => 'Próximos na rampa';

  @override
  String get seeAllRampSchedules => 'Ver todos';

  @override
  String get noUpcomingRampSchedules => 'Nenhum agendamento de rampa por vir';

  @override
  String get rampStepRamp => 'Rampa';

  @override
  String get rampStepBoat => 'Barco';

  @override
  String get rampStepOperation => 'Operação';

  @override
  String get rampStepSlot => 'Horário';

  @override
  String get rampStepReturn => 'Retorno';

  @override
  String get rampStepReview => 'Revisão';

  @override
  String get rampSelectRampTitle => 'Qual rampa você vai usar?';

  @override
  String get rampSelectBoatTitle => 'Qual barco?';

  @override
  String get rampOperationTitle => 'O que você quer fazer?';

  @override
  String get rampLaunchTitle => 'Descer o barco';

  @override
  String get rampLaunchDescription => 'Colocar o barco na água';

  @override
  String get rampHaulTitle => 'Subir o barco';

  @override
  String get rampHaulDescription => 'Tirar o barco da água';

  @override
  String get rampSlotTitle => 'Escolha o dia e o horário';

  @override
  String rampMinAdvanceHint(String value) {
    return 'Peça com pelo menos $value de antecedência';
  }

  @override
  String get rampNoSlotsForDay => 'Nenhum horário neste dia';

  @override
  String get rampSlotFull => 'Lotado';

  @override
  String get rampSlotBlocked => 'Bloqueado';

  @override
  String get rampSlotUnavailable => 'Indisponível';

  @override
  String rampSlotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vagas',
      one: '1 vaga',
    );
    return '$_temp0';
  }

  @override
  String get rampLoadSlotsError => 'Não foi possível carregar os horários.';

  @override
  String get rampReturnTitle => 'Vai subir o barco depois?';

  @override
  String get rampReturnToggle => 'Agendar a subida de volta';

  @override
  String get rampReturnDescription => 'A subida fica reservada junto com a descida, num pedido só.';

  @override
  String rampReturnAfter(String time) {
    return 'Horários a partir das $time';
  }

  @override
  String get rampReviewTitle => 'Confira seu pedido';

  @override
  String get rampReviewRamp => 'Rampa';

  @override
  String get rampReviewBoat => 'Barco';

  @override
  String get rampReviewOperation => 'Operação';

  @override
  String get rampReviewWhen => 'Quando';

  @override
  String get rampReviewReturn => 'Subida de volta';

  @override
  String get rampAutoConfirmInfo => 'Esta rampa confirma o pedido na hora.';

  @override
  String get rampPendingInfo => 'A marina vai analisar o pedido. Acompanhe o status em Meus agendamentos de rampa.';

  @override
  String get rampNotesHint => 'Observações para a marina (opcional)';

  @override
  String get rampContinue => 'Continuar';

  @override
  String get rampSubmit => 'Solicitar agendamento';

  @override
  String get rampBookingConfirmed => 'Agendamento confirmado';

  @override
  String get rampBookingRequested => 'Pedido enviado. Aguarde a aprovação da marina.';

  @override
  String get rampConflictError => 'Esse horário acabou de ser ocupado. Escolha outro.';

  @override
  String get rampCreateError => 'Não foi possível enviar o pedido. Tente novamente.';

  @override
  String get rampNoMarinaTitle => 'Você ainda não está vinculado a uma marina';

  @override
  String get rampNoMarinaDescription => 'Peça para sua marina liberar seu acesso no Estai.';

  @override
  String get rampNoRampsTitle => 'Nenhuma rampa disponível';

  @override
  String get rampNoRampsDescription => 'Sua marina ainda não liberou o agendamento de rampa pelo app.';

  @override
  String get rampLoadRampsError => 'Não foi possível carregar as rampas.';

  @override
  String get rampTabUpcoming => 'Próximos';

  @override
  String get rampTabHistory => 'Histórico';

  @override
  String get noRampSchedulesHistory => 'Nenhum agendamento no histórico';

  @override
  String get loadRampSchedulesError => 'Não foi possível carregar seus agendamentos.';

  @override
  String get rampReturnBadge => 'Retorno';

  @override
  String rampRejectionReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get cancelRampSchedule => 'Cancelar agendamento';

  @override
  String get cancelRampScheduleConfirm => 'Cancelar este agendamento?';

  @override
  String cancelRampScheduleAlsoReturn(String date) {
    return 'Cancelar também a subida de volta ($date)';
  }

  @override
  String get keepRampSchedule => 'Manter';

  @override
  String get cancelRampScheduleError => 'Não foi possível cancelar o agendamento. Tente novamente.';

  @override
  String get rampNewSchedule => 'Novo agendamento';

  @override
  String get marinaQuickActionsTitle => 'Ações rápidas';

  @override
  String get marinaActionServiceOrder => 'Pedir serviço';

  @override
  String get marinaTrackingTitle => 'Acompanhamento';

  @override
  String get marinaTrackingRamp => 'Rampa';

  @override
  String get marinaTrackingServices => 'Serviços';

  @override
  String get marinaSeeAllRampSchedules => 'Ver todos os agendamentos';

  @override
  String get marinaSeeAllServiceOrders => 'Ver todas as ordens';

  @override
  String get reminderChannelName => 'Lembretes';

  @override
  String get reminderChannelDescription => 'Lembretes de manutenção da embarcação';

  @override
  String get pushPermissionRationaleTitle => 'Ativar lembretes';

  @override
  String get pushPermissionRationaleBody => 'Para avisar quando uma manutenção estiver chegando, o Estai precisa enviar notificações para este aparelho.';

  @override
  String get pushPermissionBlockedTitle => 'Notificações bloqueadas';

  @override
  String get pushPermissionBlockedBody => 'As notificações do Estai estão desativadas. Ative nas configurações do aparelho para receber os lembretes.';

  @override
  String get notificationChannelPush => 'Push';

  @override
  String get notificationChannelEmail => 'E-mail';

  @override
  String get maintenanceStatusScheduled => 'Agendada';

  @override
  String get maintenanceStatusOverdue => 'Atrasada';

  @override
  String get maintenanceStatusDone => 'Concluída';

  @override
  String get maintenanceCategoryEngine => 'Motor';

  @override
  String get maintenanceCategoryHull => 'Casco';

  @override
  String get maintenanceCategoryElectrical => 'Elétrica';

  @override
  String get maintenanceCategoryPlumbing => 'Hidráulica';

  @override
  String get maintenanceCategorySafety => 'Segurança';

  @override
  String get maintenanceCategoryRigging => 'Mastreação';

  @override
  String get maintenanceCategoryElectronics => 'Eletrônicos';

  @override
  String get maintenanceCategoryOther => 'Outros';

  @override
  String get journalTitle => 'Diário da embarcação';

  @override
  String get journalEngineHours => 'Horímetro';

  @override
  String engineHoursValue(String hours) {
    return '$hours h';
  }

  @override
  String get journalEngineHoursUnknown => 'Não informado';

  @override
  String journalEngineHoursReadAt(String date) {
    return 'Atualizado em $date';
  }

  @override
  String get journalUpdateEngineHours => 'Atualizar';

  @override
  String get journalQuickActionsTitle => 'Ações rápidas';

  @override
  String get journalActionMaintenances => 'Manutenções';

  @override
  String get journalUpcomingMaintenancesTitle => 'Próximas manutenções';

  @override
  String get journalSeeAllMaintenances => 'Ver todas as manutenções';

  @override
  String journalOverdueAlert(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count manutenções atrasadas',
      one: '1 manutenção atrasada',
    );
    return '$_temp0';
  }

  @override
  String get journalLoadError => 'Não foi possível carregar o diário da embarcação.';

  @override
  String get engineHoursSheetTitle => 'Atualizar horímetro';

  @override
  String get engineHoursSheetHint => 'Informe a leitura atual do horímetro do motor.';

  @override
  String get engineHoursFieldLabel => 'Horas do motor';

  @override
  String get invalidNumber => 'Informe um número válido.';

  @override
  String engineHoursLowerThanCurrent(String hours) {
    return 'A leitura não pode ser menor que a atual ($hours h).';
  }

  @override
  String get engineHoursSaved => 'Horímetro atualizado.';

  @override
  String get engineHoursSaveError => 'Não foi possível salvar o horímetro.';

  @override
  String get maintenancesTitle => 'Manutenções';

  @override
  String get maintenanceTabUpcoming => 'Próximas';

  @override
  String get maintenanceTabHistory => 'Histórico';

  @override
  String get maintenanceNew => 'Nova manutenção';

  @override
  String get maintenanceEditTitle => 'Editar manutenção';

  @override
  String get noUpcomingMaintenances => 'Nenhuma manutenção agendada.';

  @override
  String get noMaintenancesHistory => 'Nenhuma manutenção concluída ainda.';

  @override
  String get loadMaintenancesError => 'Não foi possível carregar as manutenções.';

  @override
  String get maintenanceScheduleFirst => 'Agendar manutenção';

  @override
  String get maintenanceDueToday => 'Vence hoje';

  @override
  String maintenanceDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vence em $count dias',
      one: 'Vence amanhã',
    );
    return '$_temp0';
  }

  @override
  String maintenanceOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Atrasada há $count dias',
      one: 'Atrasada há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String maintenanceDueInHours(String hours) {
    return 'Faltam $hours h';
  }

  @override
  String maintenanceOverdueHours(String hours) {
    return 'Passou $hours h';
  }

  @override
  String maintenanceDueAtHours(String hours) {
    return 'Aos $hours h';
  }

  @override
  String maintenanceCompletedOn(String date) {
    return 'Concluída em $date';
  }

  @override
  String get maintenanceRecurringBadge => 'Recorrente';

  @override
  String get maintenanceComplete => 'Concluir';

  @override
  String get maintenanceCompleted => 'Manutenção concluída.';

  @override
  String get completeMaintenanceError => 'Não foi possível concluir a manutenção.';

  @override
  String get completeMaintenanceTitle => 'Concluir manutenção';

  @override
  String get completeMaintenanceDate => 'Data da conclusão';

  @override
  String get completeMaintenanceEngineHours => 'Horímetro na conclusão (opcional)';

  @override
  String get completeMaintenanceCost => 'Custo (opcional)';

  @override
  String get completeMaintenanceRecurringHint => 'Como é recorrente, a próxima ocorrência será agendada automaticamente.';

  @override
  String get maintenanceTitleLabel => 'Título';

  @override
  String get maintenanceTitleHint => 'Ex.: troca de óleo do motor';

  @override
  String get maintenanceTitleRequired => 'Informe o título.';

  @override
  String get maintenanceCategoryLabel => 'Categoria';

  @override
  String get maintenanceDescriptionLabel => 'Descrição (opcional)';

  @override
  String get maintenanceDueSection => 'Vencimento';

  @override
  String get maintenanceDueHint => 'Informe uma data, um horímetro ou os dois. Vale o que chegar primeiro.';

  @override
  String get maintenanceDueDateLabel => 'Data';

  @override
  String get maintenanceDueDateNone => 'Sem data';

  @override
  String get maintenanceDueEngineHoursLabel => 'Horímetro (h)';

  @override
  String get maintenanceMissingDue => 'Informe a data ou o horímetro do vencimento.';

  @override
  String get maintenanceRecurrenceTitle => 'Repetir';

  @override
  String get maintenanceRecurrenceSubtitle => 'Ao concluir, a próxima é agendada automaticamente.';

  @override
  String get maintenanceRecurrenceMonthsLabel => 'A cada (meses)';

  @override
  String get maintenanceRecurrenceHoursLabel => 'A cada (horas)';

  @override
  String get maintenanceRecurrenceRequired => 'Informe meses ou horas para repetir.';

  @override
  String get maintenanceProviderLabel => 'Oficina ou responsável (opcional)';

  @override
  String get maintenanceSave => 'Salvar manutenção';

  @override
  String get maintenanceSaved => 'Manutenção salva.';

  @override
  String get saveMaintenanceError => 'Não foi possível salvar a manutenção.';

  @override
  String get maintenanceInvalidError => 'Confira os dados da manutenção.';

  @override
  String get deleteMaintenance => 'Excluir manutenção';

  @override
  String get deleteMaintenanceConfirm => 'Esta manutenção e seus lembretes serão removidos.';

  @override
  String get deleteMaintenanceError => 'Não foi possível excluir a manutenção.';

  @override
  String get reminderTitle => 'Lembrete';

  @override
  String get reminderSubtitle => 'Enviado pela Estai antes do vencimento.';

  @override
  String get reminderDaysBeforeLabel => 'Avisar antes';

  @override
  String reminderDaysOption(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
      zero: 'No dia',
    );
    return '$_temp0';
  }

  @override
  String get reminderHoursBeforeLabel => 'Avisar antes (horímetro)';

  @override
  String get reminderChannelsLabel => 'Enviar por';

  @override
  String get notificationSettings => 'Notificações';

  @override
  String get notificationPrefsDescription => 'Os lembretes de manutenção e alertas são enviados pela Estai pelos canais que você ativar.';

  @override
  String get notificationPrefsPush => 'Notificações push';

  @override
  String get notificationPrefsPushSubtitle => 'No celular, mesmo com o app fechado.';

  @override
  String get notificationPrefsEmail => 'E-mail';

  @override
  String notificationPrefsEmailSubtitle(String email) {
    return 'Enviado para $email';
  }

  @override
  String get notificationPrefsEmailSubtitleNoEmail => 'Enviado para o e-mail da sua conta.';

  @override
  String get notificationPrefsSystemBlocked => 'As notificações estão desativadas neste aparelho. Permita para receber os lembretes por push.';

  @override
  String get notificationPrefsAllow => 'Permitir notificações';

  @override
  String get notificationPrefsSendTest => 'Enviar notificação de teste';

  @override
  String get notificationPrefsTestSent => 'Notificação de teste enviada.';

  @override
  String get notificationPrefsTestError => 'Não foi possível enviar a notificação de teste.';

  @override
  String get notificationPrefsLoadError => 'Não foi possível carregar suas preferências.';

  @override
  String get notificationPrefsSaveError => 'Não foi possível salvar suas preferências.';

  @override
  String get maintenanceAlreadyDone => 'Já realizada';

  @override
  String get maintenanceAlreadyDoneSubtitle => 'Registre uma manutenção que já foi feita.';

  @override
  String get maintenanceCompletionSection => 'Realização';

  @override
  String get maintenanceRecurrenceSubtitleCompleted => 'A próxima é agendada a partir da data de realização.';

  @override
  String get maintenanceDetailsTitle => 'Manutenção concluída';

  @override
  String get maintenanceDetailsInfoSection => 'Detalhes';

  @override
  String get maintenanceDetailsEngineHours => 'Horímetro na conclusão';

  @override
  String get maintenanceDetailsCost => 'Custo';

  @override
  String get maintenanceDetailsNotes => 'Observações';

  @override
  String get maintenanceDetailsProvider => 'Oficina ou responsável';

  @override
  String get maintenanceDetailsDescription => 'Descrição';

  @override
  String get maintenanceDetailsOriginalDue => 'Vencimento previsto';

  @override
  String get maintenanceDetailsRecurrence => 'Repetição';

  @override
  String get maintenanceDetailsNotInformed => 'Não informado';

  @override
  String maintenanceRecurrenceEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A cada $count meses',
      one: 'A cada mês',
    );
    return '$_temp0';
  }

  @override
  String maintenanceRecurrenceEveryHours(String hours) {
    return 'A cada $hours h';
  }

  @override
  String get logbookTypeTrip => 'Viagem';

  @override
  String get logbookTypeNote => 'Nota';

  @override
  String get logbookTypeAnchorage => 'Fundeio';

  @override
  String get logbookTypeIncident => 'Ocorrência';

  @override
  String get logbookTypeEvent => 'Evento';

  @override
  String get logbookTitle => 'Diário de bordo';

  @override
  String get logbookFilterAll => 'Todos';

  @override
  String get logbookNewEntry => 'Nova entrada';

  @override
  String get logbookEditEntry => 'Editar entrada';

  @override
  String get noLogbookEntries => 'Nenhuma entrada no diário de bordo ainda.';

  @override
  String get loadLogbookError => 'Não foi possível carregar o diário de bordo.';

  @override
  String get logbookTypeLabel => 'Tipo';

  @override
  String get logbookTitleLabel => 'Título';

  @override
  String get logbookTitleRequired => 'Informe o título.';

  @override
  String get logbookDateLabel => 'Data';

  @override
  String get logbookTimeLabel => 'Hora';

  @override
  String get logbookUseCurrentPosition => 'Registrar posição atual';

  @override
  String get logbookUseCurrentPositionSubtitle => 'Salva onde o barco está agora.';

  @override
  String get logbookPositionUnavailable => 'Posição atual indisponível. Verifique o GPS.';

  @override
  String get logbookSave => 'Salvar entrada';

  @override
  String get logbookSaved => 'Entrada salva.';

  @override
  String get saveLogbookEntryError => 'Não foi possível salvar a entrada.';

  @override
  String get logbookInvalidError => 'Confira os dados da entrada.';

  @override
  String get deleteLogbookEntry => 'Excluir entrada';

  @override
  String get deleteLogbookEntryConfirm => 'Esta entrada será removida do diário de bordo.';

  @override
  String get deleteLogbookEntryError => 'Não foi possível excluir a entrada.';

  @override
  String get logbookDetailsInfoSection => 'Detalhes';

  @override
  String get logbookDetailsTripSection => 'Navegação';

  @override
  String get logbookTripMapExpand => 'Expandir mapa';

  @override
  String get logbookTripMapTitle => 'Trajeto';

  @override
  String get logbookDetailsDate => 'Data e hora';

  @override
  String get logbookDetailsDuration => 'Duração';

  @override
  String get logbookDetailsDistance => 'Distância';

  @override
  String get logbookDetailsAvgSpeed => 'Velocidade média';

  @override
  String get logbookDetailsMaxSpeed => 'Velocidade máxima';

  @override
  String get logbookDetailsEngineHoursEnd => 'Horímetro ao final';

  @override
  String get logbookDetailsPassengers => 'Passageiros';

  @override
  String get logbookDetailsPosition => 'Posição';

  @override
  String get logbookDetailsNotes => 'Observações';

  @override
  String distanceNmValue(String value) {
    return '$value NM';
  }

  @override
  String speedKnValue(String value) {
    return '$value kn';
  }

  @override
  String durationHoursMinutes(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String durationMinutesValue(String minutes) {
    return '$minutes min';
  }

  @override
  String logbookTopSpeed(String value) {
    return 'máx $value kn';
  }

  @override
  String get journalRecentLogbookTitle => 'Últimas entradas';

  @override
  String get journalSeeLogbook => 'Ver diário de bordo';

  @override
  String get journalNoLogbookEntries => 'As viagens que você salvar ao encerrar a navegação aparecem aqui.';

  @override
  String get tripSaveTitle => 'Salvar viagem no diário';

  @override
  String get tripSaveSubtitle => 'Registre esta navegação no diário de bordo da embarcação.';

  @override
  String get tripBoatLabel => 'Embarcação';

  @override
  String tripDefaultTitle(String date) {
    return 'Navegação de $date';
  }

  @override
  String get tripEngineHoursEndLabel => 'Horímetro ao final (opcional)';

  @override
  String get tripPassengersLabel => 'Passageiros (opcional)';

  @override
  String get tripSave => 'Salvar no diário';

  @override
  String get tripDiscard => 'Descartar';

  @override
  String get tripSaved => 'Viagem salva no diário de bordo.';

  @override
  String get tripQueued => 'Sem conexão. A viagem será enviada quando houver internet.';

  @override
  String get tripSaveError => 'Não foi possível salvar a viagem.';

  @override
  String get settingsSectionNavigation => 'Navegação';

  @override
  String get settingsSectionMaps => 'Mapas e cartas';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get boatRemindersTitle => 'Lembretes';

  @override
  String get boatReminderNew => 'Novo lembrete';

  @override
  String get boatReminderEditTitle => 'Editar lembrete';

  @override
  String get boatReminderTabPending => 'Pendentes';

  @override
  String get boatReminderTabDone => 'Feitos';

  @override
  String get boatReminderStatusPending => 'Pendente';

  @override
  String get boatReminderStatusDone => 'Feito';

  @override
  String get noPendingBoatReminders => 'Nenhum lembrete pendente.';

  @override
  String get noDoneBoatReminders => 'Nenhum lembrete feito ainda.';

  @override
  String get loadBoatRemindersError => 'Não foi possível carregar os lembretes.';

  @override
  String get boatReminderTitleLabel => 'Título';

  @override
  String get boatReminderTitleHint => 'Ex.: Renovar a vaga na marina';

  @override
  String get boatReminderTitleRequired => 'Informe o título';

  @override
  String get boatReminderDateLabel => 'Data';

  @override
  String get boatReminderDatePlaceholder => 'Escolher data';

  @override
  String get boatReminderDateRequired => 'Escolha a data do lembrete';

  @override
  String get boatReminderDoneAtLabel => 'Feito em';

  @override
  String get boatReminderNotesLabel => 'Observações';

  @override
  String boatReminderDoneOn(String date) {
    return 'Feito em $date';
  }

  @override
  String get boatReminderDueToday => 'Hoje';

  @override
  String boatReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Em $count dias',
      one: 'Amanhã',
    );
    return '$_temp0';
  }

  @override
  String boatReminderOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Atrasado há $count dias',
      one: 'Atrasado há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String boatReminderEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Repete a cada $count meses',
      one: 'Repete todo mês',
    );
    return '$_temp0';
  }

  @override
  String get boatReminderRecurrenceTitle => 'Repetir';

  @override
  String get boatReminderRecurrenceSubtitle => 'Ao marcar como feito, o próximo é criado automaticamente';

  @override
  String get boatReminderRecurrenceMonthsLabel => 'A cada quantos meses';

  @override
  String get boatReminderMarkDone => 'Marcar como feito';

  @override
  String get boatReminderMarkDoneConfirm => 'O lembrete vai para Feitos.';

  @override
  String boatReminderMarkDoneRecurringConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'O lembrete vai para Feitos e o próximo é criado $count meses depois da data deste.',
      one: 'O lembrete vai para Feitos e o próximo é criado 1 mês depois da data deste.',
    );
    return '$_temp0';
  }

  @override
  String get boatReminderMarkedDone => 'Lembrete marcado como feito';

  @override
  String get markBoatReminderDoneError => 'Não foi possível marcar o lembrete como feito.';

  @override
  String get boatReminderSave => 'Salvar lembrete';

  @override
  String get boatReminderSaved => 'Lembrete salvo';

  @override
  String get boatReminderInvalidError => 'Confira os dados do lembrete.';

  @override
  String get saveBoatReminderError => 'Não foi possível salvar o lembrete. Tente novamente.';

  @override
  String get deleteBoatReminder => 'Excluir lembrete';

  @override
  String get deleteBoatReminderConfirm => 'O lembrete e os avisos programados serão excluídos.';

  @override
  String get deleteBoatReminderError => 'Não foi possível excluir o lembrete.';

  @override
  String get documentStatusExpired => 'Vencido';

  @override
  String get documentStatusExpiringSoon => 'Vencendo';

  @override
  String get documentStatusValid => 'Em dia';

  @override
  String get documentStatusNoExpiry => 'Sem validade';

  @override
  String get documentTypeRegistration => 'Inscrição (TIE/TIEM)';

  @override
  String get documentTypeInsurance => 'Seguro';

  @override
  String get documentTypeInspection => 'Vistoria';

  @override
  String get documentTypeRadioLicense => 'Licença de rádio';

  @override
  String get documentTypeFireExtinguisher => 'Extintor';

  @override
  String get documentTypeFlares => 'Sinalizadores';

  @override
  String get documentTypeLifeJackets => 'Coletes salva-vidas';

  @override
  String get documentTypeLifeRaft => 'Balsa salva-vidas';

  @override
  String get documentTypeOther => 'Outro';

  @override
  String get documentTypeNauticalLicense => 'Habilitação náutica (CHA)';

  @override
  String get documentTypeRadioOperatorCertificate => 'Certificado de operador de rádio';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get myDocumentsTitle => 'Meus documentos';

  @override
  String get myDocumentsSubtitle => 'Habilitação náutica e certificados';

  @override
  String get documentNew => 'Novo documento';

  @override
  String get documentEditTitle => 'Editar documento';

  @override
  String get documentDetailsTitle => 'Documento';

  @override
  String get documentsAttentionSection => 'Atenção';

  @override
  String get documentsOthersSection => 'Demais documentos';

  @override
  String get noBoatDocuments => 'Nenhum documento cadastrado. Guarde aqui TIE, seguro, vistoria e itens de segurança com validade.';

  @override
  String get noPersonalDocuments => 'Nenhum documento cadastrado. Guarde aqui sua habilitação náutica e certificados.';

  @override
  String get loadDocumentsError => 'Não foi possível carregar os documentos.';

  @override
  String get loadDocumentError => 'Não foi possível carregar o documento.';

  @override
  String get documentTypeLabel => 'Tipo';

  @override
  String get documentTitleLabel => 'Nome (opcional)';

  @override
  String get documentNumberLabel => 'Número';

  @override
  String get documentIssuerLabel => 'Emissor';

  @override
  String get documentIssuerHint => 'Ex.: Capitania dos Portos, seguradora';

  @override
  String get documentDatesSection => 'Validade';

  @override
  String get documentExpiresAtLabel => 'Vence em';

  @override
  String get documentIssuedAtLabel => 'Emitido em';

  @override
  String get documentNoExpiryLabel => 'Sem validade';

  @override
  String get documentDateNotInformed => 'Não informado';

  @override
  String get documentInvalidDatesError => 'A validade não pode ser antes da emissão';

  @override
  String documentExpiresOn(String date) {
    return 'Vence em $date';
  }

  @override
  String get documentExpiresToday => 'vence hoje';

  @override
  String documentExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'faltam $count dias',
      one: 'falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String documentExpiredDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vencido há $count dias',
      one: 'vencido há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get documentReminderLabel => 'Aviso';

  @override
  String documentReminderDaysBefore(String days) {
    return '$days dias antes';
  }

  @override
  String get documentReminderOff => 'Desligado';

  @override
  String get documentDetailsInfoSection => 'Dados';

  @override
  String get documentNotesSection => 'Observações';

  @override
  String get documentAttachmentsSection => 'Anexos';

  @override
  String get documentSave => 'Salvar documento';

  @override
  String get documentSaved => 'Documento salvo';

  @override
  String get documentInvalidError => 'Confira os dados do documento.';

  @override
  String get saveDocumentError => 'Não foi possível salvar o documento. Tente novamente.';

  @override
  String get documentAttachmentsFailed => 'O documento foi salvo, mas alguns anexos não foram enviados. Toque em Tentar novamente.';

  @override
  String get deleteDocument => 'Excluir documento';

  @override
  String get deleteDocumentConfirm => 'O documento, os anexos e os avisos programados serão excluídos.';

  @override
  String get deleteDocumentError => 'Não foi possível excluir o documento.';

  @override
  String get attachmentAdd => 'Adicionar';

  @override
  String get attachmentAddTitle => 'Adicionar anexo';

  @override
  String get attachmentSourceCamera => 'Tirar foto';

  @override
  String get attachmentSourceGallery => 'Escolher da galeria';

  @override
  String get attachmentSourcePdf => 'Arquivo PDF';

  @override
  String attachmentsHint(int count, int size) {
    return 'Fotos ou PDF, até $count arquivos de $size MB.';
  }

  @override
  String get attachmentLimitReached => 'Limite de anexos atingido.';

  @override
  String get attachmentTooLarge => 'Arquivo maior que o limite.';

  @override
  String get attachmentUnsupported => 'Tipo de arquivo não aceito. Use foto ou PDF.';

  @override
  String attachmentUploadingProgress(int current, int total) {
    return 'Enviando anexo $current de $total…';
  }

  @override
  String get attachmentOpenError => 'Não foi possível abrir o anexo.';

  @override
  String get journalRemindersTitle => 'Lembretes';

  @override
  String get journalNoReminders => 'Nenhum lembrete pendente.';

  @override
  String get journalSeeReminders => 'Ver lembretes';

  @override
  String journalDocumentsAlert(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos vencidos ou vencendo',
      one: '1 documento vencido ou vencendo',
    );
    return '$_temp0';
  }

  @override
  String get checklistsTitle => 'Checklists';

  @override
  String get checklistsSubtitle => 'Antes e depois de navegar';

  @override
  String get checklistsEmpty => 'Nenhum checklist ainda. Crie um para conferir o barco antes de sair ou ao voltar.';

  @override
  String get checklistNew => 'Novo checklist';

  @override
  String get checklistEdit => 'Editar checklist';

  @override
  String get checklistSave => 'Salvar checklist';

  @override
  String get checklistSaved => 'Checklist salvo';

  @override
  String get checklistSaveError => 'Não foi possível salvar o checklist. Tente novamente.';

  @override
  String get checklistDelete => 'Excluir checklist';

  @override
  String get checklistDeleteConfirm => 'Este checklist será excluído do aparelho. Deseja continuar?';

  @override
  String get checklistNameLabel => 'Nome';

  @override
  String get checklistNameHint => 'Ex.: Antes de sair';

  @override
  String get checklistNameRequired => 'Informe um nome';

  @override
  String get checklistTriggerLabel => 'Quando aparece';

  @override
  String get checklistTriggerBefore => 'Antes de navegar';

  @override
  String get checklistTriggerAfter => 'Depois de navegar';

  @override
  String get checklistTriggerNone => 'Sem vínculo';

  @override
  String get checklistTriggerBeforeDescription => 'Abre sozinho quando você toca em Navegar, antes de a navegação começar.';

  @override
  String get checklistTriggerAfterDescription => 'Abre sozinho quando você finaliza a navegação.';

  @override
  String get checklistTriggerNoneDescription => 'Não abre sozinho. Use quando quiser, por esta tela.';

  @override
  String get checklistItemsSection => 'Itens';

  @override
  String get checklistItemHint => 'Descreva o item';

  @override
  String get checklistAddItem => 'Adicionar item';

  @override
  String get checklistRemoveItem => 'Remover item';

  @override
  String get checklistItemsLimit => 'Limite de itens atingido';

  @override
  String get checklistNoItemsError => 'Adicione pelo menos um item.';

  @override
  String checklistItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get checklistRunBeforeTitle => 'Antes de navegar';

  @override
  String get checklistRunAfterTitle => 'Depois de navegar';

  @override
  String checklistRunProgress(int checked, int total) {
    return '$checked de $total';
  }

  @override
  String get checklistRunComplete => 'Tudo conferido';

  @override
  String get checklistUncheckAll => 'Desmarcar tudo';

  @override
  String get checklistStartNavigation => 'Iniciar navegação';

  @override
  String get checklistSkip => 'Pular checklist';

  @override
  String get checklistDone => 'Concluir';

  @override
  String get checklistMissingItemsTitle => 'Itens não conferidos';

  @override
  String checklistMissingItemsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count itens. Iniciar a navegação mesmo assim?',
      one: 'Falta 1 item. Iniciar a navegação mesmo assim?',
    );
    return '$_temp0';
  }

  @override
  String get checklistDefaultBeforeName => 'Antes de sair';

  @override
  String get checklistDefaultBeforeFuel => 'Combustível suficiente para a saída';

  @override
  String get checklistDefaultBeforeOil => 'Nível de óleo do motor';

  @override
  String get checklistDefaultBeforeDrainPlug => 'Bujão do casco colocado';

  @override
  String get checklistDefaultBeforeBattery => 'Bateria e luzes de navegação';

  @override
  String get checklistDefaultBeforeLifeJackets => 'Coletes salva-vidas para todos a bordo';

  @override
  String get checklistDefaultBeforeSafety => 'Extintor e sinalizadores';

  @override
  String get checklistDefaultBeforeWeather => 'Previsão do tempo e do mar conferida';

  @override
  String get checklistDefaultBeforeFloatPlan => 'Avisar alguém do plano de navegação';

  @override
  String get checklistDefaultAfterName => 'Ao voltar';

  @override
  String get checklistDefaultAfterFlushEngine => 'Lavar o motor com água doce';

  @override
  String get checklistDefaultAfterFuelValve => 'Fechar o registro de combustível';

  @override
  String get checklistDefaultAfterMainSwitch => 'Desligar a chave geral';

  @override
  String get checklistDefaultAfterTrash => 'Levar o lixo de bordo';

  @override
  String get checklistDefaultAfterLines => 'Conferir cabos e defensas';

  @override
  String get checklistDefaultAfterCover => 'Colocar a capa';

  @override
  String deleteRouteConfirm(String name) {
    return 'A rota \"$name\" será apagada. Deseja continuar?';
  }
}
