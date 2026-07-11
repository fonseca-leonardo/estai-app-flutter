import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/marina_access_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../MarinaSuccessScreen/marina_success_screen.dart';
import 'widgets/boat_selection_tile.dart';

class MarinaAccessScreen extends StatefulWidget {
  final String marinaId;

  const MarinaAccessScreen({super.key, required this.marinaId});

  @override
  State<MarinaAccessScreen> createState() => _MarinaAccessScreenState();
}

class _MarinaAccessScreenState extends State<MarinaAccessScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'MarinaAccessScreen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarinaAccessViewModel>().loadData(widget.marinaId);
    });
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<MarinaAccessViewModel>();
    final success = await viewModel.confirmAssociation(widget.marinaId);

    if (!mounted) return;

    if (success) {
      await context.read<EstaiSessionViewModel>().refreshStoredMarina();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MarinaSuccessScreen(marina: viewModel.associationResult!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? l10n.associationError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      sized: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(l10n.marinaAccessTitle),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Consumer<MarinaAccessViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (viewModel.marina == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.errorMessage ?? l10n.loadMarinaError,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () =>
                              viewModel.loadData(widget.marinaId),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(l10n.tryAgain),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[800]!, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.anchor, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  viewModel.marina!.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (viewModel.marina!.location != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${viewModel.marina!.location!.street}, ${viewModel.marina!.location!.number} · '
                              '${viewModel.marina!.location!.city}/${viewModel.marina!.location!.state}',
                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            l10n.marinaAccessInviteMessage,
                            style: TextStyle(color: Colors.grey[300], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.selectBoatsToAssociate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.boats.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          l10n.noBoatsAvailable,
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        ),
                      )
                    else
                      ...viewModel.boats.map(
                        (boat) => BoatSelectionTile(
                          boat: boat,
                          selected: viewModel.selectedBoatIds.contains(boat.id),
                          onTap: () => viewModel.toggleBoat(boat.id),
                        ),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: viewModel.isSubmitting ? null : _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: viewModel.isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.confirmAssociation),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
