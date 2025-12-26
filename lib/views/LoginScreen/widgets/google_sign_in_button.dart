import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../MapScreen/map_screen.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: authViewModel.isLoading
                ? null
                : () async {
                    authViewModel.clearError();
                    final success = await authViewModel.signInWithGoogle();
                    if (success == true && context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MapScreen()),
                        (route) => false,
                      );
                    }
                  },
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0A0A),
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF1F1F1F), width: 1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: authViewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.g_mobiledata,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.signInWithGoogle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
