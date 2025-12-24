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
  String get deleteRoute => 'Deletar Rota';

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
}
