import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_viewmodel.dart';
import '../views/MapScreen/widgets/background_location_disclosure_dialog.dart';
import '../views/NavigationPermissionScreen/navigation_permission_screen.dart';

class LocationInitWrapper extends StatefulWidget {
  final Widget child;

  const LocationInitWrapper({super.key, required this.child});

  @override
  State<LocationInitWrapper> createState() => _LocationInitWrapperState();
}

class _LocationInitWrapperState extends State<LocationInitWrapper> {
  bool _disclosureShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MapViewModel>().requestLocationPermissionAtInit();
      }
    });
  }

  void _showDisclosureIfNeeded(bool needsConsent) {
    if (!needsConsent || _disclosureShown) return;
    _disclosureShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final mapViewModel = context.read<MapViewModel>();
      final accepted = await BackgroundLocationDisclosureDialog.show(context);
      if (!mounted) return;
      if (accepted) {
        mapViewModel.requestBackgroundLocation();
      } else {
        mapViewModel.dismissBackgroundLocationConsent();
      }
      _disclosureShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MapViewModel, bool>(
      selector: (_, viewModel) => viewModel.needsBackgroundLocationConsent,
      builder: (context, needsConsent, child) {
        _showDisclosureIfNeeded(needsConsent);
        return child!;
      },
      child: widget.child,
    );
  }
}
