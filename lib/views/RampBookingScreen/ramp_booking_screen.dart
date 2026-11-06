import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/ramp_schedule_status.dart';
import '../../viewmodels/boat_viewmodel.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/ramp_booking_viewmodel.dart';
import '../../viewmodels/ramp_schedule_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';
import 'widgets/boat_selection_step.dart';
import 'widgets/booking_step_indicator.dart';
import 'widgets/no_ramps_placeholder.dart';
import 'widgets/operation_type_step.dart';
import 'widgets/ramp_selection_step.dart';
import 'widgets/return_step.dart';
import 'widgets/review_step.dart';
import 'widgets/slot_selection_step.dart';

/// Wizard para pedir uma descida ou subida na rampa da marina.
class RampBookingScreen extends StatefulWidget {
  const RampBookingScreen({super.key});

  @override
  State<RampBookingScreen> createState() => _RampBookingScreenState();
}

class _RampBookingScreenState extends State<RampBookingScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'RampBookingScreen';

  final RampBookingViewModel _viewModel = RampBookingViewModel();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final boatViewModel = context.read<BoatViewModel>();
    if (boatViewModel.boats.isEmpty) {
      await boatViewModel.loadBoats();
    }
    if (!mounted) return;
    await _viewModel.initialize(boatViewModel.boats);
  }

  String _stepLabel(AppLocalizations l10n, RampBookingStep step) {
    switch (step) {
      case RampBookingStep.ramp:
        return l10n.rampStepRamp;
      case RampBookingStep.boat:
        return l10n.rampStepBoat;
      case RampBookingStep.operation:
        return l10n.rampStepOperation;
      case RampBookingStep.slot:
        return l10n.rampStepSlot;
      case RampBookingStep.returnTrip:
        return l10n.rampStepReturn;
      case RampBookingStep.review:
        return l10n.rampStepReview;
    }
  }

  Widget _stepContent(RampBookingStep step) {
    switch (step) {
      case RampBookingStep.ramp:
        return const RampSelectionStep();
      case RampBookingStep.boat:
        return const BoatSelectionStep();
      case RampBookingStep.operation:
        return const OperationTypeStep();
      case RampBookingStep.slot:
        return const SlotSelectionStep();
      case RampBookingStep.returnTrip:
        return const ReturnStep();
      case RampBookingStep.review:
        return ReviewStep(notesController: _notesController);
    }
  }

  Future<void> _onPrimaryPressed() async {
    if (_viewModel.currentStep != RampBookingStep.review) {
      _viewModel.next();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final scheduleViewModel = context.read<RampScheduleViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final result = await _viewModel.submit();
    if (result == null || !mounted) return;

    scheduleViewModel.loadUpcoming();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.schedule.status == RampScheduleStatus.confirmed
              ? l10n.rampBookingConfirmed
              : l10n.rampBookingRequested,
        ),
      ),
    );
    navigator.pop(true);
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

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<RampBookingViewModel>(
        builder: (context, viewModel, child) {
          final step = viewModel.currentStep;
          final steps = viewModel.steps;
          final ready = !viewModel.isLoadingRamps && viewModel.ramps.isNotEmpty;
          final hideButton =
              step == RampBookingStep.boat && viewModel.boats.isEmpty;
          final isReview = step == RampBookingStep.review;

          return PopScope(
            canPop: !ready || viewModel.isFirstStep,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) viewModel.back();
            },
            child: Scaffold(
              extendBodyBehindAppBar: hasBackground,
              appBar: AppBar(
                title: Text(l10n.rampBookingTitle),
                backgroundColor: hasBackground
                    ? Colors.transparent
                    : Colors.black.withValues(alpha: 0.78),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              backgroundColor: Colors.black,
              body: MarinaBackground(
                backgroundFile: backgroundFile,
                child: Padding(
                  padding: EdgeInsets.only(top: topInset),
                  child: Builder(
                    builder: (context) {
                      if (!viewModel.isInitialized ||
                          viewModel.isLoadingRamps) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (!ready) {
                        return NoRampsPlaceholder(
                          hasNoMarina: viewModel.hasNoMarina,
                          hasError: viewModel.rampsErrorMessage != null,
                          onRetry: _initialize,
                        );
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                            child: BookingStepIndicator(
                              currentIndex: viewModel.currentIndex,
                              total: steps.length,
                              label: _stepLabel(l10n, step),
                            ),
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.04, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                              child: KeyedSubtree(
                                key: ValueKey(step),
                                child: _stepContent(step),
                              ),
                            ),
                          ),
                          if (!hideButton)
                            SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  12,
                                  20,
                                  20,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: viewModel.canContinue
                                        ? _onPrimaryPressed
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      disabledBackgroundColor: Colors.white
                                          .withValues(alpha: 0.15),
                                      disabledForegroundColor: Colors.white
                                          .withValues(alpha: 0.4),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: viewModel.isSubmitting
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Text(
                                            isReview
                                                ? l10n.rampSubmit
                                                : l10n.rampContinue,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
