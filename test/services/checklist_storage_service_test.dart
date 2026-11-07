import 'package:estai/models/checklist.dart';
import 'package:estai/models/checklist_trigger.dart';
import 'package:estai/services/checklist_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Checklist checklist(
  String id, {
  ChecklistTrigger trigger = ChecklistTrigger.none,
  List<String> items = const ['Item'],
}) {
  final now = DateTime.utc(2026, 11, 7);
  return Checklist(
    id: id,
    name: 'Checklist $id',
    trigger: trigger,
    items: [
      for (var i = 0; i < items.length; i++)
        ChecklistItem(id: '$id-$i', text: items[i]),
    ],
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late ChecklistStorageService storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = ChecklistStorageService();
  });

  test('saves, updates and deletes', () async {
    await storage.save(checklist('a'));
    await storage.save(checklist('b'));
    await storage.save(checklist('a').copyWith(name: 'Renomeado'));

    var all = await storage.getAll();
    expect(all.map((c) => c.id), ['a', 'b']);
    expect(all.first.name, 'Renomeado');
    expect(all.first.items.single.text, 'Item');

    await storage.delete('a');
    all = await storage.getAll();
    expect(all.map((c) => c.id), ['b']);
  });

  test('getByTrigger filters by trigger and skips empty checklists', () async {
    await storage.save(
      checklist('before', trigger: ChecklistTrigger.beforeNavigation),
    );
    await storage.save(
      checklist(
        'empty',
        trigger: ChecklistTrigger.beforeNavigation,
        items: const [],
      ),
    );
    await storage.save(
      checklist('after', trigger: ChecklistTrigger.afterNavigation),
    );

    final before = await storage.getByTrigger(
      ChecklistTrigger.beforeNavigation,
    );
    expect(before.map((c) => c.id), ['before']);
  });

  test('defaults are seeded only once', () async {
    var calls = 0;
    List<Checklist> defaults() {
      calls++;
      return [checklist('default')];
    }

    await storage.ensureDefaults(defaults);
    await storage.delete('default');
    await storage.ensureDefaults(defaults);

    expect(calls, 1);
    expect(await storage.getAll(), isEmpty);
  });

  test('corrupted data reads as empty', () async {
    SharedPreferences.setMockInitialValues({'checklists': '{not json'});

    expect(await storage.getAll(), isEmpty);
    expect(await storage.getByTrigger(ChecklistTrigger.none), isEmpty);
  });
}
