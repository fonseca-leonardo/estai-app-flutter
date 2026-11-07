import 'package:estai/models/checklist.dart';
import 'package:estai/models/checklist_trigger.dart';
import 'package:estai/services/checklist_storage_service.dart';
import 'package:estai/viewmodels/checklist_form_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ChecklistStorageService storage;
  late int nextId;

  ChecklistFormViewModel create({Checklist? initial}) {
    return ChecklistFormViewModel(
      initial: initial,
      storage: storage,
      idGenerator: () => 'id${nextId++}',
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = ChecklistStorageService();
    nextId = 0;
  });

  test('starts with one empty item and defaults to before navigation', () {
    final viewModel = create();

    expect(viewModel.items, hasLength(1));
    expect(viewModel.items.single.text, isEmpty);
    expect(viewModel.trigger, ChecklistTrigger.beforeNavigation);
    expect(viewModel.lastAddedId, isNull);
  });

  test('requires a name and at least one filled item', () async {
    final viewModel = create();

    expect(await viewModel.save(name: '  '), isFalse);
    expect(viewModel.error, ChecklistFormError.missingName);

    expect(await viewModel.save(name: 'Saída'), isFalse);
    expect(viewModel.error, ChecklistFormError.noItems);
    expect(await storage.getAll(), isEmpty);
  });

  test('saves trimmed items and drops blank ones', () async {
    final viewModel = create();
    viewModel.updateItem(viewModel.items.first.id, '  Combustível ');
    viewModel.addItem();
    viewModel.addItem();
    viewModel.updateItem(viewModel.items.last.id, 'Coletes');
    viewModel.setTrigger(ChecklistTrigger.none);

    expect(await viewModel.save(name: ' Saída '), isTrue);

    final saved = (await storage.getAll()).single;
    expect(saved.name, 'Saída');
    expect(saved.trigger, ChecklistTrigger.none);
    expect(saved.items.map((item) => item.text), ['Combustível', 'Coletes']);
  });

  test('reorder moves an item to its final index', () {
    final viewModel = create();
    viewModel.addItem();
    viewModel.addItem();
    final ids = viewModel.items.map((item) => item.id).toList();

    viewModel.reorder(0, 2);
    expect(viewModel.items.map((item) => item.id), [ids[1], ids[2], ids[0]]);

    viewModel.reorder(2, 0);
    expect(viewModel.items.map((item) => item.id), ids);
  });

  test('editing keeps the id and delete removes it', () async {
    final now = DateTime.utc(2026, 11, 7);
    final initial = Checklist(
      id: 'existing',
      name: 'Antes de sair',
      trigger: ChecklistTrigger.beforeNavigation,
      items: const [ChecklistItem(id: 'i1', text: 'Óleo')],
      createdAt: now,
      updatedAt: now,
    );
    await storage.save(initial);

    final viewModel = create(initial: initial);
    viewModel.removeItem('i1');
    viewModel.addItem();
    viewModel.updateItem(viewModel.items.single.id, 'Bujão');
    expect(await viewModel.save(name: 'Saída'), isTrue);

    final saved = (await storage.getAll()).single;
    expect(saved.id, 'existing');
    expect(saved.items.single.text, 'Bujão');

    expect(await viewModel.delete(), isTrue);
    expect(await storage.getAll(), isEmpty);
  });
}
