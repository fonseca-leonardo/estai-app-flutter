import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../LoginScreen/login_screen.dart';
import '../../SignUpScreen/sign_up_screen.dart';

class LoginRequiredWidget extends StatelessWidget {
  final VoidCallback? onNavigateToLogin;
  final VoidCallback? onNavigateToSignUp;

  const LoginRequiredWidget({
    super.key,
    this.onNavigateToLogin,
    this.onNavigateToSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        if (authViewModel.isAuthenticated) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: double.infinity,
          child: Container(
            child: Column(
              children: [
                const Icon(Icons.lock_outline, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  l10n.loginRequiredForAction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (onNavigateToLogin != null) {
                        onNavigateToLogin!();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(l10n.goToLogin),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (onNavigateToSignUp != null) {
                        onNavigateToSignUp!();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(l10n.createAccount),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
