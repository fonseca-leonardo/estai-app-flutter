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

  /// No description provided for @resumeNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume navigation?'**
  String get resumeNavigationTitle;

  /// No description provided for @resumeNavigationQuestion.
  ///
  /// In en, this message translates to:
  /// **'We detected an ongoing navigation started {duration} ago. Do you want to resume?'**
  String resumeNavigationQuestion(String duration);

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

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

  /// No description provided for @anchorAlarmDisableConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable the anchor alarm?'**
  String get anchorAlarmDisableConfirmTitle;

  /// No description provided for @anchorAlarmDisableConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will no longer be warned if the anchor drags.'**
  String get anchorAlarmDisableConfirmMessage;

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

  /// No description provided for @onboardingNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Start navigation'**
  String get onboardingNavigationTitle;

  /// No description provided for @onboardingNavigationDescription.
  ///
  /// In en, this message translates to:
  /// **'Begin navigation to track your trip in real time: stay on course, monitor distance, speed and your path on the map.'**
  String get onboardingNavigationDescription;

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

  /// No description provided for @onboardingBoatsTitle.
  ///
  /// In en, this message translates to:
  /// **'My boats'**
  String get onboardingBoatsTitle;

  /// No description provided for @onboardingBoatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Register your boats and keep track of everything in one place: a logbook with your saved trips, maintenance, engine hours and reminders by push or email.'**
  String get onboardingBoatsDescription;

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

  /// No description provided for @myBoats.
  ///
  /// In en, this message translates to:
  /// **'My Boats'**
  String get myBoats;

  /// No description provided for @myBoatsTooltip.
  ///
  /// In en, this message translates to:
  /// **'My Boats'**
  String get myBoatsTooltip;

  /// No description provided for @addBoat.
  ///
  /// In en, this message translates to:
  /// **'Add Boat'**
  String get addBoat;

  /// No description provided for @noBoatsFound.
  ///
  /// In en, this message translates to:
  /// **'No boats registered'**
  String get noBoatsFound;

  /// No description provided for @boatName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get boatName;

  /// No description provided for @boatModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get boatModel;

  /// No description provided for @boatYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get boatYear;

  /// No description provided for @boatType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get boatType;

  /// No description provided for @boatLength.
  ///
  /// In en, this message translates to:
  /// **'Length (feet)'**
  String get boatLength;

  /// No description provided for @pleaseEnterBoatName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the boat name'**
  String get pleaseEnterBoatName;

  /// No description provided for @pleaseEnterBoatModel.
  ///
  /// In en, this message translates to:
  /// **'Please enter the boat model'**
  String get pleaseEnterBoatModel;

  /// No description provided for @pleaseEnterValidYear.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get pleaseEnterValidYear;

  /// No description provided for @pleaseEnterValidLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid length'**
  String get pleaseEnterValidLength;

  /// No description provided for @deleteBoat.
  ///
  /// In en, this message translates to:
  /// **'Delete Boat'**
  String get deleteBoat;

  /// No description provided for @confirmDeleteBoat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this boat?'**
  String get confirmDeleteBoat;

  /// No description provided for @boatTypeJetski.
  ///
  /// In en, this message translates to:
  /// **'Jet Ski'**
  String get boatTypeJetski;

  /// No description provided for @boatTypeSailboat.
  ///
  /// In en, this message translates to:
  /// **'Sailboat'**
  String get boatTypeSailboat;

  /// No description provided for @boatTypeBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get boatTypeBoat;

  /// No description provided for @boatTypeYacht.
  ///
  /// In en, this message translates to:
  /// **'Yacht'**
  String get boatTypeYacht;

  /// No description provided for @editBoat.
  ///
  /// In en, this message translates to:
  /// **'Edit Boat'**
  String get editBoat;

  /// No description provided for @loadBoatsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your boats.'**
  String get loadBoatsError;

  /// No description provided for @saveBoatError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the boat. Try again.'**
  String get saveBoatError;

  /// No description provided for @deleteBoatError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the boat. Try again.'**
  String get deleteBoatError;

  /// No description provided for @signalKIosLocalNetworkNotice.
  ///
  /// In en, this message translates to:
  /// **'On the first connection, iOS will request local network access. Allow it so the app can communicate with the SignalK server.'**
  String get signalKIosLocalNetworkNotice;

  /// No description provided for @marinaAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Marina'**
  String get marinaAccessTitle;

  /// No description provided for @marinaAccessInviteMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been invited to join this marina. Select the boats you want to link.'**
  String get marinaAccessInviteMessage;

  /// No description provided for @selectBoatsToAssociate.
  ///
  /// In en, this message translates to:
  /// **'Select your boats'**
  String get selectBoatsToAssociate;

  /// No description provided for @noBoatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any boats registered yet. You can continue without selecting any.'**
  String get noBoatsAvailable;

  /// No description provided for @confirmAssociation.
  ///
  /// In en, this message translates to:
  /// **'Confirm association'**
  String get confirmAssociation;

  /// No description provided for @associationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Association complete!'**
  String get associationSuccessTitle;

  /// No description provided for @associationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You are now associated with {marinaName}.'**
  String associationSuccessMessage(String marinaName);

  /// No description provided for @backToApp.
  ///
  /// In en, this message translates to:
  /// **'Back to app'**
  String get backToApp;

  /// No description provided for @loadMarinaError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the marina data.'**
  String get loadMarinaError;

  /// No description provided for @associationError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the association. Try again.'**
  String get associationError;

  /// No description provided for @marinaAccessToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Marina access'**
  String get marinaAccessToggleLabel;

  /// No description provided for @marinaAccessToggleDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow the marina to view and manage this boat.'**
  String get marinaAccessToggleDescription;

  /// No description provided for @marinaAccessToggleError.
  ///
  /// In en, this message translates to:
  /// **'Could not update marina access. Try again.'**
  String get marinaAccessToggleError;

  /// No description provided for @marinaHubTooltip.
  ///
  /// In en, this message translates to:
  /// **'My marina'**
  String get marinaHubTooltip;

  /// No description provided for @marinaHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Marina'**
  String get marinaHomeTitle;

  /// No description provided for @marinaHomeMyBoatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your boats'**
  String get marinaHomeMyBoatsSubtitle;

  /// No description provided for @newServiceOrder.
  ///
  /// In en, this message translates to:
  /// **'New service order'**
  String get newServiceOrder;

  /// No description provided for @newServiceOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request a service for your boat'**
  String get newServiceOrderSubtitle;

  /// No description provided for @myServiceOrders.
  ///
  /// In en, this message translates to:
  /// **'My service orders'**
  String get myServiceOrders;

  /// No description provided for @myServiceOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track the progress of your orders'**
  String get myServiceOrdersSubtitle;

  /// No description provided for @recentServiceOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get recentServiceOrders;

  /// No description provided for @seeAllServiceOrders.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAllServiceOrders;

  /// No description provided for @noServiceOrders.
  ///
  /// In en, this message translates to:
  /// **'No service orders yet'**
  String get noServiceOrders;

  /// No description provided for @noServiceOrdersWithFilter.
  ///
  /// In en, this message translates to:
  /// **'No service orders with this status'**
  String get noServiceOrdersWithFilter;

  /// No description provided for @loadServiceOrdersError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your service orders.'**
  String get loadServiceOrdersError;

  /// No description provided for @serviceOrderStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get serviceOrderStatusAll;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @serviceOrderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get serviceOrderStatusPending;

  /// No description provided for @serviceOrderStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get serviceOrderStatusScheduled;

  /// No description provided for @serviceOrderStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get serviceOrderStatusInProgress;

  /// No description provided for @serviceOrderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get serviceOrderStatusCompleted;

  /// No description provided for @serviceOrderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get serviceOrderStatusCancelled;

  /// No description provided for @selectBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get selectBoat;

  /// No description provided for @pleaseSelectBoat.
  ///
  /// In en, this message translates to:
  /// **'Select a boat'**
  String get pleaseSelectBoat;

  /// No description provided for @selectService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get selectService;

  /// No description provided for @pleaseSelectService.
  ///
  /// In en, this message translates to:
  /// **'Select a service'**
  String get pleaseSelectService;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @estimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'List price'**
  String get estimatedPrice;

  /// No description provided for @createServiceOrder.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get createServiceOrder;

  /// No description provided for @serviceOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Service order created'**
  String get serviceOrderCreated;

  /// No description provided for @createServiceOrderError.
  ///
  /// In en, this message translates to:
  /// **'Could not create the service order. Try again.'**
  String get createServiceOrderError;

  /// No description provided for @noMarinaBoats.
  ///
  /// In en, this message translates to:
  /// **'No boats linked to the marina'**
  String get noMarinaBoats;

  /// No description provided for @noMarinaBoatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Link a boat to the marina to request services.'**
  String get noMarinaBoatsDescription;

  /// No description provided for @manageBoatsCta.
  ///
  /// In en, this message translates to:
  /// **'Manage my boats'**
  String get manageBoatsCta;

  /// No description provided for @emptyServiceCatalog.
  ///
  /// In en, this message translates to:
  /// **'The marina has no services yet'**
  String get emptyServiceCatalog;

  /// No description provided for @loadPriceItemsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load available services.'**
  String get loadPriceItemsError;

  /// No description provided for @cancelServiceOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelServiceOrder;

  /// No description provided for @cancelServiceOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this service order?'**
  String get cancelServiceOrderConfirm;

  /// No description provided for @cancelServiceOrderError.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel the service order. Try again.'**
  String get cancelServiceOrderError;

  /// No description provided for @keepOrder.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keepOrder;

  /// No description provided for @unitPerUnit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get unitPerUnit;

  /// No description provided for @unitPerHour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get unitPerHour;

  /// No description provided for @unitPerDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get unitPerDay;

  /// No description provided for @unitPerMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get unitPerMonth;

  /// No description provided for @selectBoatTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your boat'**
  String get selectBoatTitle;

  /// No description provided for @selectBoatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your marina will track this boat\'s position during navigation.'**
  String get selectBoatSubtitle;

  /// No description provided for @startNavigationAction.
  ///
  /// In en, this message translates to:
  /// **'Start navigation'**
  String get startNavigationAction;

  /// No description provided for @startWithoutMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Start without monitoring'**
  String get startWithoutMonitoring;

  /// No description provided for @noBoatsMonitoringWarning.
  ///
  /// In en, this message translates to:
  /// **'You have no boats linked to your marina, so it won\'t monitor this trip.'**
  String get noBoatsMonitoringWarning;

  /// No description provided for @registerBoat.
  ///
  /// In en, this message translates to:
  /// **'Register boat'**
  String get registerBoat;

  /// No description provided for @startAnyway.
  ///
  /// In en, this message translates to:
  /// **'Start anyway'**
  String get startAnyway;

  /// No description provided for @rampTypeLaunch.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get rampTypeLaunch;

  /// No description provided for @rampTypeHaul.
  ///
  /// In en, this message translates to:
  /// **'Haul'**
  String get rampTypeHaul;

  /// No description provided for @rampStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get rampStatusPending;

  /// No description provided for @rampStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get rampStatusConfirmed;

  /// No description provided for @rampStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get rampStatusInProgress;

  /// No description provided for @rampStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get rampStatusCompleted;

  /// No description provided for @rampStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get rampStatusCancelled;

  /// No description provided for @rampStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rampStatusRejected;

  /// No description provided for @rampStatusNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-show'**
  String get rampStatusNoShow;

  /// No description provided for @rampBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Book the ramp'**
  String get rampBookingTitle;

  /// No description provided for @rampBookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Launch or haul your boat at the marina ramp'**
  String get rampBookingSubtitle;

  /// No description provided for @myRampSchedules.
  ///
  /// In en, this message translates to:
  /// **'My ramp bookings'**
  String get myRampSchedules;

  /// No description provided for @myRampSchedulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the approval of your requests'**
  String get myRampSchedulesSubtitle;

  /// No description provided for @upcomingRampSchedules.
  ///
  /// In en, this message translates to:
  /// **'Next at the ramp'**
  String get upcomingRampSchedules;

  /// No description provided for @seeAllRampSchedules.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAllRampSchedules;

  /// No description provided for @noUpcomingRampSchedules.
  ///
  /// In en, this message translates to:
  /// **'No upcoming ramp bookings'**
  String get noUpcomingRampSchedules;

  /// No description provided for @rampStepRamp.
  ///
  /// In en, this message translates to:
  /// **'Ramp'**
  String get rampStepRamp;

  /// No description provided for @rampStepBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get rampStepBoat;

  /// No description provided for @rampStepOperation.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get rampStepOperation;

  /// No description provided for @rampStepSlot.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get rampStepSlot;

  /// No description provided for @rampStepReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get rampStepReturn;

  /// No description provided for @rampStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get rampStepReview;

  /// No description provided for @rampSelectRampTitle.
  ///
  /// In en, this message translates to:
  /// **'Which ramp will you use?'**
  String get rampSelectRampTitle;

  /// No description provided for @rampSelectBoatTitle.
  ///
  /// In en, this message translates to:
  /// **'Which boat?'**
  String get rampSelectBoatTitle;

  /// No description provided for @rampOperationTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get rampOperationTitle;

  /// No description provided for @rampLaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'Launch the boat'**
  String get rampLaunchTitle;

  /// No description provided for @rampLaunchDescription.
  ///
  /// In en, this message translates to:
  /// **'Put the boat in the water'**
  String get rampLaunchDescription;

  /// No description provided for @rampHaulTitle.
  ///
  /// In en, this message translates to:
  /// **'Haul the boat'**
  String get rampHaulTitle;

  /// No description provided for @rampHaulDescription.
  ///
  /// In en, this message translates to:
  /// **'Take the boat out of the water'**
  String get rampHaulDescription;

  /// No description provided for @rampSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the day and time'**
  String get rampSlotTitle;

  /// No description provided for @rampMinAdvanceHint.
  ///
  /// In en, this message translates to:
  /// **'Book at least {value} in advance'**
  String rampMinAdvanceHint(String value);

  /// No description provided for @rampNoSlotsForDay.
  ///
  /// In en, this message translates to:
  /// **'No times on this day'**
  String get rampNoSlotsForDay;

  /// No description provided for @rampSlotFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get rampSlotFull;

  /// No description provided for @rampSlotBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get rampSlotBlocked;

  /// No description provided for @rampSlotUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get rampSlotUnavailable;

  /// No description provided for @rampSlotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 spot} other{{count} spots}}'**
  String rampSlotsLeft(int count);

  /// No description provided for @rampLoadSlotsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the available times.'**
  String get rampLoadSlotsError;

  /// No description provided for @rampReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Will you haul the boat afterwards?'**
  String get rampReturnTitle;

  /// No description provided for @rampReturnToggle.
  ///
  /// In en, this message translates to:
  /// **'Book the return haul'**
  String get rampReturnToggle;

  /// No description provided for @rampReturnDescription.
  ///
  /// In en, this message translates to:
  /// **'The haul is booked together with the launch, in a single request.'**
  String get rampReturnDescription;

  /// No description provided for @rampReturnAfter.
  ///
  /// In en, this message translates to:
  /// **'Times from {time}'**
  String rampReturnAfter(String time);

  /// No description provided for @rampReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your request'**
  String get rampReviewTitle;

  /// No description provided for @rampReviewRamp.
  ///
  /// In en, this message translates to:
  /// **'Ramp'**
  String get rampReviewRamp;

  /// No description provided for @rampReviewBoat.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get rampReviewBoat;

  /// No description provided for @rampReviewOperation.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get rampReviewOperation;

  /// No description provided for @rampReviewWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get rampReviewWhen;

  /// No description provided for @rampReviewReturn.
  ///
  /// In en, this message translates to:
  /// **'Return haul'**
  String get rampReviewReturn;

  /// No description provided for @rampAutoConfirmInfo.
  ///
  /// In en, this message translates to:
  /// **'This ramp confirms your request right away.'**
  String get rampAutoConfirmInfo;

  /// No description provided for @rampPendingInfo.
  ///
  /// In en, this message translates to:
  /// **'The marina will review your request. Follow its status in My ramp bookings.'**
  String get rampPendingInfo;

  /// No description provided for @rampNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes for the marina (optional)'**
  String get rampNotesHint;

  /// No description provided for @rampContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get rampContinue;

  /// No description provided for @rampSubmit.
  ///
  /// In en, this message translates to:
  /// **'Request booking'**
  String get rampSubmit;

  /// No description provided for @rampBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get rampBookingConfirmed;

  /// No description provided for @rampBookingRequested.
  ///
  /// In en, this message translates to:
  /// **'Request sent. Wait for the marina\'s approval.'**
  String get rampBookingRequested;

  /// No description provided for @rampConflictError.
  ///
  /// In en, this message translates to:
  /// **'That time was just taken. Please choose another one.'**
  String get rampConflictError;

  /// No description provided for @rampCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not send the request. Please try again.'**
  String get rampCreateError;

  /// No description provided for @rampNoMarinaTitle.
  ///
  /// In en, this message translates to:
  /// **'You are not linked to a marina yet'**
  String get rampNoMarinaTitle;

  /// No description provided for @rampNoMarinaDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask your marina to grant you access on Estai.'**
  String get rampNoMarinaDescription;

  /// No description provided for @rampNoRampsTitle.
  ///
  /// In en, this message translates to:
  /// **'No ramps available'**
  String get rampNoRampsTitle;

  /// No description provided for @rampNoRampsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your marina has not enabled ramp booking in the app yet.'**
  String get rampNoRampsDescription;

  /// No description provided for @rampLoadRampsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the ramps.'**
  String get rampLoadRampsError;

  /// No description provided for @rampTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get rampTabUpcoming;

  /// No description provided for @rampTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get rampTabHistory;

  /// No description provided for @noRampSchedulesHistory.
  ///
  /// In en, this message translates to:
  /// **'No bookings in your history'**
  String get noRampSchedulesHistory;

  /// No description provided for @loadRampSchedulesError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your bookings.'**
  String get loadRampSchedulesError;

  /// No description provided for @rampReturnBadge.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get rampReturnBadge;

  /// No description provided for @rampRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String rampRejectionReason(String reason);

  /// No description provided for @cancelRampSchedule.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelRampSchedule;

  /// No description provided for @cancelRampScheduleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelRampScheduleConfirm;

  /// No description provided for @cancelRampScheduleAlsoReturn.
  ///
  /// In en, this message translates to:
  /// **'Also cancel the return haul ({date})'**
  String cancelRampScheduleAlsoReturn(String date);

  /// No description provided for @keepRampSchedule.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keepRampSchedule;

  /// No description provided for @cancelRampScheduleError.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel the booking. Please try again.'**
  String get cancelRampScheduleError;

  /// No description provided for @rampNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'New booking'**
  String get rampNewSchedule;

  /// No description provided for @marinaQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get marinaQuickActionsTitle;

  /// No description provided for @marinaActionServiceOrder.
  ///
  /// In en, this message translates to:
  /// **'Request service'**
  String get marinaActionServiceOrder;

  /// No description provided for @marinaTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get marinaTrackingTitle;

  /// No description provided for @marinaTrackingRamp.
  ///
  /// In en, this message translates to:
  /// **'Ramp'**
  String get marinaTrackingRamp;

  /// No description provided for @marinaTrackingServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get marinaTrackingServices;

  /// No description provided for @marinaSeeAllRampSchedules.
  ///
  /// In en, this message translates to:
  /// **'See all bookings'**
  String get marinaSeeAllRampSchedules;

  /// No description provided for @marinaSeeAllServiceOrders.
  ///
  /// In en, this message translates to:
  /// **'See all orders'**
  String get marinaSeeAllServiceOrders;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminderChannelName;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Boat maintenance reminders'**
  String get reminderChannelDescription;

  /// No description provided for @pushPermissionRationaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get pushPermissionRationaleTitle;

  /// No description provided for @pushPermissionRationaleBody.
  ///
  /// In en, this message translates to:
  /// **'To let you know when maintenance is coming up, Estai needs to send notifications to this device.'**
  String get pushPermissionRationaleBody;

  /// No description provided for @pushPermissionBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications blocked'**
  String get pushPermissionBlockedTitle;

  /// No description provided for @pushPermissionBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Estai notifications are turned off. Turn them on in your device settings to receive reminders.'**
  String get pushPermissionBlockedBody;

  /// No description provided for @notificationChannelPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get notificationChannelPush;

  /// No description provided for @notificationChannelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get notificationChannelEmail;

  /// No description provided for @maintenanceStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get maintenanceStatusScheduled;

  /// No description provided for @maintenanceStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get maintenanceStatusOverdue;

  /// No description provided for @maintenanceStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get maintenanceStatusDone;

  /// No description provided for @maintenanceCategoryEngine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get maintenanceCategoryEngine;

  /// No description provided for @maintenanceCategoryHull.
  ///
  /// In en, this message translates to:
  /// **'Hull'**
  String get maintenanceCategoryHull;

  /// No description provided for @maintenanceCategoryElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get maintenanceCategoryElectrical;

  /// No description provided for @maintenanceCategoryPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get maintenanceCategoryPlumbing;

  /// No description provided for @maintenanceCategorySafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get maintenanceCategorySafety;

  /// No description provided for @maintenanceCategoryRigging.
  ///
  /// In en, this message translates to:
  /// **'Rigging'**
  String get maintenanceCategoryRigging;

  /// No description provided for @maintenanceCategoryElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get maintenanceCategoryElectronics;

  /// No description provided for @maintenanceCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get maintenanceCategoryOther;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Boat journal'**
  String get journalTitle;

  /// No description provided for @journalEngineHours.
  ///
  /// In en, this message translates to:
  /// **'Engine hours'**
  String get journalEngineHours;

  /// No description provided for @engineHoursValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String engineHoursValue(String hours);

  /// No description provided for @journalEngineHoursUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get journalEngineHoursUnknown;

  /// No description provided for @journalEngineHoursReadAt.
  ///
  /// In en, this message translates to:
  /// **'Updated on {date}'**
  String journalEngineHoursReadAt(String date);

  /// No description provided for @journalUpdateEngineHours.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get journalUpdateEngineHours;

  /// No description provided for @journalQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get journalQuickActionsTitle;

  /// No description provided for @journalActionMaintenances.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get journalActionMaintenances;

  /// No description provided for @journalUpcomingMaintenancesTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming maintenance'**
  String get journalUpcomingMaintenancesTitle;

  /// No description provided for @journalSeeAllMaintenances.
  ///
  /// In en, this message translates to:
  /// **'See all maintenance'**
  String get journalSeeAllMaintenances;

  /// No description provided for @journalOverdueAlert.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 overdue maintenance} other{{count} overdue maintenance items}}'**
  String journalOverdueAlert(int count);

  /// No description provided for @journalLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the boat journal.'**
  String get journalLoadError;

  /// No description provided for @engineHoursSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Update engine hours'**
  String get engineHoursSheetTitle;

  /// No description provided for @engineHoursSheetHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the current engine hour meter reading.'**
  String get engineHoursSheetHint;

  /// No description provided for @engineHoursFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Engine hours'**
  String get engineHoursFieldLabel;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number.'**
  String get invalidNumber;

  /// No description provided for @engineHoursLowerThanCurrent.
  ///
  /// In en, this message translates to:
  /// **'The reading can\'t be lower than the current one ({hours} h).'**
  String engineHoursLowerThanCurrent(String hours);

  /// No description provided for @engineHoursSaved.
  ///
  /// In en, this message translates to:
  /// **'Engine hours updated.'**
  String get engineHoursSaved;

  /// No description provided for @engineHoursSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the engine hours.'**
  String get engineHoursSaveError;

  /// No description provided for @maintenancesTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenancesTitle;

  /// No description provided for @maintenanceTabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get maintenanceTabUpcoming;

  /// No description provided for @maintenanceTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get maintenanceTabHistory;

  /// No description provided for @maintenanceNew.
  ///
  /// In en, this message translates to:
  /// **'New maintenance'**
  String get maintenanceNew;

  /// No description provided for @maintenanceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit maintenance'**
  String get maintenanceEditTitle;

  /// No description provided for @noUpcomingMaintenances.
  ///
  /// In en, this message translates to:
  /// **'No maintenance scheduled.'**
  String get noUpcomingMaintenances;

  /// No description provided for @noMaintenancesHistory.
  ///
  /// In en, this message translates to:
  /// **'No completed maintenance yet.'**
  String get noMaintenancesHistory;

  /// No description provided for @loadMaintenancesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load maintenance.'**
  String get loadMaintenancesError;

  /// No description provided for @maintenanceScheduleFirst.
  ///
  /// In en, this message translates to:
  /// **'Schedule maintenance'**
  String get maintenanceScheduleFirst;

  /// No description provided for @maintenanceDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get maintenanceDueToday;

  /// No description provided for @maintenanceDueInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Due tomorrow} other{Due in {count} days}}'**
  String maintenanceDueInDays(int count);

  /// No description provided for @maintenanceOverdueDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day overdue} other{{count} days overdue}}'**
  String maintenanceOverdueDays(int count);

  /// No description provided for @maintenanceDueInHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h left'**
  String maintenanceDueInHours(String hours);

  /// No description provided for @maintenanceOverdueHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h overdue'**
  String maintenanceOverdueHours(String hours);

  /// No description provided for @maintenanceDueAtHours.
  ///
  /// In en, this message translates to:
  /// **'At {hours} h'**
  String maintenanceDueAtHours(String hours);

  /// No description provided for @maintenanceCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String maintenanceCompletedOn(String date);

  /// No description provided for @maintenanceRecurringBadge.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get maintenanceRecurringBadge;

  /// No description provided for @maintenanceComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get maintenanceComplete;

  /// No description provided for @maintenanceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Maintenance completed.'**
  String get maintenanceCompleted;

  /// No description provided for @completeMaintenanceError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete the maintenance.'**
  String get completeMaintenanceError;

  /// No description provided for @completeMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete maintenance'**
  String get completeMaintenanceTitle;

  /// No description provided for @completeMaintenanceDate.
  ///
  /// In en, this message translates to:
  /// **'Completion date'**
  String get completeMaintenanceDate;

  /// No description provided for @completeMaintenanceEngineHours.
  ///
  /// In en, this message translates to:
  /// **'Engine hours at completion (optional)'**
  String get completeMaintenanceEngineHours;

  /// No description provided for @completeMaintenanceCost.
  ///
  /// In en, this message translates to:
  /// **'Cost (optional)'**
  String get completeMaintenanceCost;

  /// No description provided for @completeMaintenanceRecurringHint.
  ///
  /// In en, this message translates to:
  /// **'Since it\'s recurring, the next one will be scheduled automatically.'**
  String get completeMaintenanceRecurringHint;

  /// No description provided for @maintenanceTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get maintenanceTitleLabel;

  /// No description provided for @maintenanceTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. engine oil change'**
  String get maintenanceTitleHint;

  /// No description provided for @maintenanceTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get maintenanceTitleRequired;

  /// No description provided for @maintenanceCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get maintenanceCategoryLabel;

  /// No description provided for @maintenanceDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get maintenanceDescriptionLabel;

  /// No description provided for @maintenanceDueSection.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get maintenanceDueSection;

  /// No description provided for @maintenanceDueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a date, engine hours or both. Whichever comes first applies.'**
  String get maintenanceDueHint;

  /// No description provided for @maintenanceDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get maintenanceDueDateLabel;

  /// No description provided for @maintenanceDueDateNone.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get maintenanceDueDateNone;

  /// No description provided for @maintenanceDueEngineHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Engine hours (h)'**
  String get maintenanceDueEngineHoursLabel;

  /// No description provided for @maintenanceMissingDue.
  ///
  /// In en, this message translates to:
  /// **'Enter the due date or engine hours.'**
  String get maintenanceMissingDue;

  /// No description provided for @maintenanceRecurrenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get maintenanceRecurrenceTitle;

  /// No description provided for @maintenanceRecurrenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When completed, the next one is scheduled automatically.'**
  String get maintenanceRecurrenceSubtitle;

  /// No description provided for @maintenanceRecurrenceMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Every (months)'**
  String get maintenanceRecurrenceMonthsLabel;

  /// No description provided for @maintenanceRecurrenceHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Every (hours)'**
  String get maintenanceRecurrenceHoursLabel;

  /// No description provided for @maintenanceRecurrenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter months or hours to repeat.'**
  String get maintenanceRecurrenceRequired;

  /// No description provided for @maintenanceProviderLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop or provider (optional)'**
  String get maintenanceProviderLabel;

  /// No description provided for @maintenanceSave.
  ///
  /// In en, this message translates to:
  /// **'Save maintenance'**
  String get maintenanceSave;

  /// No description provided for @maintenanceSaved.
  ///
  /// In en, this message translates to:
  /// **'Maintenance saved.'**
  String get maintenanceSaved;

  /// No description provided for @saveMaintenanceError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the maintenance.'**
  String get saveMaintenanceError;

  /// No description provided for @maintenanceInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Check the maintenance details.'**
  String get maintenanceInvalidError;

  /// No description provided for @deleteMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Delete maintenance'**
  String get deleteMaintenance;

  /// No description provided for @deleteMaintenanceConfirm.
  ///
  /// In en, this message translates to:
  /// **'This maintenance and its reminders will be removed.'**
  String get deleteMaintenanceConfirm;

  /// No description provided for @deleteMaintenanceError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the maintenance.'**
  String get deleteMaintenanceError;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderTitle;

  /// No description provided for @reminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sent by Estai before it\'s due.'**
  String get reminderSubtitle;

  /// No description provided for @reminderDaysBeforeLabel.
  ///
  /// In en, this message translates to:
  /// **'Remind me before'**
  String get reminderDaysBeforeLabel;

  /// No description provided for @reminderDaysOption.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{On the day} =1{1 day} other{{count} days}}'**
  String reminderDaysOption(int count);

  /// No description provided for @reminderHoursBeforeLabel.
  ///
  /// In en, this message translates to:
  /// **'Remind me before (engine hours)'**
  String get reminderHoursBeforeLabel;

  /// No description provided for @reminderChannelsLabel.
  ///
  /// In en, this message translates to:
  /// **'Send via'**
  String get reminderChannelsLabel;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettings;

  /// No description provided for @notificationPrefsDescription.
  ///
  /// In en, this message translates to:
  /// **'Maintenance reminders are sent by Estai through the channels you turn on.'**
  String get notificationPrefsDescription;

  /// No description provided for @notificationPrefsPush.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get notificationPrefsPush;

  /// No description provided for @notificationPrefsPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On your phone, even with the app closed.'**
  String get notificationPrefsPushSubtitle;

  /// No description provided for @notificationPrefsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get notificationPrefsEmail;

  /// No description provided for @notificationPrefsEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sent to {email}'**
  String notificationPrefsEmailSubtitle(String email);

  /// No description provided for @notificationPrefsEmailSubtitleNoEmail.
  ///
  /// In en, this message translates to:
  /// **'Sent to your account email.'**
  String get notificationPrefsEmailSubtitleNoEmail;

  /// No description provided for @notificationPrefsSystemBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off on this device. Allow them to receive push reminders.'**
  String get notificationPrefsSystemBlocked;

  /// No description provided for @notificationPrefsAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notificationPrefsAllow;

  /// No description provided for @notificationPrefsSendTest.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get notificationPrefsSendTest;

  /// No description provided for @notificationPrefsTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent.'**
  String get notificationPrefsTestSent;

  /// No description provided for @notificationPrefsTestError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the test notification.'**
  String get notificationPrefsTestError;

  /// No description provided for @notificationPrefsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your preferences.'**
  String get notificationPrefsLoadError;

  /// No description provided for @notificationPrefsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your preferences.'**
  String get notificationPrefsSaveError;

  /// No description provided for @maintenanceAlreadyDone.
  ///
  /// In en, this message translates to:
  /// **'Already done'**
  String get maintenanceAlreadyDone;

  /// No description provided for @maintenanceAlreadyDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log maintenance that has already been done.'**
  String get maintenanceAlreadyDoneSubtitle;

  /// No description provided for @maintenanceCompletionSection.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get maintenanceCompletionSection;

  /// No description provided for @maintenanceRecurrenceSubtitleCompleted.
  ///
  /// In en, this message translates to:
  /// **'The next one is scheduled from the completion date.'**
  String get maintenanceRecurrenceSubtitleCompleted;

  /// No description provided for @maintenanceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed maintenance'**
  String get maintenanceDetailsTitle;

  /// No description provided for @maintenanceDetailsInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get maintenanceDetailsInfoSection;

  /// No description provided for @maintenanceDetailsEngineHours.
  ///
  /// In en, this message translates to:
  /// **'Engine hours at completion'**
  String get maintenanceDetailsEngineHours;

  /// No description provided for @maintenanceDetailsCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get maintenanceDetailsCost;

  /// No description provided for @maintenanceDetailsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get maintenanceDetailsNotes;

  /// No description provided for @maintenanceDetailsProvider.
  ///
  /// In en, this message translates to:
  /// **'Shop or provider'**
  String get maintenanceDetailsProvider;

  /// No description provided for @maintenanceDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get maintenanceDetailsDescription;

  /// No description provided for @maintenanceDetailsOriginalDue.
  ///
  /// In en, this message translates to:
  /// **'Original due'**
  String get maintenanceDetailsOriginalDue;

  /// No description provided for @maintenanceDetailsRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get maintenanceDetailsRecurrence;

  /// No description provided for @maintenanceDetailsNotInformed.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get maintenanceDetailsNotInformed;

  /// No description provided for @maintenanceRecurrenceEveryMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every month} other{Every {count} months}}'**
  String maintenanceRecurrenceEveryMonths(int count);

  /// No description provided for @maintenanceRecurrenceEveryHours.
  ///
  /// In en, this message translates to:
  /// **'Every {hours} h'**
  String maintenanceRecurrenceEveryHours(String hours);

  /// No description provided for @logbookTypeTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get logbookTypeTrip;

  /// No description provided for @logbookTypeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get logbookTypeNote;

  /// No description provided for @logbookTypeAnchorage.
  ///
  /// In en, this message translates to:
  /// **'Anchorage'**
  String get logbookTypeAnchorage;

  /// No description provided for @logbookTypeIncident.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get logbookTypeIncident;

  /// No description provided for @logbookTypeEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get logbookTypeEvent;

  /// No description provided for @logbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Logbook'**
  String get logbookTitle;

  /// No description provided for @logbookFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get logbookFilterAll;

  /// No description provided for @logbookNewEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get logbookNewEntry;

  /// No description provided for @logbookEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get logbookEditEntry;

  /// No description provided for @noLogbookEntries.
  ///
  /// In en, this message translates to:
  /// **'No logbook entries yet.'**
  String get noLogbookEntries;

  /// No description provided for @loadLogbookError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the logbook.'**
  String get loadLogbookError;

  /// No description provided for @logbookTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get logbookTypeLabel;

  /// No description provided for @logbookTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get logbookTitleLabel;

  /// No description provided for @logbookTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get logbookTitleRequired;

  /// No description provided for @logbookDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get logbookDateLabel;

  /// No description provided for @logbookTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get logbookTimeLabel;

  /// No description provided for @logbookUseCurrentPosition.
  ///
  /// In en, this message translates to:
  /// **'Record current position'**
  String get logbookUseCurrentPosition;

  /// No description provided for @logbookUseCurrentPositionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saves where the boat is right now.'**
  String get logbookUseCurrentPositionSubtitle;

  /// No description provided for @logbookPositionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Current position unavailable. Check the GPS.'**
  String get logbookPositionUnavailable;

  /// No description provided for @logbookSave.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get logbookSave;

  /// No description provided for @logbookSaved.
  ///
  /// In en, this message translates to:
  /// **'Entry saved.'**
  String get logbookSaved;

  /// No description provided for @saveLogbookEntryError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the entry.'**
  String get saveLogbookEntryError;

  /// No description provided for @logbookInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Check the entry details.'**
  String get logbookInvalidError;

  /// No description provided for @deleteLogbookEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteLogbookEntry;

  /// No description provided for @deleteLogbookEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'This entry will be removed from the logbook.'**
  String get deleteLogbookEntryConfirm;

  /// No description provided for @deleteLogbookEntryError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the entry.'**
  String get deleteLogbookEntryError;

  /// No description provided for @logbookDetailsInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get logbookDetailsInfoSection;

  /// No description provided for @logbookDetailsTripSection.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get logbookDetailsTripSection;

  /// No description provided for @logbookTripMapExpand.
  ///
  /// In en, this message translates to:
  /// **'Expand map'**
  String get logbookTripMapExpand;

  /// No description provided for @logbookTripMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get logbookTripMapTitle;

  /// No description provided for @logbookDetailsDate.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get logbookDetailsDate;

  /// No description provided for @logbookDetailsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get logbookDetailsDuration;

  /// No description provided for @logbookDetailsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get logbookDetailsDistance;

  /// No description provided for @logbookDetailsAvgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average speed'**
  String get logbookDetailsAvgSpeed;

  /// No description provided for @logbookDetailsMaxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Top speed'**
  String get logbookDetailsMaxSpeed;

  /// No description provided for @logbookDetailsEngineHoursEnd.
  ///
  /// In en, this message translates to:
  /// **'Engine hours at the end'**
  String get logbookDetailsEngineHoursEnd;

  /// No description provided for @logbookDetailsPassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get logbookDetailsPassengers;

  /// No description provided for @logbookDetailsPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get logbookDetailsPosition;

  /// No description provided for @logbookDetailsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get logbookDetailsNotes;

  /// No description provided for @distanceNmValue.
  ///
  /// In en, this message translates to:
  /// **'{value} NM'**
  String distanceNmValue(String value);

  /// No description provided for @speedKnValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kn'**
  String speedKnValue(String value);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHoursMinutes(String hours, String minutes);

  /// No description provided for @durationMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutesValue(String minutes);

  /// No description provided for @logbookTopSpeed.
  ///
  /// In en, this message translates to:
  /// **'top {value} kn'**
  String logbookTopSpeed(String value);

  /// No description provided for @journalRecentLogbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest entries'**
  String get journalRecentLogbookTitle;

  /// No description provided for @journalSeeLogbook.
  ///
  /// In en, this message translates to:
  /// **'See logbook'**
  String get journalSeeLogbook;

  /// No description provided for @journalNoLogbookEntries.
  ///
  /// In en, this message translates to:
  /// **'Trips you save when finishing a navigation show up here.'**
  String get journalNoLogbookEntries;

  /// No description provided for @tripSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save trip to the logbook'**
  String get tripSaveTitle;

  /// No description provided for @tripSaveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log this navigation in the boat\'s logbook.'**
  String get tripSaveSubtitle;

  /// No description provided for @tripBoatLabel.
  ///
  /// In en, this message translates to:
  /// **'Boat'**
  String get tripBoatLabel;

  /// No description provided for @tripDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip on {date}'**
  String tripDefaultTitle(String date);

  /// No description provided for @tripEngineHoursEndLabel.
  ///
  /// In en, this message translates to:
  /// **'Engine hours at the end (optional)'**
  String get tripEngineHoursEndLabel;

  /// No description provided for @tripPassengersLabel.
  ///
  /// In en, this message translates to:
  /// **'Passengers (optional)'**
  String get tripPassengersLabel;

  /// No description provided for @tripSave.
  ///
  /// In en, this message translates to:
  /// **'Save to logbook'**
  String get tripSave;

  /// No description provided for @tripDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get tripDiscard;

  /// No description provided for @tripSaved.
  ///
  /// In en, this message translates to:
  /// **'Trip saved to the logbook.'**
  String get tripSaved;

  /// No description provided for @tripQueued.
  ///
  /// In en, this message translates to:
  /// **'No connection. The trip will be sent when you\'re back online.'**
  String get tripQueued;

  /// No description provided for @tripSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the trip.'**
  String get tripSaveError;

  /// No description provided for @settingsSectionNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get settingsSectionNavigation;

  /// No description provided for @settingsSectionMaps.
  ///
  /// In en, this message translates to:
  /// **'Maps and charts'**
  String get settingsSectionMaps;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @boatRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get boatRemindersTitle;

  /// No description provided for @boatReminderNew.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get boatReminderNew;

  /// No description provided for @boatReminderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get boatReminderEditTitle;

  /// No description provided for @boatReminderTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get boatReminderTabPending;

  /// No description provided for @boatReminderTabDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get boatReminderTabDone;

  /// No description provided for @boatReminderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get boatReminderStatusPending;

  /// No description provided for @boatReminderStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get boatReminderStatusDone;

  /// No description provided for @noPendingBoatReminders.
  ///
  /// In en, this message translates to:
  /// **'No pending reminders.'**
  String get noPendingBoatReminders;

  /// No description provided for @noDoneBoatReminders.
  ///
  /// In en, this message translates to:
  /// **'No completed reminders yet.'**
  String get noDoneBoatReminders;

  /// No description provided for @loadBoatRemindersError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the reminders.'**
  String get loadBoatRemindersError;

  /// No description provided for @boatReminderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get boatReminderTitleLabel;

  /// No description provided for @boatReminderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Renew the marina berth'**
  String get boatReminderTitleHint;

  /// No description provided for @boatReminderTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get boatReminderTitleRequired;

  /// No description provided for @boatReminderDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get boatReminderDateLabel;

  /// No description provided for @boatReminderDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get boatReminderDatePlaceholder;

  /// No description provided for @boatReminderDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick the reminder date'**
  String get boatReminderDateRequired;

  /// No description provided for @boatReminderDoneAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Done on'**
  String get boatReminderDoneAtLabel;

  /// No description provided for @boatReminderNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get boatReminderNotesLabel;

  /// No description provided for @boatReminderDoneOn.
  ///
  /// In en, this message translates to:
  /// **'Done on {date}'**
  String boatReminderDoneOn(String date);

  /// No description provided for @boatReminderDueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get boatReminderDueToday;

  /// No description provided for @boatReminderDueInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Tomorrow} other{In {count} days}}'**
  String boatReminderDueInDays(int count);

  /// No description provided for @boatReminderOverdueDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day overdue} other{{count} days overdue}}'**
  String boatReminderOverdueDays(int count);

  /// No description provided for @boatReminderEveryMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Repeats every month} other{Repeats every {count} months}}'**
  String boatReminderEveryMonths(int count);

  /// No description provided for @boatReminderRecurrenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get boatReminderRecurrenceTitle;

  /// No description provided for @boatReminderRecurrenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When marked as done, the next one is created automatically'**
  String get boatReminderRecurrenceSubtitle;

  /// No description provided for @boatReminderRecurrenceMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Every how many months'**
  String get boatReminderRecurrenceMonthsLabel;

  /// No description provided for @boatReminderMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get boatReminderMarkDone;

  /// No description provided for @boatReminderMarkDoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'The reminder will move to Done.'**
  String get boatReminderMarkDoneConfirm;

  /// No description provided for @boatReminderMarkDoneRecurringConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{The reminder will move to Done and the next one is created 1 month after this one\'s date.} other{The reminder will move to Done and the next one is created {count} months after this one\'s date.}}'**
  String boatReminderMarkDoneRecurringConfirm(int count);

  /// No description provided for @boatReminderMarkedDone.
  ///
  /// In en, this message translates to:
  /// **'Reminder marked as done'**
  String get boatReminderMarkedDone;

  /// No description provided for @markBoatReminderDoneError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t mark the reminder as done.'**
  String get markBoatReminderDoneError;

  /// No description provided for @boatReminderSave.
  ///
  /// In en, this message translates to:
  /// **'Save reminder'**
  String get boatReminderSave;

  /// No description provided for @boatReminderSaved.
  ///
  /// In en, this message translates to:
  /// **'Reminder saved'**
  String get boatReminderSaved;

  /// No description provided for @boatReminderInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Check the reminder details.'**
  String get boatReminderInvalidError;

  /// No description provided for @saveBoatReminderError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the reminder. Try again.'**
  String get saveBoatReminderError;

  /// No description provided for @deleteBoatReminder.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder'**
  String get deleteBoatReminder;

  /// No description provided for @deleteBoatReminderConfirm.
  ///
  /// In en, this message translates to:
  /// **'The reminder and its scheduled notifications will be deleted.'**
  String get deleteBoatReminderConfirm;

  /// No description provided for @deleteBoatReminderError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the reminder.'**
  String get deleteBoatReminderError;

  /// No description provided for @documentStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get documentStatusExpired;

  /// No description provided for @documentStatusExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get documentStatusExpiringSoon;

  /// No description provided for @documentStatusValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get documentStatusValid;

  /// No description provided for @documentStatusNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get documentStatusNoExpiry;

  /// No description provided for @documentTypeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get documentTypeRegistration;

  /// No description provided for @documentTypeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get documentTypeInsurance;

  /// No description provided for @documentTypeInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get documentTypeInspection;

  /// No description provided for @documentTypeRadioLicense.
  ///
  /// In en, this message translates to:
  /// **'Radio license'**
  String get documentTypeRadioLicense;

  /// No description provided for @documentTypeFireExtinguisher.
  ///
  /// In en, this message translates to:
  /// **'Fire extinguisher'**
  String get documentTypeFireExtinguisher;

  /// No description provided for @documentTypeFlares.
  ///
  /// In en, this message translates to:
  /// **'Flares'**
  String get documentTypeFlares;

  /// No description provided for @documentTypeLifeJackets.
  ///
  /// In en, this message translates to:
  /// **'Life jackets'**
  String get documentTypeLifeJackets;

  /// No description provided for @documentTypeLifeRaft.
  ///
  /// In en, this message translates to:
  /// **'Life raft'**
  String get documentTypeLifeRaft;

  /// No description provided for @documentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get documentTypeOther;

  /// No description provided for @documentTypeNauticalLicense.
  ///
  /// In en, this message translates to:
  /// **'Boating license'**
  String get documentTypeNauticalLicense;

  /// No description provided for @documentTypeRadioOperatorCertificate.
  ///
  /// In en, this message translates to:
  /// **'Radio operator certificate'**
  String get documentTypeRadioOperatorCertificate;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @myDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My documents'**
  String get myDocumentsTitle;

  /// No description provided for @myDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Boating license and certificates'**
  String get myDocumentsSubtitle;

  /// No description provided for @documentNew.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get documentNew;

  /// No description provided for @documentEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get documentEditTitle;

  /// No description provided for @documentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get documentDetailsTitle;

  /// No description provided for @documentsAttentionSection.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get documentsAttentionSection;

  /// No description provided for @documentsOthersSection.
  ///
  /// In en, this message translates to:
  /// **'Other documents'**
  String get documentsOthersSection;

  /// No description provided for @noBoatDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Keep your registration, insurance, inspection and safety items with expiry dates here.'**
  String get noBoatDocuments;

  /// No description provided for @noPersonalDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Keep your boating license and certificates here.'**
  String get noPersonalDocuments;

  /// No description provided for @loadDocumentsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the documents.'**
  String get loadDocumentsError;

  /// No description provided for @loadDocumentError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the document.'**
  String get loadDocumentError;

  /// No description provided for @documentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get documentTypeLabel;

  /// No description provided for @documentTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get documentTitleLabel;

  /// No description provided for @documentNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get documentNumberLabel;

  /// No description provided for @documentIssuerLabel.
  ///
  /// In en, this message translates to:
  /// **'Issuer'**
  String get documentIssuerLabel;

  /// No description provided for @documentIssuerHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. maritime authority, insurer'**
  String get documentIssuerHint;

  /// No description provided for @documentDatesSection.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get documentDatesSection;

  /// No description provided for @documentExpiresAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Expires on'**
  String get documentExpiresAtLabel;

  /// No description provided for @documentIssuedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Issued on'**
  String get documentIssuedAtLabel;

  /// No description provided for @documentNoExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get documentNoExpiryLabel;

  /// No description provided for @documentDateNotInformed.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get documentDateNotInformed;

  /// No description provided for @documentInvalidDatesError.
  ///
  /// In en, this message translates to:
  /// **'Expiry can\'t be before the issue date'**
  String get documentInvalidDatesError;

  /// No description provided for @documentExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String documentExpiresOn(String date);

  /// No description provided for @documentExpiresToday.
  ///
  /// In en, this message translates to:
  /// **'expires today'**
  String get documentExpiresToday;

  /// No description provided for @documentExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day left} other{{count} days left}}'**
  String documentExpiresInDays(int count);

  /// No description provided for @documentExpiredDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{expired 1 day ago} other{expired {count} days ago}}'**
  String documentExpiredDaysAgo(int count);

  /// No description provided for @documentReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get documentReminderLabel;

  /// No description provided for @documentReminderDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{days} days before'**
  String documentReminderDaysBefore(String days);

  /// No description provided for @documentReminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get documentReminderOff;

  /// No description provided for @documentDetailsInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get documentDetailsInfoSection;

  /// No description provided for @documentNotesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get documentNotesSection;

  /// No description provided for @documentAttachmentsSection.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get documentAttachmentsSection;

  /// No description provided for @documentSave.
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get documentSave;

  /// No description provided for @documentSaved.
  ///
  /// In en, this message translates to:
  /// **'Document saved'**
  String get documentSaved;

  /// No description provided for @documentInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Check the document details.'**
  String get documentInvalidError;

  /// No description provided for @saveDocumentError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the document. Try again.'**
  String get saveDocumentError;

  /// No description provided for @documentAttachmentsFailed.
  ///
  /// In en, this message translates to:
  /// **'The document was saved, but some attachments weren\'t uploaded. Tap Try again.'**
  String get documentAttachmentsFailed;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get deleteDocument;

  /// No description provided for @deleteDocumentConfirm.
  ///
  /// In en, this message translates to:
  /// **'The document, its attachments and scheduled reminders will be deleted.'**
  String get deleteDocumentConfirm;

  /// No description provided for @deleteDocumentError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the document.'**
  String get deleteDocumentError;

  /// No description provided for @attachmentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get attachmentAdd;

  /// No description provided for @attachmentAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add attachment'**
  String get attachmentAddTitle;

  /// No description provided for @attachmentSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get attachmentSourceCamera;

  /// No description provided for @attachmentSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get attachmentSourceGallery;

  /// No description provided for @attachmentSourcePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF file'**
  String get attachmentSourcePdf;

  /// No description provided for @attachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Photos or PDF, up to {count} files of {size} MB.'**
  String attachmentsHint(int count, int size);

  /// No description provided for @attachmentLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Attachment limit reached.'**
  String get attachmentLimitReached;

  /// No description provided for @attachmentTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is larger than the limit.'**
  String get attachmentTooLarge;

  /// No description provided for @attachmentUnsupported.
  ///
  /// In en, this message translates to:
  /// **'File type not supported. Use a photo or PDF.'**
  String get attachmentUnsupported;

  /// No description provided for @attachmentUploadingProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading attachment {current} of {total}…'**
  String attachmentUploadingProgress(int current, int total);

  /// No description provided for @attachmentOpenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the attachment.'**
  String get attachmentOpenError;

  /// No description provided for @journalRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get journalRemindersTitle;

  /// No description provided for @journalNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No pending reminders.'**
  String get journalNoReminders;

  /// No description provided for @journalSeeReminders.
  ///
  /// In en, this message translates to:
  /// **'See reminders'**
  String get journalSeeReminders;

  /// No description provided for @journalDocumentsAlert.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 document expired or expiring soon} other{{count} documents expired or expiring soon}}'**
  String journalDocumentsAlert(int count);
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
