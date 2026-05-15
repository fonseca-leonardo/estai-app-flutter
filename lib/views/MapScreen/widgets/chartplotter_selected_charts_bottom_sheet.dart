import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/chart_boundary.dart';
import '../../../models/raster_chart.dart';
import '../../../viewmodels/chartplotter_viewmodel.dart';
import '../../../viewmodels/raster_charts_viewmodel.dart';

class ChartplotterSelectedChartsBottomSheet {
  ChartplotterSelectedChartsBottomSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _SelectedChartsContent(),
    );
  }
}

class _SelectedChartsContent extends StatelessWidget {
  const _SelectedChartsContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Selector<ChartplotterViewModel, List<ChartBoundary>>(
        selector: (_, vm) => vm.selectedCharts,
        builder: (context, charts, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Cartas selecionadas (${charts.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (charts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Nenhuma carta no centro do mapa.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: charts.length,
                      separatorBuilder: (_, _) => Divider(
                        color: Colors.white.withAlpha(30),
                        height: 1,
                      ),
                      itemBuilder: (context, index) =>
                          _ChartTile(chart: charts[index]),
                    ),
                  ),
                const SizedBox(height: 16),
                const _ImportZipButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImportZipButton extends StatelessWidget {
  const _ImportZipButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Selector<RasterChartsViewModel, bool>(
      selector: (_, vm) => vm.isImporting,
      builder: (context, isImporting, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isImporting ? null : () => _pickAndImport(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.white.withAlpha(80),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: isImporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Icon(Icons.file_upload_outlined),
            label: Text(
              isImporting ? l10n.rasterChartImporting : l10n.rasterChartImport,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

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
}

class _ChartTile extends StatelessWidget {
  const _ChartTile({required this.chart});

  final ChartBoundary chart;

  @override
  Widget build(BuildContext context) {
    return Consumer<RasterChartsViewModel>(
      builder: (context, viewModel, _) {
        final match = viewModel.findImportedChartFor(
          id: chart.id,
          name: chart.name,
        );
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            '${chart.id} - ${chart.name}',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: match != null
              ? _ImportedChartActions(set: match.set, chart: match.chart)
              : _DownloadButton(link: chart.link),
        );
      },
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.link});

  final String? link;

  @override
  Widget build(BuildContext context) {
    final url = link;
    if (url == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: 'Baixar carta raster',
      icon: const Icon(Icons.download, color: Colors.white),
      onPressed: () => _openLink(context, url),
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    final messenger = ScaffoldMessenger.of(context);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }
}

class _ImportedChartActions extends StatelessWidget {
  const _ImportedChartActions({required this.set, required this.chart});

  final RasterChartSet set;
  final RasterChart chart;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: chart.visible ? 'Ocultar carta' : 'Mostrar carta',
          icon: Icon(
            chart.visible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () => context
              .read<RasterChartsViewModel>()
              .toggleChartVisibility(set.id, chart.id),
        ),
        IconButton(
          tooltip: 'Excluir carta importada',
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
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
}
