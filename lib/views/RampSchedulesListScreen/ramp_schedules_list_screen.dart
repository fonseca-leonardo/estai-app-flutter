import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/ramp_schedule.dart';
import '../../models/ramp_schedule_type.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/ramp_schedule_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import '../RampBookingScreen/ramp_booking_screen.dart';
import 'widgets/cancel_ramp_schedule_dialog.dart';
import 'widgets/ramp_schedules_tab.dart';

class RampSchedulesListScreen extends StatefulWidget {
  const RampSchedulesListScreen({super.key});

  @override
  State<RampSchedulesListScreen> createState() =>
      _RampSchedulesListScreenState();
}

class _RampSchedulesListScreenState extends State<RampSchedulesListScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'RampSchedulesListScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<RampScheduleViewModel>();
      viewModel.loadUpcoming();
      viewModel.loadHistory();
    });
  }

  Future<void> _cancel(RampSchedule schedule) async {
    final viewModel = context.read<RampScheduleViewModel>();
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final linkedReturn = schedule.type == RampScheduleType.launch
        ? viewModel.cancellableReturnOf(schedule)
        : null;

    final alsoCancelReturn = await showCancelRampScheduleDialog(
      context: context,
      linkedReturn: linkedReturn,
    );
    if (alsoCancelReturn == null) return;

    var success = await viewModel.cancelSchedule(schedule.id);
    if (success && alsoCancelReturn && linkedReturn != null) {
      success = await viewModel.cancelSchedule(linkedReturn.id);
    }
    if (!success && mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.cancelRampScheduleError)),
      );
    }
  }

  Future<void> _openBooking() async {
    final viewModel = context.read<RampScheduleViewModel>();
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const RampBookingScreen()));
    if (created == true) viewModel.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundFile = context.select<EstaiSessionViewModel, File?>(
      (vm) => vm.backgroundFile,
    );
    final hasBackground = backgroundFile != null;
    final topInset = hasBackground
        ? MediaQuery.paddingOf(context).top + kToolbarHeight + kTextTabBarHeight
        : 0.0;
    final listPadding = EdgeInsets.fromLTRB(16, topInset + 16, 16, 96);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: hasBackground,
        appBar: AppBar(
          title: Text(l10n.myRampSchedules),
          backgroundColor: hasBackground
              ? Colors.transparent
              : Colors.black.withValues(alpha: 0.78),
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
            dividerColor: Colors.white.withValues(alpha: 0.08),
            tabs: [
              Tab(text: l10n.rampTabUpcoming),
              Tab(text: l10n.rampTabHistory),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openBooking,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          icon: const Icon(Icons.add),
          label: Text(l10n.rampNewSchedule),
        ),
        body: MarinaBackground(
          backgroundFile: backgroundFile,
          child: Consumer<RampScheduleViewModel>(
            builder: (context, viewModel, child) {
              return TabBarView(
                children: [
                  RampSchedulesTab(
                    schedules: viewModel.upcoming,
                    isLoading: viewModel.isLoadingUpcoming,
                    errorMessage: viewModel.upcomingErrorMessage,
                    emptyMessage: l10n.noUpcomingRampSchedules,
                    onRefresh: viewModel.loadUpcoming,
                    onCancel: _cancel,
                    padding: listPadding,
                  ),
                  RampSchedulesTab(
                    schedules: viewModel.history,
                    isLoading: viewModel.isLoadingHistory,
                    errorMessage: viewModel.historyErrorMessage,
                    emptyMessage: l10n.noRampSchedulesHistory,
                    onRefresh: viewModel.loadHistory,
                    onCancel: _cancel,
                    padding: listPadding,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
