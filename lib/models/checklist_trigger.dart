import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Quando o checklist aparece sozinho: ao iniciar a navegação, ao
/// encerrar, ou nunca (só aberto manualmente).
enum ChecklistTrigger {
  beforeNavigation('BeforeNavigation', Icons.sailing_outlined),
  afterNavigation('AfterNavigation', Icons.anchor_outlined),
  none('None', Icons.checklist_rounded);

  const ChecklistTrigger(this.apiValue, this.icon);

  /// Valor gravado no JSON local.
  final String apiValue;
  final IconData icon;

  static ChecklistTrigger fromApiValue(String? value) {
    return ChecklistTrigger.values.firstWhere(
      (trigger) => trigger.apiValue == value,
      orElse: () => ChecklistTrigger.none,
    );
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case ChecklistTrigger.beforeNavigation:
        return l10n.checklistTriggerBefore;
      case ChecklistTrigger.afterNavigation:
        return l10n.checklistTriggerAfter;
      case ChecklistTrigger.none:
        return l10n.checklistTriggerNone;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case ChecklistTrigger.beforeNavigation:
        return l10n.checklistTriggerBeforeDescription;
      case ChecklistTrigger.afterNavigation:
        return l10n.checklistTriggerAfterDescription;
      case ChecklistTrigger.none:
        return l10n.checklistTriggerNoneDescription;
    }
  }
}
