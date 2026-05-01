import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/map_viewmodel.dart';
import '../views/MapScreen/widgets/background_location_disclosure_dialog.dart';

class LocationInitWrapper extends StatefulWidget {
  final Widget child;

  const LocationInitWrapper({super.key, required this.child});

  @override
  State<LocationInitWrapper> createState() => _LocationInitWrapperState();
}

class _LocationInitWrapperState extends State<LocationInitWrapper> {
  static const String _backgroundDisclosureRespondedKey =
      'background_location_disclosure_responded';

  bool _disclosureShown = false;
  bool _alreadyResponded = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _alreadyResponded =
        prefs.getBool(_backgroundDisclosureRespondedKey) ?? false;

    if (!mounted) return;
    context.read<MapViewModel>().requestLocationPermissionAtInit();
  }

  void _showDisclosureIfNeeded(bool needsConsent) {
    if (!needsConsent || _disclosureShown || _alreadyResponded) return;
    _disclosureShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mapViewModel = context.read<MapViewModel>();

      if (Platform.isIOS) {
        _alreadyResponded = true;
        await mapViewModel.requestBackgroundLocation();
        return;
      }
      if (!mounted) return;

      final accepted = await BackgroundLocationDisclosureDialog.show(context);
      _alreadyResponded = true;
      if (accepted) {
        await mapViewModel.requestBackgroundLocation();
      } else {
        await mapViewModel.dismissBackgroundLocationConsent();
      }
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
