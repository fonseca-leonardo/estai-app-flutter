import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'viewmodels/maps_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

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
        ChangeNotifierProvider(create: (_) => MapsViewModel()),
        ChangeNotifierProvider.value(value: settingsViewModel),
        ChangeNotifierProvider.value(value: navigationStatusViewModel),
      ],
      child: MaterialApp(
        title: 'Estai - Mapa',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
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
