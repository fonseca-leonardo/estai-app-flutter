import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/feedback_service.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../LoginScreen/login_screen.dart';
import '../../SignUpScreen/sign_up_screen.dart';
import 'login_required_widget.dart';

class FeedbackSuggestionDialog {
  static const int _maxCharacters = 500;

  static void show(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parentContext = context;
    final textController = TextEditingController();
    final feedbackService = FeedbackService();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            if (!authViewModel.isAuthenticated) {
              return AlertDialog(
                backgroundColor: Colors.black.withValues(alpha: 0.9),
                title: Text(
                  l10n.improvementsAndSuggestions,
                  style: const TextStyle(color: Colors.white),
                ),
                content: SingleChildScrollView(
                  child: LoginRequiredWidget(
                    onNavigateToLogin: () {
                      Navigator.of(dialogContext).pop();
                      if (parentContext.mounted) {
                        Navigator.of(parentContext).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    onNavigateToSignUp: () {
                      Navigator.of(dialogContext).pop();
                      if (parentContext.mounted) {
                        Navigator.of(parentContext).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      l10n.cancel,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              );
            }

            return StatefulBuilder(
          builder: (context, setState) {
            final length = textController.text.length;
            return AlertDialog(
              backgroundColor: Colors.black.withValues(alpha: 0.9),
              title: Text(
                l10n.improvementsAndSuggestions,
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    maxLength: _maxCharacters,
                    maxLines: 4,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.feedbackSuggestionPlaceholder,
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      counterText: '',
                      counterStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      l10n.feedbackMaxCharacters(
                        length.toString(),
                        _maxCharacters.toString(),
                      ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton(
                  onPressed: textController.text.trim().isEmpty
                      ? null
                      : () async {
                          final text = textController.text.trim();
                          if (text.isEmpty) return;

                          final scaffoldContext = context;
                          try {
                            await feedbackService.sendFeedback(text);
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                              if (scaffoldContext.mounted) {
                                ScaffoldMessenger.of(
                                  scaffoldContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.feedbackSentSuccess),
                                  ),
                                );
                              }
                            }
                          } catch (_) {
                            if (dialogContext.mounted &&
                                scaffoldContext.mounted) {
                              ScaffoldMessenger.of(
                                scaffoldContext,
                              ).showSnackBar(
                                SnackBar(content: Text(l10n.feedbackError)),
                              );
                            }
                          }
                        },
                  child: Text(
                    l10n.confirm,
                    style: const TextStyle(color: Colors.lightGreen),
                  ),
                ),
              ],
            );
          },
        );
          },
        );
      },
    );
  }
}
