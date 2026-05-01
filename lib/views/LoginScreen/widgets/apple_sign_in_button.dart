import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../MapScreen/map_screen.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: authViewModel.isLoading
                ? null
                : () async {
                    authViewModel.clearError();
                    final success = await authViewModel.signInWithApple();
                    if (success == true && context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MapScreen()),
                        (route) => false,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.white,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.6),
              disabledForegroundColor: Colors.black.withValues(alpha: 0.6),
            ),
            child: authViewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Icon(Icons.apple, color: Colors.black, size: 22),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.signInWithApple,
                        style: const TextStyle(
                          fontFamily: '.SF Pro Text',
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.41,
                          color: Colors.black,
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
