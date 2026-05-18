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
  String get improvementsAndSuggestions => 'Feedback';

  @override
  String get feedbackSuggestionPlaceholder => 'Share your suggestion or improvement (max 500 characters)';

  @override
  String get feedbackSentSuccess => 'Thank you! Your feedback was sent.';

  @override
  String get feedbackError => 'Could not send feedback. Try again later.';

  @override
  String feedbackMaxCharacters(String current, String max) {
    return '$current/$max';
  }

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
  String get navigationPermission => 'GPS Permissions';

  @override
  String get navigationPermissionDescription => 'View the current location permission status and change it in system settings if needed.';

  @override
  String get locationPermissionAlways => 'Always allow';

  @override
  String get locationPermissionAlwaysSubtitle => 'Location available in foreground and background.';

  @override
  String get locationPermissionWhileInUse => 'While using the app';

  @override
  String get locationPermissionWhileInUseSubtitle => 'Enable \"Always\" to track during navigation.';

  @override
  String get openAppSettings => 'Open settings';

  @override
  String get locationPermissionChecking => 'Checking...';

  @override
  String get locationPermissionCheckingSubtitle => 'Please wait while we check.';

  @override
  String get locationPermissionDeniedSubtitle => 'The app cannot access your location.';

  @override
  String get locationPermissionDeniedForeverSubtitle => 'You denied the permission. Change it in system settings.';

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

  @override
  String get weatherForecast => 'Weather Forecast';

  @override
  String get errorLoadingForecast => 'Error loading forecast';

  @override
  String get noForecastAvailable => 'No forecast available';

  @override
  String get marine => 'Marine';

  @override
  String get weather => 'Weather';

  @override
  String get waveHeight => 'Height';

  @override
  String get wavePeriod => 'Period';

  @override
  String get waveDirection => 'Direction';

  @override
  String get temperature => 'Temp';

  @override
  String get dewPoint => 'Dew Point';

  @override
  String get windSpeed => 'Wind';

  @override
  String get windDirection => 'Direction';

  @override
  String get windGusts => 'Gusts';

  @override
  String get pressure => 'Pressure';

  @override
  String get humidity => 'Humidity';

  @override
  String get precipitation => 'Rain';

  @override
  String get precipitationProbability => 'Rain Prob.';

  @override
  String get loginRequiredForForecast => 'To access weather forecast, you need to be logged in.';

  @override
  String get loginRequiredForAction => 'To perform this action you need to be logged in.';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get addWeatherPin => 'Add Weather Pin';

  @override
  String get weatherPinsList => 'Weather';

  @override
  String get pinName => 'Pin Name';

  @override
  String get enterPinName => 'Enter pin name';

  @override
  String get deletePin => 'Delete';

  @override
  String get editPinName => 'Edit Name';

  @override
  String get noPinsAdded => 'No pins added';

  @override
  String get addingPinMode => 'Adding Mode Active';

  @override
  String get tapMapToAddPin => 'Hold on map to add';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get save => 'Save';

  @override
  String confirmDeletePin(String pinName) {
    return 'Are you sure you want to remove the pin \"$pinName\"?';
  }

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDescription => 'Permanently delete your account and all associated data';

  @override
  String get deleteAccountWarning => 'This action cannot be undone. All your data will be permanently lost.';

  @override
  String get deleteAccountConfirmTitle => 'Confirm Account Deletion';

  @override
  String get deleteAccountConfirmMessage => 'Are you sure you want to delete your account? This action is irreversible and will remove:';

  @override
  String get deleteAccountConfirmItems => '• Your authentication account\n• All saved routes\n• All associated data';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String deleteAccountError(String error) {
    return 'Error deleting account: $error';
  }

  @override
  String get deleteAccountRequiresRecentLogin => 'To delete your account, you need to sign in again for security.';

  @override
  String get typeDeleteToConfirm => 'Type DELETE to confirm';

  @override
  String get backgroundLocationDisclosureTitle => 'Background Location Access';

  @override
  String get backgroundLocationDisclosureBody => 'This app collects your location data to enable route tracking and navigation even when the app is running in the background or the screen is off.\n\nThis allows you to:\n• Track your route during navigation without keeping the screen on\n• Receive accurate position updates continuously\n\nYour location data is only used for navigation and is not shared with third parties.';

  @override
  String get backgroundLocationAllow => 'Allow';

  @override
  String get backgroundLocationNotNow => 'Not now';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get signalKConfiguration => 'SignalK Configuration';

  @override
  String get signalKConfigurationDescription => 'Configure your local SignalK server to receive boat navigation data.';

  @override
  String get signalKHost => 'Server address';

  @override
  String get signalKHostHint => 'e.g. este.signalk.local:3000';

  @override
  String get signalKHostRequired => 'Please enter the server address';

  @override
  String get signalKToken => 'Access token';

  @override
  String get signalKTokenHint => 'Paste the token generated in SignalK';

  @override
  String get signalKConfigurationSaved => 'SignalK configuration saved';

  @override
  String get signalKClearConfiguration => 'Clear configuration';

  @override
  String get rasterCharts => 'Raster Charts (BSB/KAP)';

  @override
  String get rasterChartsEmptyTitle => 'No charts imported';

  @override
  String get rasterChartsEmptyMessage => 'Import a raster chart .zip (BSB/KAP) from the Brazilian Navy to display it over the map.';

  @override
  String get rasterChartImport => 'Import chart';

  @override
  String get rasterChartImporting => 'Importing chart...';

  @override
  String get rasterChartImportSuccess => 'Chart imported successfully';

  @override
  String get rasterChartRemoveTitle => 'Remove chart';

  @override
  String rasterChartRemoveMessage(String name) {
    return 'Are you sure you want to remove \"$name\"?';
  }

  @override
  String get remove => 'Remove';

  @override
  String rasterChartCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'charts',
      one: 'chart',
    );
    return '$_temp0';
  }

  @override
  String rasterChartProjectionWarning(String projection) {
    return 'Projection $projection not fully supported — approximate alignment.';
  }

  @override
  String get anchorAlarm => 'Anchor Alarm';

  @override
  String get anchorAlarmActive => 'Anchor alarm active';

  @override
  String get anchorAlarmSetTitle => 'Set Anchor Alarm';

  @override
  String get anchorAlarmRadius => 'Safety radius (meters)';

  @override
  String get anchorAlarmRadiusHint => 'e.g. 50';

  @override
  String get anchorAlarmRadiusError => 'Enter a value between 1 and 9999';

  @override
  String get anchorAlarmUseCurrentPosition => 'Use current position';

  @override
  String get anchorAlarmTapToSet => 'Tap the map to place the anchor';

  @override
  String get anchorAlarmTriggered => 'Anchor Dragged!';

  @override
  String get anchorAlarmTriggeredMessage => 'You left the safety radius defined for the anchor.';

  @override
  String get anchorAlarmDisable => 'Disable Alarm';

  @override
  String get anchorAlarmDismiss => 'Dismiss';

  @override
  String get anchorAlarmNotificationRationaleTitle => 'Notification Permission';

  @override
  String get anchorAlarmNotificationRationaleBody => 'The anchor alarm needs to send notifications to alert you when the anchor drags, even when the app is in the background or the screen is off.';

  @override
  String get anchorAlarmNotificationBlockedTitle => 'Notifications Blocked';

  @override
  String get anchorAlarmNotificationBlockedBody => 'Notifications are blocked for this app. To receive the anchor alarm, enable notifications in your system settings.';

  @override
  String get notNow => 'Not now';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Estai';

  @override
  String get onboardingWelcomeDescription => 'A quick tour of what you can do from the map screen.';

  @override
  String get onboardingRoutesTitle => 'Plan your routes';

  @override
  String get onboardingRoutesDescription => 'Start a new route from the actions menu, long-press the map to add waypoints and save it for future trips.';

  @override
  String get onboardingRasterChartsTitle => 'Brazilian Navy raster charts';

  @override
  String get onboardingRasterChartsDescription => 'Import official BSB/KAP nautical charts from the Brazilian Navy and overlay them on your map for accurate navigation.';

  @override
  String get onboardingWeatherTitle => 'Weather forecast';

  @override
  String get onboardingWeatherDescription => 'Add weather pins along your route to check marine forecast, wind, waves and rain in advance.';

  @override
  String get onboardingAnchorAlarmTitle => 'Anchor alarm';

  @override
  String get onboardingAnchorAlarmDescription => 'Define a safety radius after anchoring and get notified if the boat drifts beyond it, even with the screen off.';

  @override
  String get onboardingMapsTitle => 'Custom maps';

  @override
  String get onboardingMapsDescription => 'Pick additional map layers from the catalog and download them for offline use during your trips.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingPrevious => 'Back';

  @override
  String get onboardingFinish => 'Get started';

  @override
  String onboardingStepProgress(String current, String total) {
    return '$current of $total';
  }
}
