import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/list_maps_viewmodel.dart';
import 'package:provider/provider.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ListMapsViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => viewModel.toggleDarkMode(),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    viewModel.darkMode ? Icons.dark_mode : Icons.light_mode,
                    color: viewModel.darkMode
                        ? Colors.blue.withValues(alpha: 0.9)
                        : Colors.amber.withValues(alpha: 0.9),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.darkMode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.darkModeDescription,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: viewModel.darkMode,
                    onChanged: (_) => viewModel.toggleDarkMode(),
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
