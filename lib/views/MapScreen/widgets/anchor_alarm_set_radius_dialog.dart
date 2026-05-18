import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../../../l10n/app_localizations.dart';

class AnchorAlarmSetRadiusDialog extends StatefulWidget {
  final LatLng anchorPoint;
  final void Function(double radius) onConfirm;

  const AnchorAlarmSetRadiusDialog({
    super.key,
    required this.anchorPoint,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context,
    LatLng anchorPoint,
    void Function(double radius) onConfirm,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnchorAlarmSetRadiusDialog(
        anchorPoint: anchorPoint,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AnchorAlarmSetRadiusDialog> createState() =>
      _AnchorAlarmSetRadiusDialogState();
}

class _AnchorAlarmSetRadiusDialogState
    extends State<AnchorAlarmSetRadiusDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final l10n = AppLocalizations.of(context)!;
    final value = double.tryParse(_controller.text.trim());
    if (value == null || value < 1 || value > 9999) {
      setState(() => _error = l10n.anchorAlarmRadiusError);
      return;
    }
    Navigator.of(context).pop();
    widget.onConfirm(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        spacing: 8,
        children: [
          const Icon(Icons.anchor, color: Colors.white, size: 20),
          Text(
            l10n.anchorAlarmSetTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              spacing: 8,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 16),
                Text(
                  '${widget.anchorPoint.latitude.toStringAsFixed(5)}, '
                  '${widget.anchorPoint.longitude.toStringAsFixed(5)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: l10n.anchorAlarmRadius,
              hintText: l10n.anchorAlarmRadiusHint,
              errorText: _error,
              labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              errorStyle: const TextStyle(color: Colors.redAccent),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              suffixText: 'm',
              suffixStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
            onSubmitted: (_) => _confirm(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          ),
        ),
        FilledButton(
          onPressed: _confirm,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
