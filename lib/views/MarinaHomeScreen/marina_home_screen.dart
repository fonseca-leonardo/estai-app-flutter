import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/ramp_schedule_viewmodel.dart';
import '../../viewmodels/service_order_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import 'widgets/marina_header_card.dart';
import 'widgets/marina_quick_actions.dart';
import 'widgets/marina_section_title.dart';
import 'widgets/marina_tracking_section.dart';

class MarinaHomeScreen extends StatefulWidget {
  const MarinaHomeScreen({super.key});

  @override
  State<MarinaHomeScreen> createState() => _MarinaHomeScreenState();
}

class _MarinaHomeScreenState extends State<MarinaHomeScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MarinaHomeScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  /// Sem push, recarregar é como o usuário vê se a marina respondeu.
  Future<void> _refresh() async {
    await Future.wait([
      context.read<ServiceOrderViewModel>().loadOrders(),
      context.read<RampScheduleViewModel>().loadUpcoming(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundFile = context.select<EstaiSessionViewModel, File?>(
      (vm) => vm.backgroundFile,
    );
    final hasBackground = backgroundFile != null;
    final topInset = hasBackground
        ? MediaQuery.paddingOf(context).top + kToolbarHeight
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: hasBackground,
      appBar: AppBar(
        title: Text(l10n.marinaHomeTitle),
        backgroundColor: hasBackground
            ? Colors.transparent
            : Colors.black.withValues(alpha: 0.78),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: MarinaBackground(
        backgroundFile: backgroundFile,
        child: RefreshIndicator(
          onRefresh: _refresh,
          edgeOffset: topInset,
          color: Colors.black,
          backgroundColor: Colors.white,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 32),
            children: [
              const MarinaHeaderCard(),
              const SizedBox(height: 28),
              MarinaSectionTitle(title: l10n.marinaQuickActionsTitle),
              const MarinaQuickActions(),
              const SizedBox(height: 32),
              MarinaSectionTitle(title: l10n.marinaTrackingTitle),
              const MarinaTrackingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
