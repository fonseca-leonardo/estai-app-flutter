import '../l10n/app_localizations.dart';
import 'checklist.dart';
import 'checklist_trigger.dart';

/// Modelos criados no primeiro acesso aos checklists, no idioma atual.
/// Depois disso são checklists comuns: o usuário edita ou exclui.
abstract final class ChecklistDefaults {
  static List<Checklist> build(AppLocalizations l10n, {DateTime? now}) {
    final timestamp = now ?? DateTime.now();

    Checklist checklist(
      String name,
      ChecklistTrigger trigger,
      List<String> items,
    ) {
      return Checklist(
        id: Checklist.generateId(),
        name: name,
        trigger: trigger,
        items: [
          for (final text in items)
            ChecklistItem(id: Checklist.generateId(), text: text),
        ],
        createdAt: timestamp,
        updatedAt: timestamp,
      );
    }

    return [
      checklist(
        l10n.checklistDefaultBeforeName,
        ChecklistTrigger.beforeNavigation,
        [
          l10n.checklistDefaultBeforeFuel,
          l10n.checklistDefaultBeforeOil,
          l10n.checklistDefaultBeforeDrainPlug,
          l10n.checklistDefaultBeforeBattery,
          l10n.checklistDefaultBeforeLifeJackets,
          l10n.checklistDefaultBeforeSafety,
          l10n.checklistDefaultBeforeWeather,
          l10n.checklistDefaultBeforeFloatPlan,
        ],
      ),
      checklist(
        l10n.checklistDefaultAfterName,
        ChecklistTrigger.afterNavigation,
        [
          l10n.checklistDefaultAfterFlushEngine,
          l10n.checklistDefaultAfterFuelValve,
          l10n.checklistDefaultAfterMainSwitch,
          l10n.checklistDefaultAfterTrash,
          l10n.checklistDefaultAfterLines,
          l10n.checklistDefaultAfterCover,
        ],
      ),
    ];
  }
}
