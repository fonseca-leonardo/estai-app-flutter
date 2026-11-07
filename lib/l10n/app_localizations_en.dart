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
  String get resumeNavigationTitle => 'Resume navigation?';

  @override
  String resumeNavigationQuestion(String duration) {
    return 'We detected an ongoing navigation started $duration ago. Do you want to resume?';
  }

  @override
  String get resume => 'Resume';

  @override
  String get discard => 'Discard';

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
  String get anchorAlarmDisableConfirmTitle => 'Disable the anchor alarm?';

  @override
  String get anchorAlarmDisableConfirmMessage => 'You will no longer be warned if the anchor drags.';

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
  String get onboardingNavigationTitle => 'Start navigation';

  @override
  String get onboardingNavigationDescription => 'Begin navigation to track your trip in real time: stay on course, monitor distance, speed and your path on the map.';

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
  String get onboardingBoatsTitle => 'My boats';

  @override
  String get onboardingBoatsDescription => 'Register your boats and keep track of everything in one place: a logbook with your saved trips, maintenance, engine hours and reminders by push or email.';

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

  @override
  String get myBoats => 'My Boats';

  @override
  String get myBoatsTooltip => 'My Boats';

  @override
  String get addBoat => 'Add Boat';

  @override
  String get noBoatsFound => 'No boats registered';

  @override
  String get boatName => 'Name';

  @override
  String get boatModel => 'Model';

  @override
  String get boatYear => 'Year';

  @override
  String get boatType => 'Type';

  @override
  String get boatLength => 'Length (feet)';

  @override
  String get pleaseEnterBoatName => 'Please enter the boat name';

  @override
  String get pleaseEnterBoatModel => 'Please enter the boat model';

  @override
  String get pleaseEnterValidYear => 'Please enter a valid year';

  @override
  String get pleaseEnterValidLength => 'Please enter a valid length';

  @override
  String get deleteBoat => 'Delete Boat';

  @override
  String get confirmDeleteBoat => 'Are you sure you want to delete this boat?';

  @override
  String get boatTypeJetski => 'Jet Ski';

  @override
  String get boatTypeSailboat => 'Sailboat';

  @override
  String get boatTypeBoat => 'Boat';

  @override
  String get boatTypeYacht => 'Yacht';

  @override
  String get editBoat => 'Edit Boat';

  @override
  String get loadBoatsError => 'Could not load your boats.';

  @override
  String get saveBoatError => 'Could not save the boat. Try again.';

  @override
  String get deleteBoatError => 'Could not delete the boat. Try again.';

  @override
  String get signalKIosLocalNetworkNotice => 'On the first connection, iOS will request local network access. Allow it so the app can communicate with the SignalK server.';

  @override
  String get marinaAccessTitle => 'Join Marina';

  @override
  String get marinaAccessInviteMessage => 'You\'ve been invited to join this marina. Select the boats you want to link.';

  @override
  String get selectBoatsToAssociate => 'Select your boats';

  @override
  String get noBoatsAvailable => 'You don\'t have any boats registered yet. You can continue without selecting any.';

  @override
  String get confirmAssociation => 'Confirm association';

  @override
  String get associationSuccessTitle => 'Association complete!';

  @override
  String associationSuccessMessage(String marinaName) {
    return 'You are now associated with $marinaName.';
  }

  @override
  String get backToApp => 'Back to app';

  @override
  String get loadMarinaError => 'Could not load the marina data.';

  @override
  String get associationError => 'Could not complete the association. Try again.';

  @override
  String get marinaAccessToggleLabel => 'Marina access';

  @override
  String get marinaAccessToggleDescription => 'Allow the marina to view and manage this boat.';

  @override
  String get marinaAccessToggleError => 'Could not update marina access. Try again.';

  @override
  String get marinaHubTooltip => 'My marina';

  @override
  String get marinaHomeTitle => 'My Marina';

  @override
  String get marinaHomeMyBoatsSubtitle => 'Manage your boats';

  @override
  String get newServiceOrder => 'New service order';

  @override
  String get newServiceOrderSubtitle => 'Request a service for your boat';

  @override
  String get myServiceOrders => 'My service orders';

  @override
  String get myServiceOrdersSubtitle => 'Track the progress of your orders';

  @override
  String get recentServiceOrders => 'Recent orders';

  @override
  String get seeAllServiceOrders => 'See all';

  @override
  String get noServiceOrders => 'No service orders yet';

  @override
  String get noServiceOrdersWithFilter => 'No service orders with this status';

  @override
  String get loadServiceOrdersError => 'Could not load your service orders.';

  @override
  String get serviceOrderStatusAll => 'All';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get serviceOrderStatusPending => 'Pending';

  @override
  String get serviceOrderStatusScheduled => 'Scheduled';

  @override
  String get serviceOrderStatusInProgress => 'In progress';

  @override
  String get serviceOrderStatusCompleted => 'Completed';

  @override
  String get serviceOrderStatusCancelled => 'Cancelled';

  @override
  String get selectBoat => 'Boat';

  @override
  String get pleaseSelectBoat => 'Select a boat';

  @override
  String get selectService => 'Service';

  @override
  String get pleaseSelectService => 'Select a service';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get estimatedPrice => 'List price';

  @override
  String get createServiceOrder => 'Create order';

  @override
  String get serviceOrderCreated => 'Service order created';

  @override
  String get createServiceOrderError => 'Could not create the service order. Try again.';

  @override
  String get noMarinaBoats => 'No boats linked to the marina';

  @override
  String get noMarinaBoatsDescription => 'Link a boat to the marina to request services.';

  @override
  String get manageBoatsCta => 'Manage my boats';

  @override
  String get emptyServiceCatalog => 'The marina has no services yet';

  @override
  String get loadPriceItemsError => 'Could not load available services.';

  @override
  String get cancelServiceOrder => 'Cancel order';

  @override
  String get cancelServiceOrderConfirm => 'Cancel this service order?';

  @override
  String get cancelServiceOrderError => 'Could not cancel the service order. Try again.';

  @override
  String get keepOrder => 'Keep';

  @override
  String get unitPerUnit => 'unit';

  @override
  String get unitPerHour => 'hour';

  @override
  String get unitPerDay => 'day';

  @override
  String get unitPerMonth => 'month';

  @override
  String get selectBoatTitle => 'Select your boat';

  @override
  String get selectBoatSubtitle => 'Your marina will track this boat\'s position during navigation.';

  @override
  String get startNavigationAction => 'Start navigation';

  @override
  String get startWithoutMonitoring => 'Start without monitoring';

  @override
  String get noBoatsMonitoringWarning => 'You have no boats linked to your marina, so it won\'t monitor this trip.';

  @override
  String get registerBoat => 'Register boat';

  @override
  String get startAnyway => 'Start anyway';

  @override
  String get rampTypeLaunch => 'Launch';

  @override
  String get rampTypeHaul => 'Haul';

  @override
  String get rampStatusPending => 'Pending';

  @override
  String get rampStatusConfirmed => 'Confirmed';

  @override
  String get rampStatusInProgress => 'In progress';

  @override
  String get rampStatusCompleted => 'Completed';

  @override
  String get rampStatusCancelled => 'Cancelled';

  @override
  String get rampStatusRejected => 'Rejected';

  @override
  String get rampStatusNoShow => 'No-show';

  @override
  String get rampBookingTitle => 'Book the ramp';

  @override
  String get rampBookingSubtitle => 'Launch or haul your boat at the marina ramp';

  @override
  String get myRampSchedules => 'My ramp bookings';

  @override
  String get myRampSchedulesSubtitle => 'Follow the approval of your requests';

  @override
  String get upcomingRampSchedules => 'Next at the ramp';

  @override
  String get seeAllRampSchedules => 'See all';

  @override
  String get noUpcomingRampSchedules => 'No upcoming ramp bookings';

  @override
  String get rampStepRamp => 'Ramp';

  @override
  String get rampStepBoat => 'Boat';

  @override
  String get rampStepOperation => 'Operation';

  @override
  String get rampStepSlot => 'Time';

  @override
  String get rampStepReturn => 'Return';

  @override
  String get rampStepReview => 'Review';

  @override
  String get rampSelectRampTitle => 'Which ramp will you use?';

  @override
  String get rampSelectBoatTitle => 'Which boat?';

  @override
  String get rampOperationTitle => 'What do you want to do?';

  @override
  String get rampLaunchTitle => 'Launch the boat';

  @override
  String get rampLaunchDescription => 'Put the boat in the water';

  @override
  String get rampHaulTitle => 'Haul the boat';

  @override
  String get rampHaulDescription => 'Take the boat out of the water';

  @override
  String get rampSlotTitle => 'Choose the day and time';

  @override
  String rampMinAdvanceHint(String value) {
    return 'Book at least $value in advance';
  }

  @override
  String get rampNoSlotsForDay => 'No times on this day';

  @override
  String get rampSlotFull => 'Full';

  @override
  String get rampSlotBlocked => 'Blocked';

  @override
  String get rampSlotUnavailable => 'Unavailable';

  @override
  String rampSlotsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spots',
      one: '1 spot',
    );
    return '$_temp0';
  }

  @override
  String get rampLoadSlotsError => 'Could not load the available times.';

  @override
  String get rampReturnTitle => 'Will you haul the boat afterwards?';

  @override
  String get rampReturnToggle => 'Book the return haul';

  @override
  String get rampReturnDescription => 'The haul is booked together with the launch, in a single request.';

  @override
  String rampReturnAfter(String time) {
    return 'Times from $time';
  }

  @override
  String get rampReviewTitle => 'Review your request';

  @override
  String get rampReviewRamp => 'Ramp';

  @override
  String get rampReviewBoat => 'Boat';

  @override
  String get rampReviewOperation => 'Operation';

  @override
  String get rampReviewWhen => 'When';

  @override
  String get rampReviewReturn => 'Return haul';

  @override
  String get rampAutoConfirmInfo => 'This ramp confirms your request right away.';

  @override
  String get rampPendingInfo => 'The marina will review your request. Follow its status in My ramp bookings.';

  @override
  String get rampNotesHint => 'Notes for the marina (optional)';

  @override
  String get rampContinue => 'Continue';

  @override
  String get rampSubmit => 'Request booking';

  @override
  String get rampBookingConfirmed => 'Booking confirmed';

  @override
  String get rampBookingRequested => 'Request sent. Wait for the marina\'s approval.';

  @override
  String get rampConflictError => 'That time was just taken. Please choose another one.';

  @override
  String get rampCreateError => 'Could not send the request. Please try again.';

  @override
  String get rampNoMarinaTitle => 'You are not linked to a marina yet';

  @override
  String get rampNoMarinaDescription => 'Ask your marina to grant you access on Estai.';

  @override
  String get rampNoRampsTitle => 'No ramps available';

  @override
  String get rampNoRampsDescription => 'Your marina has not enabled ramp booking in the app yet.';

  @override
  String get rampLoadRampsError => 'Could not load the ramps.';

  @override
  String get rampTabUpcoming => 'Upcoming';

  @override
  String get rampTabHistory => 'History';

  @override
  String get noRampSchedulesHistory => 'No bookings in your history';

  @override
  String get loadRampSchedulesError => 'Could not load your bookings.';

  @override
  String get rampReturnBadge => 'Return';

  @override
  String rampRejectionReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get cancelRampSchedule => 'Cancel booking';

  @override
  String get cancelRampScheduleConfirm => 'Cancel this booking?';

  @override
  String cancelRampScheduleAlsoReturn(String date) {
    return 'Also cancel the return haul ($date)';
  }

  @override
  String get keepRampSchedule => 'Keep';

  @override
  String get cancelRampScheduleError => 'Could not cancel the booking. Please try again.';

  @override
  String get rampNewSchedule => 'New booking';

  @override
  String get marinaQuickActionsTitle => 'Quick actions';

  @override
  String get marinaActionServiceOrder => 'Request service';

  @override
  String get marinaTrackingTitle => 'Tracking';

  @override
  String get marinaTrackingRamp => 'Ramp';

  @override
  String get marinaTrackingServices => 'Services';

  @override
  String get marinaSeeAllRampSchedules => 'See all bookings';

  @override
  String get marinaSeeAllServiceOrders => 'See all orders';

  @override
  String get reminderChannelName => 'Reminders';

  @override
  String get reminderChannelDescription => 'Boat maintenance reminders';

  @override
  String get pushPermissionRationaleTitle => 'Turn on reminders';

  @override
  String get pushPermissionRationaleBody => 'To let you know when maintenance is coming up, Estai needs to send notifications to this device.';

  @override
  String get pushPermissionBlockedTitle => 'Notifications blocked';

  @override
  String get pushPermissionBlockedBody => 'Estai notifications are turned off. Turn them on in your device settings to receive reminders.';

  @override
  String get notificationChannelPush => 'Push';

  @override
  String get notificationChannelEmail => 'Email';

  @override
  String get maintenanceStatusScheduled => 'Scheduled';

  @override
  String get maintenanceStatusOverdue => 'Overdue';

  @override
  String get maintenanceStatusDone => 'Done';

  @override
  String get maintenanceCategoryEngine => 'Engine';

  @override
  String get maintenanceCategoryHull => 'Hull';

  @override
  String get maintenanceCategoryElectrical => 'Electrical';

  @override
  String get maintenanceCategoryPlumbing => 'Plumbing';

  @override
  String get maintenanceCategorySafety => 'Safety';

  @override
  String get maintenanceCategoryRigging => 'Rigging';

  @override
  String get maintenanceCategoryElectronics => 'Electronics';

  @override
  String get maintenanceCategoryOther => 'Other';

  @override
  String get journalTitle => 'Boat journal';

  @override
  String get journalEngineHours => 'Engine hours';

  @override
  String engineHoursValue(String hours) {
    return '$hours h';
  }

  @override
  String get journalEngineHoursUnknown => 'Not set';

  @override
  String journalEngineHoursReadAt(String date) {
    return 'Updated on $date';
  }

  @override
  String get journalUpdateEngineHours => 'Update';

  @override
  String get journalQuickActionsTitle => 'Quick actions';

  @override
  String get journalActionMaintenances => 'Maintenance';

  @override
  String get journalUpcomingMaintenancesTitle => 'Upcoming maintenance';

  @override
  String get journalSeeAllMaintenances => 'See all maintenance';

  @override
  String journalOverdueAlert(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overdue maintenance items',
      one: '1 overdue maintenance',
    );
    return '$_temp0';
  }

  @override
  String get journalLoadError => 'Couldn\'t load the boat journal.';

  @override
  String get engineHoursSheetTitle => 'Update engine hours';

  @override
  String get engineHoursSheetHint => 'Enter the current engine hour meter reading.';

  @override
  String get engineHoursFieldLabel => 'Engine hours';

  @override
  String get invalidNumber => 'Enter a valid number.';

  @override
  String engineHoursLowerThanCurrent(String hours) {
    return 'The reading can\'t be lower than the current one ($hours h).';
  }

  @override
  String get engineHoursSaved => 'Engine hours updated.';

  @override
  String get engineHoursSaveError => 'Couldn\'t save the engine hours.';

  @override
  String get maintenancesTitle => 'Maintenance';

  @override
  String get maintenanceTabUpcoming => 'Upcoming';

  @override
  String get maintenanceTabHistory => 'History';

  @override
  String get maintenanceNew => 'New maintenance';

  @override
  String get maintenanceEditTitle => 'Edit maintenance';

  @override
  String get noUpcomingMaintenances => 'No maintenance scheduled.';

  @override
  String get noMaintenancesHistory => 'No completed maintenance yet.';

  @override
  String get loadMaintenancesError => 'Couldn\'t load maintenance.';

  @override
  String get maintenanceScheduleFirst => 'Schedule maintenance';

  @override
  String get maintenanceDueToday => 'Due today';

  @override
  String maintenanceDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Due in $count days',
      one: 'Due tomorrow',
    );
    return '$_temp0';
  }

  @override
  String maintenanceOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String maintenanceDueInHours(String hours) {
    return '$hours h left';
  }

  @override
  String maintenanceOverdueHours(String hours) {
    return '$hours h overdue';
  }

  @override
  String maintenanceDueAtHours(String hours) {
    return 'At $hours h';
  }

  @override
  String maintenanceCompletedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get maintenanceRecurringBadge => 'Recurring';

  @override
  String get maintenanceComplete => 'Complete';

  @override
  String get maintenanceCompleted => 'Maintenance completed.';

  @override
  String get completeMaintenanceError => 'Couldn\'t complete the maintenance.';

  @override
  String get completeMaintenanceTitle => 'Complete maintenance';

  @override
  String get completeMaintenanceDate => 'Completion date';

  @override
  String get completeMaintenanceEngineHours => 'Engine hours at completion (optional)';

  @override
  String get completeMaintenanceCost => 'Cost (optional)';

  @override
  String get completeMaintenanceRecurringHint => 'Since it\'s recurring, the next one will be scheduled automatically.';

  @override
  String get maintenanceTitleLabel => 'Title';

  @override
  String get maintenanceTitleHint => 'E.g. engine oil change';

  @override
  String get maintenanceTitleRequired => 'Enter a title.';

  @override
  String get maintenanceCategoryLabel => 'Category';

  @override
  String get maintenanceDescriptionLabel => 'Description (optional)';

  @override
  String get maintenanceDueSection => 'Due';

  @override
  String get maintenanceDueHint => 'Enter a date, engine hours or both. Whichever comes first applies.';

  @override
  String get maintenanceDueDateLabel => 'Date';

  @override
  String get maintenanceDueDateNone => 'No date';

  @override
  String get maintenanceDueEngineHoursLabel => 'Engine hours (h)';

  @override
  String get maintenanceMissingDue => 'Enter the due date or engine hours.';

  @override
  String get maintenanceRecurrenceTitle => 'Repeat';

  @override
  String get maintenanceRecurrenceSubtitle => 'When completed, the next one is scheduled automatically.';

  @override
  String get maintenanceRecurrenceMonthsLabel => 'Every (months)';

  @override
  String get maintenanceRecurrenceHoursLabel => 'Every (hours)';

  @override
  String get maintenanceRecurrenceRequired => 'Enter months or hours to repeat.';

  @override
  String get maintenanceProviderLabel => 'Shop or provider (optional)';

  @override
  String get maintenanceSave => 'Save maintenance';

  @override
  String get maintenanceSaved => 'Maintenance saved.';

  @override
  String get saveMaintenanceError => 'Couldn\'t save the maintenance.';

  @override
  String get maintenanceInvalidError => 'Check the maintenance details.';

  @override
  String get deleteMaintenance => 'Delete maintenance';

  @override
  String get deleteMaintenanceConfirm => 'This maintenance and its reminders will be removed.';

  @override
  String get deleteMaintenanceError => 'Couldn\'t delete the maintenance.';

  @override
  String get reminderTitle => 'Reminder';

  @override
  String get reminderSubtitle => 'Sent by Estai before it\'s due.';

  @override
  String get reminderDaysBeforeLabel => 'Remind me before';

  @override
  String reminderDaysOption(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: 'On the day',
    );
    return '$_temp0';
  }

  @override
  String get reminderHoursBeforeLabel => 'Remind me before (engine hours)';

  @override
  String get reminderChannelsLabel => 'Send via';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get notificationPrefsDescription => 'Maintenance reminders and alerts are sent by Estai through the channels you turn on.';

  @override
  String get notificationPrefsPush => 'Push notifications';

  @override
  String get notificationPrefsPushSubtitle => 'On your phone, even with the app closed.';

  @override
  String get notificationPrefsEmail => 'Email';

  @override
  String notificationPrefsEmailSubtitle(String email) {
    return 'Sent to $email';
  }

  @override
  String get notificationPrefsEmailSubtitleNoEmail => 'Sent to your account email.';

  @override
  String get notificationPrefsSystemBlocked => 'Notifications are turned off on this device. Allow them to receive push reminders.';

  @override
  String get notificationPrefsAllow => 'Allow notifications';

  @override
  String get notificationPrefsSendTest => 'Send test notification';

  @override
  String get notificationPrefsTestSent => 'Test notification sent.';

  @override
  String get notificationPrefsTestError => 'Couldn\'t send the test notification.';

  @override
  String get notificationPrefsLoadError => 'Couldn\'t load your preferences.';

  @override
  String get notificationPrefsSaveError => 'Couldn\'t save your preferences.';

  @override
  String get maintenanceAlreadyDone => 'Already done';

  @override
  String get maintenanceAlreadyDoneSubtitle => 'Log maintenance that has already been done.';

  @override
  String get maintenanceCompletionSection => 'Completion';

  @override
  String get maintenanceRecurrenceSubtitleCompleted => 'The next one is scheduled from the completion date.';

  @override
  String get maintenanceDetailsTitle => 'Completed maintenance';

  @override
  String get maintenanceDetailsInfoSection => 'Details';

  @override
  String get maintenanceDetailsEngineHours => 'Engine hours at completion';

  @override
  String get maintenanceDetailsCost => 'Cost';

  @override
  String get maintenanceDetailsNotes => 'Notes';

  @override
  String get maintenanceDetailsProvider => 'Shop or provider';

  @override
  String get maintenanceDetailsDescription => 'Description';

  @override
  String get maintenanceDetailsOriginalDue => 'Original due';

  @override
  String get maintenanceDetailsRecurrence => 'Repeats';

  @override
  String get maintenanceDetailsNotInformed => 'Not provided';

  @override
  String maintenanceRecurrenceEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Every month',
    );
    return '$_temp0';
  }

  @override
  String maintenanceRecurrenceEveryHours(String hours) {
    return 'Every $hours h';
  }

  @override
  String get logbookTypeTrip => 'Trip';

  @override
  String get logbookTypeNote => 'Note';

  @override
  String get logbookTypeAnchorage => 'Anchorage';

  @override
  String get logbookTypeIncident => 'Incident';

  @override
  String get logbookTypeEvent => 'Event';

  @override
  String get logbookTitle => 'Logbook';

  @override
  String get logbookFilterAll => 'All';

  @override
  String get logbookNewEntry => 'New entry';

  @override
  String get logbookEditEntry => 'Edit entry';

  @override
  String get noLogbookEntries => 'No logbook entries yet.';

  @override
  String get loadLogbookError => 'Couldn\'t load the logbook.';

  @override
  String get logbookTypeLabel => 'Type';

  @override
  String get logbookTitleLabel => 'Title';

  @override
  String get logbookTitleRequired => 'Enter a title.';

  @override
  String get logbookDateLabel => 'Date';

  @override
  String get logbookTimeLabel => 'Time';

  @override
  String get logbookUseCurrentPosition => 'Record current position';

  @override
  String get logbookUseCurrentPositionSubtitle => 'Saves where the boat is right now.';

  @override
  String get logbookPositionUnavailable => 'Current position unavailable. Check the GPS.';

  @override
  String get logbookSave => 'Save entry';

  @override
  String get logbookSaved => 'Entry saved.';

  @override
  String get saveLogbookEntryError => 'Couldn\'t save the entry.';

  @override
  String get logbookInvalidError => 'Check the entry details.';

  @override
  String get deleteLogbookEntry => 'Delete entry';

  @override
  String get deleteLogbookEntryConfirm => 'This entry will be removed from the logbook.';

  @override
  String get deleteLogbookEntryError => 'Couldn\'t delete the entry.';

  @override
  String get logbookDetailsInfoSection => 'Details';

  @override
  String get logbookDetailsTripSection => 'Navigation';

  @override
  String get logbookTripMapExpand => 'Expand map';

  @override
  String get logbookTripMapTitle => 'Route';

  @override
  String get logbookDetailsDate => 'Date and time';

  @override
  String get logbookDetailsDuration => 'Duration';

  @override
  String get logbookDetailsDistance => 'Distance';

  @override
  String get logbookDetailsAvgSpeed => 'Average speed';

  @override
  String get logbookDetailsMaxSpeed => 'Top speed';

  @override
  String get logbookDetailsEngineHoursEnd => 'Engine hours at the end';

  @override
  String get logbookDetailsPassengers => 'Passengers';

  @override
  String get logbookDetailsPosition => 'Position';

  @override
  String get logbookDetailsNotes => 'Notes';

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
    return 'top $value kn';
  }

  @override
  String get journalRecentLogbookTitle => 'Latest entries';

  @override
  String get journalSeeLogbook => 'See logbook';

  @override
  String get journalNoLogbookEntries => 'Trips you save when finishing a navigation show up here.';

  @override
  String get tripSaveTitle => 'Save trip to the logbook';

  @override
  String get tripSaveSubtitle => 'Log this navigation in the boat\'s logbook.';

  @override
  String get tripBoatLabel => 'Boat';

  @override
  String tripDefaultTitle(String date) {
    return 'Trip on $date';
  }

  @override
  String get tripEngineHoursEndLabel => 'Engine hours at the end (optional)';

  @override
  String get tripPassengersLabel => 'Passengers (optional)';

  @override
  String get tripSave => 'Save to logbook';

  @override
  String get tripDiscard => 'Discard';

  @override
  String get tripSaved => 'Trip saved to the logbook.';

  @override
  String get tripQueued => 'No connection. The trip will be sent when you\'re back online.';

  @override
  String get tripSaveError => 'Couldn\'t save the trip.';

  @override
  String get settingsSectionNavigation => 'Navigation';

  @override
  String get settingsSectionMaps => 'Maps and charts';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get boatRemindersTitle => 'Reminders';

  @override
  String get boatReminderNew => 'New reminder';

  @override
  String get boatReminderEditTitle => 'Edit reminder';

  @override
  String get boatReminderTabPending => 'Pending';

  @override
  String get boatReminderTabDone => 'Done';

  @override
  String get boatReminderStatusPending => 'Pending';

  @override
  String get boatReminderStatusDone => 'Done';

  @override
  String get noPendingBoatReminders => 'No pending reminders.';

  @override
  String get noDoneBoatReminders => 'No completed reminders yet.';

  @override
  String get loadBoatRemindersError => 'Couldn\'t load the reminders.';

  @override
  String get boatReminderTitleLabel => 'Title';

  @override
  String get boatReminderTitleHint => 'E.g. Renew the marina berth';

  @override
  String get boatReminderTitleRequired => 'Enter a title';

  @override
  String get boatReminderDateLabel => 'Date';

  @override
  String get boatReminderDatePlaceholder => 'Pick a date';

  @override
  String get boatReminderDateRequired => 'Pick the reminder date';

  @override
  String get boatReminderDoneAtLabel => 'Done on';

  @override
  String get boatReminderNotesLabel => 'Notes';

  @override
  String boatReminderDoneOn(String date) {
    return 'Done on $date';
  }

  @override
  String get boatReminderDueToday => 'Today';

  @override
  String boatReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'Tomorrow',
    );
    return '$_temp0';
  }

  @override
  String boatReminderOverdueDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String boatReminderEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Repeats every $count months',
      one: 'Repeats every month',
    );
    return '$_temp0';
  }

  @override
  String get boatReminderRecurrenceTitle => 'Repeat';

  @override
  String get boatReminderRecurrenceSubtitle => 'When marked as done, the next one is created automatically';

  @override
  String get boatReminderRecurrenceMonthsLabel => 'Every how many months';

  @override
  String get boatReminderMarkDone => 'Mark as done';

  @override
  String get boatReminderMarkDoneConfirm => 'The reminder will move to Done.';

  @override
  String boatReminderMarkDoneRecurringConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The reminder will move to Done and the next one is created $count months after this one\'s date.',
      one: 'The reminder will move to Done and the next one is created 1 month after this one\'s date.',
    );
    return '$_temp0';
  }

  @override
  String get boatReminderMarkedDone => 'Reminder marked as done';

  @override
  String get markBoatReminderDoneError => 'Couldn\'t mark the reminder as done.';

  @override
  String get boatReminderSave => 'Save reminder';

  @override
  String get boatReminderSaved => 'Reminder saved';

  @override
  String get boatReminderInvalidError => 'Check the reminder details.';

  @override
  String get saveBoatReminderError => 'Couldn\'t save the reminder. Try again.';

  @override
  String get deleteBoatReminder => 'Delete reminder';

  @override
  String get deleteBoatReminderConfirm => 'The reminder and its scheduled notifications will be deleted.';

  @override
  String get deleteBoatReminderError => 'Couldn\'t delete the reminder.';

  @override
  String get documentStatusExpired => 'Expired';

  @override
  String get documentStatusExpiringSoon => 'Expiring soon';

  @override
  String get documentStatusValid => 'Valid';

  @override
  String get documentStatusNoExpiry => 'No expiry';

  @override
  String get documentTypeRegistration => 'Registration';

  @override
  String get documentTypeInsurance => 'Insurance';

  @override
  String get documentTypeInspection => 'Inspection';

  @override
  String get documentTypeRadioLicense => 'Radio license';

  @override
  String get documentTypeFireExtinguisher => 'Fire extinguisher';

  @override
  String get documentTypeFlares => 'Flares';

  @override
  String get documentTypeLifeJackets => 'Life jackets';

  @override
  String get documentTypeLifeRaft => 'Life raft';

  @override
  String get documentTypeOther => 'Other';

  @override
  String get documentTypeNauticalLicense => 'Boating license';

  @override
  String get documentTypeRadioOperatorCertificate => 'Radio operator certificate';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get myDocumentsTitle => 'My documents';

  @override
  String get myDocumentsSubtitle => 'Boating license and certificates';

  @override
  String get documentNew => 'New document';

  @override
  String get documentEditTitle => 'Edit document';

  @override
  String get documentDetailsTitle => 'Document';

  @override
  String get documentsAttentionSection => 'Needs attention';

  @override
  String get documentsOthersSection => 'Other documents';

  @override
  String get noBoatDocuments => 'No documents yet. Keep your registration, insurance, inspection and safety items with expiry dates here.';

  @override
  String get noPersonalDocuments => 'No documents yet. Keep your boating license and certificates here.';

  @override
  String get loadDocumentsError => 'Couldn\'t load the documents.';

  @override
  String get loadDocumentError => 'Couldn\'t load the document.';

  @override
  String get documentTypeLabel => 'Type';

  @override
  String get documentTitleLabel => 'Name (optional)';

  @override
  String get documentNumberLabel => 'Number';

  @override
  String get documentIssuerLabel => 'Issuer';

  @override
  String get documentIssuerHint => 'E.g. maritime authority, insurer';

  @override
  String get documentDatesSection => 'Validity';

  @override
  String get documentExpiresAtLabel => 'Expires on';

  @override
  String get documentIssuedAtLabel => 'Issued on';

  @override
  String get documentNoExpiryLabel => 'No expiry';

  @override
  String get documentDateNotInformed => 'Not provided';

  @override
  String get documentInvalidDatesError => 'Expiry can\'t be before the issue date';

  @override
  String documentExpiresOn(String date) {
    return 'Expires on $date';
  }

  @override
  String get documentExpiresToday => 'expires today';

  @override
  String documentExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String documentExpiredDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'expired $count days ago',
      one: 'expired 1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get documentReminderLabel => 'Reminder';

  @override
  String documentReminderDaysBefore(String days) {
    return '$days days before';
  }

  @override
  String get documentReminderOff => 'Off';

  @override
  String get documentDetailsInfoSection => 'Details';

  @override
  String get documentNotesSection => 'Notes';

  @override
  String get documentAttachmentsSection => 'Attachments';

  @override
  String get documentSave => 'Save document';

  @override
  String get documentSaved => 'Document saved';

  @override
  String get documentInvalidError => 'Check the document details.';

  @override
  String get saveDocumentError => 'Couldn\'t save the document. Try again.';

  @override
  String get documentAttachmentsFailed => 'The document was saved, but some attachments weren\'t uploaded. Tap Try again.';

  @override
  String get deleteDocument => 'Delete document';

  @override
  String get deleteDocumentConfirm => 'The document, its attachments and scheduled reminders will be deleted.';

  @override
  String get deleteDocumentError => 'Couldn\'t delete the document.';

  @override
  String get attachmentAdd => 'Add';

  @override
  String get attachmentAddTitle => 'Add attachment';

  @override
  String get attachmentSourceCamera => 'Take photo';

  @override
  String get attachmentSourceGallery => 'Choose from gallery';

  @override
  String get attachmentSourcePdf => 'PDF file';

  @override
  String attachmentsHint(int count, int size) {
    return 'Photos or PDF, up to $count files of $size MB.';
  }

  @override
  String get attachmentLimitReached => 'Attachment limit reached.';

  @override
  String get attachmentTooLarge => 'File is larger than the limit.';

  @override
  String get attachmentUnsupported => 'File type not supported. Use a photo or PDF.';

  @override
  String attachmentUploadingProgress(int current, int total) {
    return 'Uploading attachment $current of $total…';
  }

  @override
  String get attachmentOpenError => 'Couldn\'t open the attachment.';

  @override
  String get journalRemindersTitle => 'Reminders';

  @override
  String get journalNoReminders => 'No pending reminders.';

  @override
  String get journalSeeReminders => 'See reminders';

  @override
  String journalDocumentsAlert(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents expired or expiring soon',
      one: '1 document expired or expiring soon',
    );
    return '$_temp0';
  }

  @override
  String get checklistsTitle => 'Checklists';

  @override
  String get checklistsSubtitle => 'Before and after navigating';

  @override
  String get checklistsEmpty => 'No checklists yet. Create one to check the boat before leaving or when you return.';

  @override
  String get checklistNew => 'New checklist';

  @override
  String get checklistEdit => 'Edit checklist';

  @override
  String get checklistSave => 'Save checklist';

  @override
  String get checklistSaved => 'Checklist saved';

  @override
  String get checklistSaveError => 'Could not save the checklist. Please try again.';

  @override
  String get checklistDelete => 'Delete checklist';

  @override
  String get checklistDeleteConfirm => 'This checklist will be deleted from this device. Continue?';

  @override
  String get checklistNameLabel => 'Name';

  @override
  String get checklistNameHint => 'E.g. Before leaving';

  @override
  String get checklistNameRequired => 'Enter a name';

  @override
  String get checklistTriggerLabel => 'When it shows up';

  @override
  String get checklistTriggerBefore => 'Before navigating';

  @override
  String get checklistTriggerAfter => 'After navigating';

  @override
  String get checklistTriggerNone => 'Not linked';

  @override
  String get checklistTriggerBeforeDescription => 'Opens automatically when you tap Navigate, before navigation starts.';

  @override
  String get checklistTriggerAfterDescription => 'Opens automatically when you finish navigating.';

  @override
  String get checklistTriggerNoneDescription => 'Never opens on its own. Run it whenever you want from this screen.';

  @override
  String get checklistItemsSection => 'Items';

  @override
  String get checklistItemHint => 'Describe the item';

  @override
  String get checklistAddItem => 'Add item';

  @override
  String get checklistRemoveItem => 'Remove item';

  @override
  String get checklistItemsLimit => 'Item limit reached';

  @override
  String get checklistNoItemsError => 'Add at least one item.';

  @override
  String checklistItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get checklistRunBeforeTitle => 'Before navigating';

  @override
  String get checklistRunAfterTitle => 'After navigating';

  @override
  String checklistRunProgress(int checked, int total) {
    return '$checked of $total';
  }

  @override
  String get checklistRunComplete => 'All checked';

  @override
  String get checklistUncheckAll => 'Uncheck all';

  @override
  String get checklistStartNavigation => 'Start navigation';

  @override
  String get checklistSkip => 'Skip checklist';

  @override
  String get checklistDone => 'Done';

  @override
  String get checklistMissingItemsTitle => 'Unchecked items';

  @override
  String checklistMissingItemsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items are unchecked. Start navigation anyway?',
      one: '1 item is unchecked. Start navigation anyway?',
    );
    return '$_temp0';
  }

  @override
  String get checklistDefaultBeforeName => 'Before leaving';

  @override
  String get checklistDefaultBeforeFuel => 'Enough fuel for the trip';

  @override
  String get checklistDefaultBeforeOil => 'Engine oil level';

  @override
  String get checklistDefaultBeforeDrainPlug => 'Hull drain plug in place';

  @override
  String get checklistDefaultBeforeBattery => 'Battery and navigation lights';

  @override
  String get checklistDefaultBeforeLifeJackets => 'Life jackets for everyone on board';

  @override
  String get checklistDefaultBeforeSafety => 'Fire extinguisher and flares';

  @override
  String get checklistDefaultBeforeWeather => 'Weather and sea forecast checked';

  @override
  String get checklistDefaultBeforeFloatPlan => 'Tell someone your float plan';

  @override
  String get checklistDefaultAfterName => 'When back';

  @override
  String get checklistDefaultAfterFlushEngine => 'Flush the engine with fresh water';

  @override
  String get checklistDefaultAfterFuelValve => 'Close the fuel valve';

  @override
  String get checklistDefaultAfterMainSwitch => 'Turn off the battery switch';

  @override
  String get checklistDefaultAfterTrash => 'Take the trash off the boat';

  @override
  String get checklistDefaultAfterLines => 'Check lines and fenders';

  @override
  String get checklistDefaultAfterCover => 'Put the cover on';

  @override
  String deleteRouteConfirm(String name) {
    return 'The route \"$name\" will be deleted. Continue?';
  }

  @override
  String get forecastNow => 'Now';

  @override
  String get forecastEvolution => 'Trend';

  @override
  String get forecastNextDays => 'Next days';

  @override
  String get forecastToday => 'Today';

  @override
  String get forecastTomorrow => 'Tomorrow';

  @override
  String get forecastMoreDetails => 'More details';

  @override
  String forecastMoreDetailsAt(String time) {
    return 'More details · $time';
  }

  @override
  String get forecastMetricWind => 'Wind';

  @override
  String get forecastMetricWaves => 'Waves';

  @override
  String get forecastMetricTemperature => 'Temperature';

  @override
  String get forecastMetricRain => 'Rain';

  @override
  String get forecastMetricPressure => 'Pressure';

  @override
  String get forecastChartRainTitle => 'Chance of rain';

  @override
  String get forecastChartWindLegend => 'Solid line: average wind · dashed: gusts';

  @override
  String forecastMinMax(String min, String max) {
    return 'min $min · max $max';
  }

  @override
  String get forecastTrendRising => 'Rising';

  @override
  String get forecastTrendFalling => 'Falling';

  @override
  String get forecastTrendSteady => 'Steady';

  @override
  String forecastTrendTo(String value, String time) {
    return '$value at $time';
  }

  @override
  String get forecastHeadlineSteady => 'Steady conditions over the next hours';

  @override
  String forecastHeadlineWindRising(String value, String time) {
    return 'Wind picks up to $value around $time';
  }

  @override
  String forecastHeadlineWindFalling(String value, String time) {
    return 'Wind eases to $value by $time';
  }

  @override
  String forecastHeadlineWavesRising(String value, String time) {
    return 'Waves build to $value around $time';
  }

  @override
  String forecastHeadlineWavesFalling(String value, String time) {
    return 'Waves drop to $value by $time';
  }

  @override
  String forecastHeadlineRain(String value, String time) {
    return '$value chance of rain from $time';
  }

  @override
  String forecastHeadlineTemperatureRising(String value, String time) {
    return 'Temperature rises to $value by $time';
  }

  @override
  String forecastHeadlineTemperatureFalling(String value, String time) {
    return 'Temperature drops to $value by $time';
  }

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalNE => 'NE';

  @override
  String get cardinalE => 'E';

  @override
  String get cardinalSE => 'SE';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalSW => 'SW';

  @override
  String get cardinalW => 'W';

  @override
  String get cardinalNW => 'NW';
}
