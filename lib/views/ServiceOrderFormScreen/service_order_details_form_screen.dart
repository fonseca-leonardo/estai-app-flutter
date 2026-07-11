import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/boat.dart';
import '../../models/service_price_item.dart';
import '../../viewmodels/estai_session_viewmodel.dart';
import '../../viewmodels/service_order_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';
import '../../widgets/marina_background.dart';

class ServiceOrderDetailsFormScreen extends StatefulWidget {
  final Boat boat;
  final ServicePriceItem priceItem;

  const ServiceOrderDetailsFormScreen({
    super.key,
    required this.boat,
    required this.priceItem,
  });

  @override
  State<ServiceOrderDetailsFormScreen> createState() =>
      _ServiceOrderDetailsFormScreenState();
}

class _ServiceOrderDetailsFormScreenState
    extends State<ServiceOrderDetailsFormScreen>
    with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'ServiceOrderDetailsFormScreen';

  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<ServiceOrderViewModel>();
    final success = await viewModel.createOrder(
      boatId: widget.boat.id,
      priceItemId: widget.priceItem.id,
      description: widget.priceItem.description?.trim().isNotEmpty == true
          ? widget.priceItem.description!.trim()
          : widget.priceItem.name,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.serviceOrderCreated)));
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _errorMessage = l10n.createServiceOrderError;
      });
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final priceFormat = NumberFormat.simpleCurrency(locale: locale);
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
        title: Text(l10n.newServiceOrder),
        backgroundColor: hasBackground
            ? Colors.transparent
            : Colors.black.withAlpha(200),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: MarinaBackground(
        backgroundFile: backgroundFile,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, topInset + 20, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.priceItem.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.boat.name,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${l10n.estimatedPrice}: ${priceFormat.format(widget.priceItem.defaultPrice)} / ${widget.priceItem.unit.label(l10n)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        maxLength: 1000,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration(l10n.notesOptional),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Consumer<ServiceOrderViewModel>(
                  builder: (context, serviceOrderViewModel, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: serviceOrderViewModel.isSubmitting
                            ? null
                            : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: serviceOrderViewModel.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(l10n.createServiceOrder),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
