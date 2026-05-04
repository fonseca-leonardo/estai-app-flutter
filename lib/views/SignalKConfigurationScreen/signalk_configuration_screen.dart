import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodels/signalk_configuration_viewmodel.dart';
import '../../widgets/analytics_screen_mixin.dart';

class SignalKConfigurationScreen extends StatefulWidget {
  const SignalKConfigurationScreen({super.key});

  @override
  State<SignalKConfigurationScreen> createState() =>
      _SignalKConfigurationScreenState();
}

class _SignalKConfigurationScreenState
    extends State<SignalKConfigurationScreen> with AnalyticsScreenMixin {
  @override
  String get analyticsScreenName => 'SignalKConfigurationScreen';

  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final viewModel = context.read<SignalKConfigurationViewModel>();
    if (!viewModel.isLoading) {
      _hostController.text = viewModel.host;
      _tokenController.text = viewModel.token;
      _initialized = true;
    } else {
      void listener() {
        if (!viewModel.isLoading) {
          _hostController.text = viewModel.host;
          _tokenController.text = viewModel.token;
          _initialized = true;
          viewModel.removeListener(listener);
          if (mounted) setState(() {});
        }
      }

      viewModel.addListener(listener);
    }
  }

  @override
  void dispose() {
    _hostController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<SignalKConfigurationViewModel>();
    await viewModel.save(
      host: _hostController.text,
      token: _tokenController.text,
    );
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.signalKConfigurationSaved),
        backgroundColor: Colors.grey[900],
      ),
    );
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
          title: Text(l10n.signalKConfiguration),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<SignalKConfigurationViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.signalKConfiguration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.signalKConfigurationDescription,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildFieldLabel(l10n.signalKHost),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _hostController,
                          hintText: l10n.signalKHostHint,
                          keyboardType: TextInputType.url,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.signalKHostRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildFieldLabel(l10n.signalKToken),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _tokenController,
                          hintText: l10n.signalKTokenHint,
                          autocorrect: false,
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: 8,
                        ),
                        if (Platform.isIOS) ...[
                          const SizedBox(height: 24),
                          _buildIosLocalNetworkNotice(l10n),
                        ],
                        const SizedBox(height: 32),
                        // TODO: implementar botão "Testar conexão" quando o
                        // cliente WebSocket SignalK for adicionado. A conexão
                        // real dispara o prompt de permissão de Rede Local no
                        // iOS no contexto certo e valida o servidor/token.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              l10n.save,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        if (viewModel.isConfigured) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () async {
                                await viewModel.clear();
                                if (!mounted) return;
                                _hostController.clear();
                                _tokenController.clear();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[400],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(l10n.signalKClearConfiguration),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIosLocalNetworkNotice(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: const Color(0xFF1F1F1F), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.signalKIosLocalNetworkNotice,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool autocorrect = true,
    TextInputAction? textInputAction,
    int? minLines,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
        filled: true,
        fillColor: const Color(0xFF0A0A0A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1F1F1F), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 13),
      ),
    );
  }
}
