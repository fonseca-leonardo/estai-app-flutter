import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'views/LoginScreen/login_screen.dart';
import 'viewmodels/map_viewmodel.dart';
import 'viewmodels/tide_viewmodel.dart';
import 'viewmodels/route_planner_viewmodel.dart';
import 'viewmodels/navigation_status_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/routes_viewmodel.dart';
import 'viewmodels/list_maps_viewmodel.dart';
import 'viewmodels/ad_banner_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception.toString();
    if (exception.contains('Request to') &&
        exception.contains('failed with status 404') &&
        exception.contains('maps-api.estai.com.br')) {
      return;
    }
    FlutterError.presentError(details);
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // if (kDebugMode) {
  //   await FirebaseAppCheck.instance.activate(
  //     providerAndroid: AndroidDebugProvider(),
  //     providerApple: AppleDebugProvider(),
  //   );
  // } else {
  //   await FirebaseAppCheck.instance.activate(
  //     providerAndroid: AndroidPlayIntegrityProvider(),
  //     providerApple: AppleAppAttestProvider(),
  //   );
  // }

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final initializationStatus = await MobileAds.instance.initialize();
  if (kDebugMode) {
    debugPrint(
      'MobileAds initialized: ${initializationStatus.adapterStatuses}',
    );
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = SettingsViewModel();
    final navigationStatusViewModel = NavigationStatusViewModel();
    navigationStatusViewModel.setSettingsViewModel(settingsViewModel);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => TideViewModel()),
        ChangeNotifierProvider(create: (_) => RoutePlannerViewModel()),
        ChangeNotifierProvider(create: (_) => RoutesViewModel()),
        ChangeNotifierProvider(create: (_) => ListMapsViewModel()),
        ChangeNotifierProvider(create: (_) => AdBannerViewModel()),
        ChangeNotifierProvider.value(value: settingsViewModel),
        ChangeNotifierProvider.value(value: navigationStatusViewModel),
      ],
      child: MaterialApp(
        title: 'Estai - Mapa',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: Colors.white,
          ),
          useMaterial3: true,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.white,
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
        home: const LoginScreen(),
      ),
    );
  }
}
