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
