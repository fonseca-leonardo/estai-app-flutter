import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/raster_chart.dart';
import '../../viewmodels/raster_charts_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';

class RasterChartsScreen extends StatefulWidget {
  const RasterChartsScreen({super.key});

  @override
  State<RasterChartsScreen> createState() => _RasterChartsScreenState();
}

class _RasterChartsScreenState extends State<RasterChartsScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'RasterChartsScreen';

  Future<void> _pickAndImport(BuildContext context) async {
    final viewModel = context.read<RasterChartsViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    final imported = await viewModel.importZip(File(path));
    if (!mounted) return;

    if (imported != null) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.withAlpha(220),
          content: Text(l10n.rasterChartImportSuccess),
        ),
      );
    } else if (viewModel.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.withAlpha(220),
          content: Text(viewModel.errorMessage!),
        ),
      );
      viewModel.clearError();
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    RasterChartSet set,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<RasterChartsViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.black.withAlpha(220),
        title: Text(
          l10n.rasterChartRemoveTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.rasterChartRemoveMessage(set.name),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.remove,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await viewModel.deleteSet(set.id);
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
          title: Text(l10n.rasterCharts),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Consumer<RasterChartsViewModel>(
            builder: (context, viewModel, _) {
              return Stack(
                children: [
                  _buildBody(context, viewModel, l10n),
                  if (viewModel.isImporting)
                    _buildImportOverlay(viewModel, l10n),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Consumer<RasterChartsViewModel>(
          builder: (context, viewModel, _) {
            return FloatingActionButton.extended(
              onPressed: viewModel.isImporting
                  ? null
                  : () => _pickAndImport(context),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.file_upload_outlined),
              label: Text(l10n.rasterChartImport),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    RasterChartsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.sets.isEmpty) {
      return _buildEmpty(l10n);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: viewModel.sets.length,
      itemBuilder: (context, index) {
        return _buildSetCard(context, viewModel, viewModel.sets[index], l10n);
      },
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.layers_outlined,
              color: Colors.white54,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.rasterChartsEmptyTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.rasterChartsEmptyMessage,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetCard(
    BuildContext context,
    RasterChartsViewModel viewModel,
    RasterChartSet set,
    AppLocalizations l10n,
  ) {
    final anyVisible = set.charts.any((c) => c.visible);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withAlpha(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withAlpha(40)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: Colors.white,
        ),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Text(
            set.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            set.number != null && set.number!.isNotEmpty
                ? '${set.number}  ·  ${set.charts.length} ${l10n.rasterChartCount(set.charts.length)}'
                : '${set.charts.length} ${l10n.rasterChartCount(set.charts.length)}',
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: anyVisible,
                onChanged: (value) =>
                    viewModel.setSetVisibility(set.id, value),
                activeThumbColor: Colors.green,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                onPressed: () => _confirmDelete(context, set),
              ),
            ],
          ),
          children: set.charts
              .map((chart) => _buildChartTile(viewModel, set, chart, l10n))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildChartTile(
    RasterChartsViewModel viewModel,
    RasterChartSet set,
    RasterChart chart,
    AppLocalizations l10n,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        chart.name,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: chart.type == 'Base'
                  ? Colors.blueAccent.withAlpha(80)
                  : Colors.orangeAccent.withAlpha(80),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              chart.type,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${chart.width}×${chart.height}',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          if (!chart.projectionSupported) ...[
            const SizedBox(width: 8),
            Tooltip(
              message: l10n.rasterChartProjectionWarning(chart.projection),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ],
        ],
      ),
      trailing: Switch(
        value: chart.visible,
        onChanged: (_) => viewModel.toggleChartVisibility(set.id, chart.id),
        activeThumbColor: Colors.green,
      ),
    );
  }

  Widget _buildImportOverlay(
    RasterChartsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withAlpha(180),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(60)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.rasterChartImporting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: viewModel.importProgress > 0
                      ? viewModel.importProgress
                      : null,
                  backgroundColor: Colors.white24,
                ),
                const SizedBox(height: 12),
                Text(
                  viewModel.importMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
