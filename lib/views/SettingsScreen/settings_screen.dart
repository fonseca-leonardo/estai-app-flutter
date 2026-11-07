import '../../widgets/ui/app_scaffold.dart';
import '../../theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/ui/app_tile.dart';
import '../../widgets/ui/section_label.dart';
import '../ListMapsScreen/list_maps_screen.dart';
import '../NavigationSettingsScreen/navigation_settings_screen.dart';
import '../NavigationPermissionScreen/navigation_permission_screen.dart';
import '../DocumentsScreen/documents_screen.dart';
import '../ChecklistsScreen/checklists_screen.dart';
import '../UserAccountScreen/user_account_screen.dart';
import '../SignUpScreen/sign_up_screen.dart';
import '../LoginScreen/login_screen.dart';
import '../WeatherPinsListScreen/weather_pins_list_screen.dart';
import '../RasterChartsScreen/raster_charts_screen.dart';
import '../SignalKConfigurationScreen/signalk_configuration_screen.dart';
import '../NotificationSettingsScreen/notification_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'SettingsScreen';

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
      child: AppScaffold(
        appBar: AppBar(
          title: Text(l10n.settings),
          backgroundColor: Colors.black.withValues(alpha: 0.78),
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
                      SectionLabel(l10n.settingsSectionNavigation),
                      AppTile(
                        title: l10n.navigationSettings,
                        icon: Icons.navigation,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NavigationSettingsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTile(
                        title: l10n.checklistsTitle,
                        subtitle: l10n.checklistsSubtitle,
                        icon: Icons.checklist_rounded,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChecklistsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTile(
                        title: l10n.navigationPermission,
                        icon: Icons.location_on,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NavigationPermissionScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTile(
                        title: l10n.weatherPinsList,
                        icon: Icons.thermostat,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WeatherPinsListScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionLabel(l10n.settingsSectionMaps),
                      AppTile(
                        title: l10n.maps,
                        icon: Icons.map,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ListMapsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTile(
                        title: l10n.rasterCharts,
                        icon: Icons.layers_outlined,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RasterChartsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTile(
                        title: l10n.signalKConfiguration,
                        icon: Icons.sensors,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignalKConfigurationScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionLabel(l10n.settingsSectionAccount),
                      if (authViewModel.isAuthenticated) ...[
                        AppTile(
                          title: l10n.notificationSettings,
                          icon: Icons.notifications_outlined,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const NotificationSettingsScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppTile(
                          title: l10n.myDocumentsTitle,
                          subtitle: l10n.myDocumentsSubtitle,
                          icon: Icons.badge_outlined,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DocumentsScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppTile(
                          title: l10n.userAccount,
                          icon: Icons.person_outline,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const UserAccountScreen(),
                            ),
                          ),
                        ),
                      ] else ...[
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
                            backgroundColor: AppColors.surfaceStrong,
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
                      const SizedBox(height: 32),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          final version = snapshot.data?.version ?? '—';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              l10n.appVersion(version),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ),
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
}
