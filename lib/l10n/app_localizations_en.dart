// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Estai - Map';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get nameMinLength => 'Name must be at least 2 characters';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get enter => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account. ';

  @override
  String get createAccount => 'Create account';

  @override
  String get continueWithoutLogin => 'Continue without login';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account. ';

  @override
  String get signIn => 'Sign in';

  @override
  String get recoverPassword => 'Recover Password';

  @override
  String get forgotPasswordTitle => 'Forgot your password?';

  @override
  String get forgotPasswordDescription => 'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get passwordResetEmailSent => 'Password reset email sent! Check your inbox.';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get notAuthenticated => 'You are not authenticated.';

  @override
  String get logout => 'Logout';

  @override
  String minimumDistance(String value) {
    return 'Minimum distance: $value m';
  }

  @override
  String get minimumDistanceDescription => 'Defines the minimum distance in meters that the user needs to travel for a new point to be added to the tracked route during navigation. Higher values result in routes with fewer points, while lower values create more detailed routes.';

  @override
  String meters(String value) {
    return '$value m';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get locationServicesDisabled => 'Location services are disabled.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionDeniedForever => 'Location permission denied permanently.';

  @override
  String errorGettingLocation(String error) {
    return 'Error getting location: $error';
  }

  @override
  String errorUpdatingLocation(String error) {
    return 'Error updating location: $error';
  }

  @override
  String get finishNavigation => 'Finish Navigation';

  @override
  String get finishNavigationQuestion => 'Do you really want to finish navigation?';

  @override
  String get cancel => 'Cancel';

  @override
  String get finish => 'Finish';

  @override
  String get unlockCamera => 'Unlock camera';

  @override
  String get lockCamera => 'Lock camera to position';

  @override
  String get hideCustomTiles => 'Hide custom tiles';

  @override
  String get showCustomTiles => 'Show custom tiles';

  @override
  String get navigate => 'Navigate';

  @override
  String get newRoute => 'New Route';

  @override
  String get tides => 'Tides';

  @override
  String get adjustments => 'Settings';

  @override
  String get addPoint => 'Add point?';

  @override
  String get confirmPoint => 'Confirm point';

  @override
  String get tideTables => 'Tide Tables';

  @override
  String get noTideTablesFound => 'No tide tables found';

  @override
  String errorLoadingTideTables(String error) {
    return 'Error loading tide tables: $error';
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
  String get time => 'TIME';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get userDisabled => 'User disabled';

  @override
  String get tooManyRequests => 'Too many attempts. Try again later';

  @override
  String loginError(String message) {
    return 'Error signing in: $message';
  }

  @override
  String get weakPassword => 'Password too weak';

  @override
  String get emailAlreadyInUse => 'Email already in use';

  @override
  String signUpError(String message) {
    return 'Error creating account: $message';
  }

  @override
  String get emailNotFound => 'Email not found';

  @override
  String sendEmailError(String message) {
    return 'Error sending email: $message';
  }

  @override
  String logoutError(String error) {
    return 'Error logging out: $error';
  }

  @override
  String get navigationSettings => 'Navigation Settings';

  @override
  String get navigationSettingsDescription => 'Configure navigation and tracking options';

  @override
  String get userAccount => 'User Account';

  @override
  String get manageAccountInfo => 'Manage your account information';

  @override
  String get logoutAccount => 'Logout';

  @override
  String get logoutAccountDescription => 'You will need to log in again';

  @override
  String get loginToAccessInfo => 'Log in to access your information';

  @override
  String get myRoutes => 'My Routes';

  @override
  String get routesList => 'Routes List';

  @override
  String get noRoutesFound => 'No routes found';

  @override
  String get routeName => 'Route Name';

  @override
  String get saveRoute => 'Save Route';

  @override
  String get deleteRoute => 'Delete Route';

  @override
  String get routeSaved => 'Route saved successfully';

  @override
  String get errorSavingRoute => 'Error saving route';

  @override
  String get editRouteName => 'Edit route name';

  @override
  String get pleaseEnterRouteName => 'Please enter a route name';

  @override
  String get loadRoute => 'Load Route';

  @override
  String get points => 'points';

  @override
  String get confirmRoute => 'Confirm Route';

  @override
  String get startNavigationWithRoute => 'Start Navigation';

  @override
  String get routeDetails => 'Route Details';

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get maps => 'Maps';

  @override
  String get mapsSelectionDescription => 'Select the maps you want to display on the main screen. Selected maps will be overlaid on the base map.';

  @override
  String get mapsSelectionPerformanceWarning => 'Note: Selecting many maps may impact app performance and increase data usage.';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDescription => 'Enable dark mode for custom maps to reduce eye strain in low-light conditions.';

  @override
  String get saveRouteForReuse => 'Save route for reuse';

  @override
  String get saveRouteForReuseDescription => 'Save this route to use it again in the future';

  @override
  String get confirm => 'Confirm';

  @override
  String get plannedRoute => 'Planned Route';

  @override
  String get errorLoadingMaps => 'Unable to fetch the maps list now. Check your internet connection and try again later.';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String googleSignInError(String message) {
    return 'Error signing in with Google: $message';
  }

  @override
  String get googleSignInCancelled => 'Google sign in cancelled';

  @override
  String googleSignInFailed(String error) {
    return 'Failed to sign in with Google: $error';
  }

  @override
  String get networkError => 'Network error. Check your internet connection.';

  @override
  String get accountExistsWithDifferentCredential => 'An account already exists with the same email address, but using a different sign-in method.';

  @override
  String get operationNotAllowed => 'Google sign in is not enabled. Please contact support.';

  @override
  String get signInWithApple => 'Continue with Apple';

  @override
  String appleSignInError(String message) {
    return 'Error signing in with Apple: $message';
  }

  @override
  String get appleSignInCancelled => 'Apple sign in cancelled';

  @override
  String appleSignInFailed(String error) {
    return 'Failed to sign in with Apple: $error';
  }

  @override
  String get tideDataDisclaimer => 'Official tide data is the responsibility of the Brazilian Navy.';

  @override
  String get tideExternalBrowserNotice => 'When selecting one of the tables, you will be redirected to the official Brazilian Navy website';
}
