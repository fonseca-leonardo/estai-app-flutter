import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Estai - Map'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get enter;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account. '**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @continueWithoutLogin.
  ///
  /// In en, this message translates to:
  /// **'Continue without login'**
  String get continueWithoutLogin;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account. '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get passwordResetEmailSent;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'You are not authenticated.'**
  String get notAuthenticated;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @minimumDistance.
  ///
  /// In en, this message translates to:
  /// **'Minimum distance: {value} m'**
  String minimumDistance(String value);

  /// No description provided for @minimumDistanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Defines the minimum distance in meters that the user needs to travel for a new point to be added to the tracked route during navigation. Higher values result in routes with fewer points, while lower values create more detailed routes.'**
  String get minimumDistanceDescription;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String meters(String value);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied permanently.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @errorGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting location: {error}'**
  String errorGettingLocation(String error);

  /// No description provided for @errorUpdatingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error updating location: {error}'**
  String errorUpdatingLocation(String error);

  /// No description provided for @finishNavigation.
  ///
  /// In en, this message translates to:
  /// **'Finish Navigation'**
  String get finishNavigation;

  /// No description provided for @finishNavigationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to finish navigation?'**
  String get finishNavigationQuestion;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @unlockCamera.
  ///
  /// In en, this message translates to:
  /// **'Unlock camera'**
  String get unlockCamera;

  /// No description provided for @lockCamera.
  ///
  /// In en, this message translates to:
  /// **'Lock camera to position'**
  String get lockCamera;

  /// No description provided for @hideCustomTiles.
  ///
  /// In en, this message translates to:
  /// **'Hide custom tiles'**
  String get hideCustomTiles;

  /// No description provided for @showCustomTiles.
  ///
  /// In en, this message translates to:
  /// **'Show custom tiles'**
  String get showCustomTiles;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @newRoute.
  ///
  /// In en, this message translates to:
  /// **'New Route'**
  String get newRoute;

  /// No description provided for @tides.
  ///
  /// In en, this message translates to:
  /// **'Tides'**
  String get tides;

  /// No description provided for @adjustments.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adjustments;

  /// No description provided for @improvementsAndSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get improvementsAndSuggestions;

  /// No description provided for @feedbackSuggestionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share your suggestion or improvement (max 500 characters)'**
  String get feedbackSuggestionPlaceholder;

  /// No description provided for @feedbackSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your feedback was sent.'**
  String get feedbackSentSuccess;

  /// No description provided for @feedbackError.
  ///
  /// In en, this message translates to:
  /// **'Could not send feedback. Try again later.'**
  String get feedbackError;

  /// No description provided for @feedbackMaxCharacters.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max}'**
  String feedbackMaxCharacters(String current, String max);

  /// No description provided for @addPoint.
  ///
  /// In en, this message translates to:
  /// **'Add point?'**
  String get addPoint;

  /// No description provided for @confirmPoint.
  ///
  /// In en, this message translates to:
  /// **'Confirm point'**
  String get confirmPoint;

  /// No description provided for @tideTables.
  ///
  /// In en, this message translates to:
  /// **'Tide Tables'**
  String get tideTables;

  /// No description provided for @noTideTablesFound.
  ///
  /// In en, this message translates to:
  /// **'No tide tables found'**
  String get noTideTablesFound;

  /// No description provided for @errorLoadingTideTables.
  ///
  /// In en, this message translates to:
  /// **'Error loading tide tables: {error}'**
  String errorLoadingTideTables(String error);

  /// No description provided for @velocity.
  ///
  /// In en, this message translates to:
  /// **'VEL'**
  String get velocity;

  /// No description provided for @heading.
  ///
  /// In en, this message translates to:
  /// **'HDG'**
  String get heading;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'LAT'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'LON'**
  String get longitude;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'DIST'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get time;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'User disabled'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later'**
  String get tooManyRequests;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Error signing in: {message}'**
  String loginError(String message);

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password too weak'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @signUpError.
  ///
  /// In en, this message translates to:
  /// **'Error creating account: {message}'**
  String signUpError(String message);

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get emailNotFound;

  /// No description provided for @sendEmailError.
  ///
  /// In en, this message translates to:
  /// **'Error sending email: {message}'**
  String sendEmailError(String message);

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Error logging out: {error}'**
  String logoutError(String error);

  /// No description provided for @navigationSettings.
  ///
  /// In en, this message translates to:
  /// **'Navigation Settings'**
  String get navigationSettings;

  /// No description provided for @navigationSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure navigation and tracking options'**
  String get navigationSettingsDescription;

  /// No description provided for @navigationPermission.
  ///
  /// In en, this message translates to:
  /// **'GPS Permissions'**
  String get navigationPermission;

  /// No description provided for @navigationPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'View the current location permission status and change it in system settings if needed.'**
  String get navigationPermissionDescription;

  /// No description provided for @locationPermissionAlways.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get locationPermissionAlways;

  /// No description provided for @locationPermissionAlwaysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Location available in foreground and background.'**
  String get locationPermissionAlwaysSubtitle;

  /// No description provided for @locationPermissionWhileInUse.
  ///
  /// In en, this message translates to:
  /// **'While using the app'**
  String get locationPermissionWhileInUse;

  /// No description provided for @locationPermissionWhileInUseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable \"Always\" to track during navigation.'**
  String get locationPermissionWhileInUseSubtitle;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openAppSettings;

  /// No description provided for @locationPermissionChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get locationPermissionChecking;

  /// No description provided for @locationPermissionCheckingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we check.'**
  String get locationPermissionCheckingSubtitle;

  /// No description provided for @locationPermissionDeniedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The app cannot access your location.'**
  String get locationPermissionDeniedSubtitle;

  /// No description provided for @locationPermissionDeniedForeverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You denied the permission. Change it in system settings.'**
  String get locationPermissionDeniedForeverSubtitle;

  /// No description provided for @userAccount.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get userAccount;

  /// No description provided for @manageAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Manage your account information'**
  String get manageAccountInfo;

  /// No description provided for @logoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutAccount;

  /// No description provided for @logoutAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'You will need to log in again'**
  String get logoutAccountDescription;

  /// No description provided for @loginToAccessInfo.
  ///
  /// In en, this message translates to:
  /// **'Log in to access your information'**
  String get loginToAccessInfo;

  /// No description provided for @myRoutes.
  ///
  /// In en, this message translates to:
  /// **'My Routes'**
  String get myRoutes;

  /// No description provided for @routesList.
  ///
  /// In en, this message translates to:
  /// **'Routes List'**
  String get routesList;

  /// No description provided for @noRoutesFound.
  ///
  /// In en, this message translates to:
  /// **'No routes found'**
  String get noRoutesFound;

  /// No description provided for @routeName.
  ///
  /// In en, this message translates to:
  /// **'Route Name'**
  String get routeName;

  /// No description provided for @saveRoute.
  ///
  /// In en, this message translates to:
  /// **'Save Route'**
  String get saveRoute;

  /// No description provided for @deleteRoute.
  ///
  /// In en, this message translates to:
  /// **'Delete Route'**
  String get deleteRoute;

  /// No description provided for @routeSaved.
  ///
  /// In en, this message translates to:
  /// **'Route saved successfully'**
  String get routeSaved;

  /// No description provided for @errorSavingRoute.
  ///
  /// In en, this message translates to:
  /// **'Error saving route'**
  String get errorSavingRoute;

  /// No description provided for @editRouteName.
  ///
  /// In en, this message translates to:
  /// **'Edit route name'**
  String get editRouteName;

  /// No description provided for @pleaseEnterRouteName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a route name'**
  String get pleaseEnterRouteName;

  /// No description provided for @loadRoute.
  ///
  /// In en, this message translates to:
  /// **'Load Route'**
  String get loadRoute;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @confirmRoute.
  ///
  /// In en, this message translates to:
  /// **'Confirm Route'**
  String get confirmRoute;

  /// No description provided for @startNavigationWithRoute.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get startNavigationWithRoute;

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// No description provided for @totalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get totalDistance;

  /// No description provided for @maps.
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get maps;

  /// No description provided for @mapsSelectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the maps you want to display on the main screen. Selected maps will be overlaid on the base map.'**
  String get mapsSelectionDescription;

  /// No description provided for @mapsSelectionPerformanceWarning.
  ///
  /// In en, this message translates to:
  /// **'Note: Selecting many maps may impact app performance and increase data usage.'**
  String get mapsSelectionPerformanceWarning;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable dark mode for custom maps to reduce eye strain in low-light conditions.'**
  String get darkModeDescription;

  /// No description provided for @saveRouteForReuse.
  ///
  /// In en, this message translates to:
  /// **'Save route for reuse'**
  String get saveRouteForReuse;

  /// No description provided for @saveRouteForReuseDescription.
  ///
  /// In en, this message translates to:
  /// **'Save this route to use it again in the future'**
  String get saveRouteForReuseDescription;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @plannedRoute.
  ///
  /// In en, this message translates to:
  /// **'Planned Route'**
  String get plannedRoute;

  /// No description provided for @errorLoadingMaps.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch the maps list now. Check your internet connection and try again later.'**
  String get errorLoadingMaps;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Error signing in with Google: {message}'**
  String googleSignInError(String message);

  /// No description provided for @googleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign in cancelled'**
  String get googleSignInCancelled;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with Google: {error}'**
  String googleSignInFailed(String error);

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your internet connection.'**
  String get networkError;

  /// No description provided for @accountExistsWithDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with the same email address, but using a different sign-in method.'**
  String get accountExistsWithDifferentCredential;

  /// No description provided for @operationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Google sign in is not enabled. Please contact support.'**
  String get operationNotAllowed;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get signInWithApple;

  /// No description provided for @appleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Error signing in with Apple: {message}'**
  String appleSignInError(String message);

  /// No description provided for @appleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in cancelled'**
  String get appleSignInCancelled;

  /// No description provided for @appleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with Apple: {error}'**
  String appleSignInFailed(String error);

  /// No description provided for @tideDataDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Official tide data is the responsibility of the Brazilian Navy.'**
  String get tideDataDisclaimer;

  /// No description provided for @tideExternalBrowserNotice.
  ///
  /// In en, this message translates to:
  /// **'When selecting one of the tables, you will be redirected to the official Brazilian Navy website'**
  String get tideExternalBrowserNotice;

  /// No description provided for @weatherForecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// No description provided for @errorLoadingForecast.
  ///
  /// In en, this message translates to:
  /// **'Error loading forecast'**
  String get errorLoadingForecast;

  /// No description provided for @noForecastAvailable.
  ///
  /// In en, this message translates to:
  /// **'No forecast available'**
  String get noForecastAvailable;

  /// No description provided for @marine.
  ///
  /// In en, this message translates to:
  /// **'Marine'**
  String get marine;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @waveHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get waveHeight;

  /// No description provided for @wavePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get wavePeriod;

  /// No description provided for @waveDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get waveDirection;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get temperature;

  /// No description provided for @dewPoint.
  ///
  /// In en, this message translates to:
  /// **'Dew Point'**
  String get dewPoint;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windSpeed;

  /// No description provided for @windDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get windDirection;

  /// No description provided for @windGusts.
  ///
  /// In en, this message translates to:
  /// **'Gusts'**
  String get windGusts;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @precipitation.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get precipitation;

  /// No description provided for @precipitationProbability.
  ///
  /// In en, this message translates to:
  /// **'Rain Prob.'**
  String get precipitationProbability;

  /// No description provided for @loginRequiredForForecast.
  ///
  /// In en, this message translates to:
  /// **'To access weather forecast, you need to be logged in.'**
  String get loginRequiredForForecast;

  /// No description provided for @loginRequiredForAction.
  ///
  /// In en, this message translates to:
  /// **'To perform this action you need to be logged in.'**
  String get loginRequiredForAction;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @addWeatherPin.
  ///
  /// In en, this message translates to:
  /// **'Add Weather Pin'**
  String get addWeatherPin;

  /// No description provided for @weatherPinsList.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherPinsList;

  /// No description provided for @pinName.
  ///
  /// In en, this message translates to:
  /// **'Pin Name'**
  String get pinName;

  /// No description provided for @enterPinName.
  ///
  /// In en, this message translates to:
  /// **'Enter pin name'**
  String get enterPinName;

  /// No description provided for @deletePin.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePin;

  /// No description provided for @editPinName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editPinName;

  /// No description provided for @noPinsAdded.
  ///
  /// In en, this message translates to:
  /// **'No pins added'**
  String get noPinsAdded;

  /// No description provided for @addingPinMode.
  ///
  /// In en, this message translates to:
  /// **'Adding Mode Active'**
  String get addingPinMode;

  /// No description provided for @tapMapToAddPin.
  ///
  /// In en, this message translates to:
  /// **'Hold on map to add'**
  String get tapMapToAddPin;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirmDeletePin.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the pin \"{pinName}\"?'**
  String confirmDeletePin(String pinName);

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all associated data'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently lost.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action is irreversible and will remove:'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountConfirmItems.
  ///
  /// In en, this message translates to:
  /// **'• Your authentication account\n• All saved routes\n• All associated data'**
  String get deleteAccountConfirmItems;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: {error}'**
  String deleteAccountError(String error);

  /// No description provided for @deleteAccountRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'To delete your account, you need to sign in again for security.'**
  String get deleteAccountRequiresRecentLogin;

  /// No description provided for @typeDeleteToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm'**
  String get typeDeleteToConfirm;

  /// No description provided for @backgroundLocationDisclosureTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Location Access'**
  String get backgroundLocationDisclosureTitle;

  /// No description provided for @backgroundLocationDisclosureBody.
  ///
  /// In en, this message translates to:
  /// **'This app collects your location data to enable route tracking and navigation even when the app is running in the background or the screen is off.\n\nThis allows you to:\n• Track your route during navigation without keeping the screen on\n• Receive accurate position updates continuously\n\nYour location data is only used for navigation and is not shared with third parties.'**
  String get backgroundLocationDisclosureBody;

  /// No description provided for @backgroundLocationAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get backgroundLocationAllow;

  /// No description provided for @backgroundLocationNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get backgroundLocationNotNow;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @signalKConfiguration.
  ///
  /// In en, this message translates to:
  /// **'SignalK Configuration'**
  String get signalKConfiguration;

  /// No description provided for @signalKConfigurationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure your local SignalK server to receive boat navigation data.'**
  String get signalKConfigurationDescription;

  /// No description provided for @signalKHost.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get signalKHost;

  /// No description provided for @signalKHostHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. este.signalk.local:3000'**
  String get signalKHostHint;

  /// No description provided for @signalKHostRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the server address'**
  String get signalKHostRequired;

  /// No description provided for @signalKToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get signalKToken;

  /// No description provided for @signalKTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the token generated in SignalK'**
  String get signalKTokenHint;

  /// No description provided for @signalKConfigurationSaved.
  ///
  /// In en, this message translates to:
  /// **'SignalK configuration saved'**
  String get signalKConfigurationSaved;

  /// No description provided for @signalKClearConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Clear configuration'**
  String get signalKClearConfiguration;

  /// No description provided for @rasterCharts.
  ///
  /// In en, this message translates to:
  /// **'Raster Charts (BSB/KAP)'**
  String get rasterCharts;

  /// No description provided for @rasterChartsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No charts imported'**
  String get rasterChartsEmptyTitle;

  /// No description provided for @rasterChartsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Import a raster chart .zip (BSB/KAP) from the Brazilian Navy to display it over the map.'**
  String get rasterChartsEmptyMessage;

  /// No description provided for @rasterChartImport.
  ///
  /// In en, this message translates to:
  /// **'Import chart'**
  String get rasterChartImport;

  /// No description provided for @rasterChartImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing chart...'**
  String get rasterChartImporting;

  /// No description provided for @rasterChartImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Chart imported successfully'**
  String get rasterChartImportSuccess;

  /// No description provided for @rasterChartRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove chart'**
  String get rasterChartRemoveTitle;

  /// No description provided for @rasterChartRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{name}\"?'**
  String rasterChartRemoveMessage(String name);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @rasterChartCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{chart} other{charts}}'**
  String rasterChartCount(int count);

  /// No description provided for @rasterChartProjectionWarning.
  ///
  /// In en, this message translates to:
  /// **'Projection {projection} not fully supported — approximate alignment.'**
  String rasterChartProjectionWarning(String projection);

  /// No description provided for @anchorAlarm.
  ///
  /// In en, this message translates to:
  /// **'Anchor Alarm'**
  String get anchorAlarm;

  /// No description provided for @anchorAlarmActive.
  ///
  /// In en, this message translates to:
  /// **'Anchor alarm active'**
  String get anchorAlarmActive;

  /// No description provided for @anchorAlarmSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Anchor Alarm'**
  String get anchorAlarmSetTitle;

  /// No description provided for @anchorAlarmRadius.
  ///
  /// In en, this message translates to:
  /// **'Safety radius (meters)'**
  String get anchorAlarmRadius;

  /// No description provided for @anchorAlarmRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50'**
  String get anchorAlarmRadiusHint;

  /// No description provided for @anchorAlarmRadiusError.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 1 and 9999'**
  String get anchorAlarmRadiusError;

  /// No description provided for @anchorAlarmUseCurrentPosition.
  ///
  /// In en, this message translates to:
  /// **'Use current position'**
  String get anchorAlarmUseCurrentPosition;

  /// No description provided for @anchorAlarmTapToSet.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to place the anchor'**
  String get anchorAlarmTapToSet;

  /// No description provided for @anchorAlarmTriggered.
  ///
  /// In en, this message translates to:
  /// **'Anchor Dragged!'**
  String get anchorAlarmTriggered;

  /// No description provided for @anchorAlarmTriggeredMessage.
  ///
  /// In en, this message translates to:
  /// **'You left the safety radius defined for the anchor.'**
  String get anchorAlarmTriggeredMessage;

  /// No description provided for @anchorAlarmDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable Alarm'**
  String get anchorAlarmDisable;

  /// No description provided for @anchorAlarmDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get anchorAlarmDismiss;

  /// No description provided for @anchorAlarmNotificationRationaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get anchorAlarmNotificationRationaleTitle;

  /// No description provided for @anchorAlarmNotificationRationaleBody.
  ///
  /// In en, this message translates to:
  /// **'The anchor alarm needs to send notifications to alert you when the anchor drags, even when the app is in the background or the screen is off.'**
  String get anchorAlarmNotificationRationaleBody;

  /// No description provided for @anchorAlarmNotificationBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications Blocked'**
  String get anchorAlarmNotificationBlockedTitle;

  /// No description provided for @anchorAlarmNotificationBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked for this app. To receive the anchor alarm, enable notifications in your system settings.'**
  String get anchorAlarmNotificationBlockedBody;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Estai'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'A quick tour of what you can do from the map screen.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingRoutesTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your routes'**
  String get onboardingRoutesTitle;

  /// No description provided for @onboardingRoutesDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a new route from the actions menu, long-press the map to add waypoints and save it for future trips.'**
  String get onboardingRoutesDescription;

  /// No description provided for @onboardingRasterChartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Brazilian Navy raster charts'**
  String get onboardingRasterChartsTitle;

  /// No description provided for @onboardingRasterChartsDescription.
  ///
  /// In en, this message translates to:
  /// **'Import official BSB/KAP nautical charts from the Brazilian Navy and overlay them on your map for accurate navigation.'**
  String get onboardingRasterChartsDescription;

  /// No description provided for @onboardingWeatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather forecast'**
  String get onboardingWeatherTitle;

  /// No description provided for @onboardingWeatherDescription.
  ///
  /// In en, this message translates to:
  /// **'Add weather pins along your route to check marine forecast, wind, waves and rain in advance.'**
  String get onboardingWeatherDescription;

  /// No description provided for @onboardingAnchorAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Anchor alarm'**
  String get onboardingAnchorAlarmTitle;

  /// No description provided for @onboardingAnchorAlarmDescription.
  ///
  /// In en, this message translates to:
  /// **'Define a safety radius after anchoring and get notified if the boat drifts beyond it, even with the screen off.'**
  String get onboardingAnchorAlarmDescription;

  /// No description provided for @onboardingMapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom maps'**
  String get onboardingMapsTitle;

  /// No description provided for @onboardingMapsDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick additional map layers from the catalog and download them for offline use during your trips.'**
  String get onboardingMapsDescription;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingPrevious.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingPrevious;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingFinish;

  /// No description provided for @onboardingStepProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String onboardingStepProgress(String current, String total);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
