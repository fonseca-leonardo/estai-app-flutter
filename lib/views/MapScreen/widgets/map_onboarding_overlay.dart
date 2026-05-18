import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/onboarding_viewmodel.dart';
import 'map_onboarding_step.dart';

class MapOnboardingOverlay extends StatefulWidget {
  const MapOnboardingOverlay({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      barrierLabel: 'onboarding',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => const MapOnboardingOverlay(),
      transitionBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  State<MapOnboardingOverlay> createState() => _MapOnboardingOverlayState();
}

class _MapOnboardingOverlayState extends State<MapOnboardingOverlay> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_OnboardingStepData> _buildSteps(AppLocalizations l10n) {
    return [
      _OnboardingStepData(
        icon: Icons.sailing_rounded,
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDescription,
      ),
      _OnboardingStepData(
        icon: Icons.route_rounded,
        title: l10n.onboardingRoutesTitle,
        description: l10n.onboardingRoutesDescription,
      ),
      _OnboardingStepData(
        icon: Icons.navigation_rounded,
        title: l10n.onboardingNavigationTitle,
        description: l10n.onboardingNavigationDescription,
      ),
      _OnboardingStepData(
        icon: Icons.grid_on,
        title: l10n.onboardingRasterChartsTitle,
        description: l10n.onboardingRasterChartsDescription,
      ),
      _OnboardingStepData(
        icon: Icons.thermostat,
        title: l10n.onboardingWeatherTitle,
        description: l10n.onboardingWeatherDescription,
      ),
      _OnboardingStepData(
        icon: Icons.anchor,
        title: l10n.onboardingAnchorAlarmTitle,
        description: l10n.onboardingAnchorAlarmDescription,
      ),
      _OnboardingStepData(
        icon: Icons.layers,
        title: l10n.onboardingMapsTitle,
        description: l10n.onboardingMapsDescription,
      ),
    ];
  }

  Future<void> _finish() async {
    await context.read<OnboardingViewModel>().markMapOnboardingShown();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _next(int total) {
    if (_currentPage >= total - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _previous() {
    if (_currentPage == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _buildSteps(l10n);
    final isLast = _currentPage == steps.length - 1;
    final isFirst = _currentPage == 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _OnboardingHeader(
                      progressLabel: l10n.onboardingStepProgress(
                        (_currentPage + 1).toString(),
                        steps.length.toString(),
                      ),
                      skipLabel: l10n.onboardingSkip,
                      onSkip: _finish,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 360,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: steps.length,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          return MapOnboardingStep(
                            icon: step.icon,
                            title: step.title,
                            description: step.description,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _OnboardingDots(
                      count: steps.length,
                      currentIndex: _currentPage,
                    ),
                    const SizedBox(height: 20),
                    _OnboardingActions(
                      isFirst: isFirst,
                      isLast: isLast,
                      previousLabel: l10n.onboardingPrevious,
                      nextLabel: l10n.onboardingNext,
                      finishLabel: l10n.onboardingFinish,
                      onPrevious: _previous,
                      onNext: () => _next(steps.length),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStepData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingStepData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnboardingHeader extends StatelessWidget {
  final String progressLabel;
  final String skipLabel;
  final VoidCallback onSkip;

  const _OnboardingHeader({
    required this.progressLabel,
    required this.skipLabel,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          progressLabel,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
        TextButton(
          onPressed: onSkip,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withValues(alpha: 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            skipLabel,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _OnboardingDots({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 22 : 6,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _OnboardingActions extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String previousLabel;
  final String nextLabel;
  final String finishLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _OnboardingActions({
    required this.isFirst,
    required this.isLast,
    required this.previousLabel,
    required this.nextLabel,
    required this.finishLabel,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: isFirst ? null : onPrevious,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withValues(alpha: 0.25),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: isFirst ? 0.08 : 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                previousLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isLast ? finishLabel : nextLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
