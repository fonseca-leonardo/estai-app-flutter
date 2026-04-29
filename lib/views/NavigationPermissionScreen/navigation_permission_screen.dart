import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/navigation_permission_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import 'widgets/open_settings_button.dart';
import 'widgets/permission_status_card.dart';

class NavigationPermissionScreen extends StatefulWidget {
  const NavigationPermissionScreen({super.key});

  @override
  State<NavigationPermissionScreen> createState() =>
      _NavigationPermissionScreenState();
}

class _NavigationPermissionScreenState extends State<NavigationPermissionScreen>
    with WidgetsBindingObserver, AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'NavigationPermissionScreen';

  NavigationPermissionViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null) {
      _viewModel = context.read<NavigationPermissionViewModel>();
      _viewModel!.addListener(_onViewModelChanged);
      if (!_viewModel!.isLoading) {
        _onViewModelChanged();
      }
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _viewModel?.loadPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel?.removeListener(_onViewModelChanged);
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
          title: Text(l10n.navigationPermission),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<NavigationPermissionViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.navigationPermission,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.navigationPermissionDescription,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      PermissionStatusCard(permission: viewModel.permission),
                      if (viewModel.showOpenSettingsButton) ...[
                        const SizedBox(height: 24),
                        OpenSettingsButton(
                          onPressed: () => viewModel.openAppSettings(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
