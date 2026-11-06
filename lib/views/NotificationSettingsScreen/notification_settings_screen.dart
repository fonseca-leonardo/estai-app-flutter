import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/push_notification_service.dart';
import '../../viewmodels/notification_preferences_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import 'widgets/notification_toggle_tile.dart';
import 'widgets/system_permission_alert.dart';

/// Canais pelos quais o backend envia os lembretes (push e e-mail).
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with AnalyticsScreenMixin, WidgetsBindingObserver {
  @override
  String get analyticsScreenName => 'NotificationSettingsScreen';

  final _viewModel = NotificationPreferencesViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _viewModel.load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    super.dispose();
  }

  /// Volta das configurações do sistema: a permissão pode ter mudado.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _viewModel.refreshSystemPermission();
    }
  }

  Future<void> _allowSystemNotifications() async {
    await PushNotificationService.instance.requestPermissionIfNeeded(context);
    await _viewModel.refreshSystemPermission();
  }

  Future<void> _setPush(bool value) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    if (value && !_viewModel.systemPermissionGranted) {
      await _allowSystemNotifications();
    }
    final success = await _viewModel.setPushEnabled(value);
    if (!success && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.notificationPrefsSaveError)),
      );
    }
  }

  Future<void> _setEmail(bool value) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final success = await _viewModel.setEmailEnabled(value);
    if (!success && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.notificationPrefsSaveError)),
      );
    }
  }

  Future<void> _sendTest() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final success = await _viewModel.sendTest();
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? l10n.notificationPrefsTestSent
              : l10n.notificationPrefsTestError,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationSettings),
        backgroundColor: Colors.black.withValues(alpha: 0.78),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<NotificationPreferencesViewModel>(
          builder: (context, viewModel, child) {
            final preferences = viewModel.preferences;

            if (viewModel.isLoading && preferences == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (preferences == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 56,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.notificationPrefsLoadError,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: viewModel.load,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                ),
              );
            }

            final email = preferences.email;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Text(
                  l10n.notificationPrefsDescription,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                if (preferences.pushEnabled &&
                    !viewModel.systemPermissionGranted)
                  SystemPermissionAlert(onAllow: _allowSystemNotifications),
                NotificationToggleTile(
                  icon: Icons.notifications_outlined,
                  title: l10n.notificationPrefsPush,
                  subtitle: l10n.notificationPrefsPushSubtitle,
                  value: preferences.pushEnabled,
                  onChanged: viewModel.isSaving ? null : _setPush,
                ),
                NotificationToggleTile(
                  icon: Icons.mail_outline,
                  title: l10n.notificationPrefsEmail,
                  subtitle: email != null && email.isNotEmpty
                      ? l10n.notificationPrefsEmailSubtitle(email)
                      : l10n.notificationPrefsEmailSubtitleNoEmail,
                  value: preferences.emailEnabled,
                  onChanged: viewModel.isSaving ? null : _setEmail,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: viewModel.isSendingTest ? null : _sendTest,
                  icon: viewModel.isSendingTest
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_outlined, size: 18),
                  label: Text(l10n.notificationPrefsSendTest),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
