import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../viewmodels/anchor_alarm_viewmodel.dart';
import '../../../viewmodels/map_viewmodel.dart';
import 'anchor_alarm_set_radius_dialog.dart';

class AnchorAlarmSelectionBanner extends StatelessWidget {
  const AnchorAlarmSelectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AnchorAlarmViewModel, bool>(
      selector: (_, vm) => vm.isSettingAnchor,
      builder: (context, isSettingAnchor, child) {
        if (!isSettingAnchor) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context)!;
        return Positioned(
          bottom: 164,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        const Icon(Icons.anchor, color: Colors.white, size: 18),
                        Text(
                          l10n.anchorAlarmTapToSet,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      _BannerButton(
                        label: l10n.anchorAlarmUseCurrentPosition,
                        icon: Icons.my_location,
                        color: Colors.white,
                        onTap: () {
                          final position =
                              context.read<MapViewModel>().currentPosition;
                          if (position == null) return;
                          final anchorVm =
                              context.read<AnchorAlarmViewModel>();
                          final point =
                              LatLng(position.latitude, position.longitude);
                          AnchorAlarmSetRadiusDialog.show(context, point, (r) {
                            anchorVm.setAlarm(point, r);
                          });
                        },
                      ),
                      _BannerButton(
                        label: l10n.cancel,
                        icon: Icons.close,
                        color: Colors.redAccent,
                        onTap: () => context
                            .read<AnchorAlarmViewModel>()
                            .setSettingAnchorMode(false),
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

class _BannerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BannerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(icon, color: color, size: 16),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
