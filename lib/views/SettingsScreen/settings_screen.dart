import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';
import '../NavigationSettingsScreen/navigation_settings_screen.dart';
import '../NavigationPermissionScreen/navigation_permission_screen.dart';
import '../UserAccountScreen/user_account_screen.dart';
import '../SignUpScreen/sign_up_screen.dart';
import '../LoginScreen/login_screen.dart';
import '../WeatherPinsListScreen/weather_pins_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AuthViewModel? _authViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_authViewModel == null) {
      _authViewModel = context.read<AuthViewModel>();
      _authViewModel!.addListener(_onAuthChanged);
    }
  }

  void _onAuthChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _authViewModel?.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      sized: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(l10n.settings),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSettingsTile(
                        context,
                        l10n.navigationSettings,
                        Icons.navigation,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NavigationSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        context,
                        l10n.navigationPermission,
                        Icons.location_on,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const NavigationPermissionScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        context,
                        l10n.weatherPinsList,
                        Icons.thermostat,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WeatherPinsListScreen(),
                            ),
                          );
                        },
                      ),
                      if (authViewModel.isAuthenticated) ...[
                        const SizedBox(height: 16),
                        _buildSettingsTile(
                          context,
                          l10n.userAccount,
                          Icons.person,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UserAccountScreen(),
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(l10n.login),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(l10n.createAccount),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const AdBannerWidget(),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
