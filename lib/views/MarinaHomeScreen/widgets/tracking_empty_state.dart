import 'package:flutter/material.dart';
import '../../../widgets/ui/empty_state.dart';

/// Lista vazia no acompanhamento, com um atalho para começar.
class TrackingEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const TrackingEmptyState({
    super.key,
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: icon,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
