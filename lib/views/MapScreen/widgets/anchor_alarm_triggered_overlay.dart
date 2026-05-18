import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/anchor_alarm_viewmodel.dart';

class AnchorAlarmTriggeredOverlay extends StatefulWidget {
  const AnchorAlarmTriggeredOverlay({super.key});

  @override
  State<AnchorAlarmTriggeredOverlay> createState() =>
      _AnchorAlarmTriggeredOverlayState();
}

class _AnchorAlarmTriggeredOverlayState
    extends State<AnchorAlarmTriggeredOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AnchorAlarmViewModel, bool>(
      selector: (_, vm) => vm.isAlarmTriggered,
      builder: (context, isTriggered, child) {
        if (!isTriggered) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context)!;
        return Positioned.fill(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                color: Colors.red.withValues(
                  alpha: _pulseAnimation.value * 0.75,
                ),
                child: child,
              );
            },
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  const Icon(Icons.anchor, color: Colors.white, size: 64),
                  Text(
                    l10n.anchorAlarmTriggered,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      l10n.anchorAlarmTriggeredMessage,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      OutlinedButton(
                        onPressed: () => context
                            .read<AnchorAlarmViewModel>()
                            .dismissTrigger(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(l10n.anchorAlarmDismiss),
                      ),
                      FilledButton(
                        onPressed: () =>
                            context.read<AnchorAlarmViewModel>().clearAlarm(),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(l10n.anchorAlarmDisable),
                      ),
                    ],
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
