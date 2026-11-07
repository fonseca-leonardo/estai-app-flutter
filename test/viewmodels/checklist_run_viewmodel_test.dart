import 'package:estai/models/checklist.dart';
import 'package:estai/models/checklist_trigger.dart';
import 'package:estai/viewmodels/checklist_run_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

Checklist checklist(String id, int itemCount) {
  final now = DateTime.utc(2026, 11, 7);
  return Checklist(
    id: id,
    name: id,
    trigger: ChecklistTrigger.beforeNavigation,
    items: [
      for (var i = 0; i < itemCount; i++)
        ChecklistItem(id: '$id-$i', text: 'Item $i'),
    ],
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  test('tracks progress across several checklists', () {
    final viewModel = ChecklistRunViewModel(
      checklists: [checklist('a', 2), checklist('b', 1)],
    );

    expect(viewModel.totalCount, 3);
    expect(viewModel.uncheckedCount, 3);
    expect(viewModel.isComplete, isFalse);

    viewModel.toggle('a-0');
    viewModel.toggle('b-0');
    expect(viewModel.checkedCount, 2);
    expect(viewModel.isChecked('a-0'), isTrue);

    viewModel.toggle('a-0');
    expect(viewModel.isChecked('a-0'), isFalse);
    expect(viewModel.uncheckedCount, 2);

    viewModel.toggle('a-0');
    viewModel.toggle('a-1');
    expect(viewModel.isComplete, isTrue);
    expect(viewModel.progress, 1);
  });

  test('reset unchecks everything', () {
    final viewModel = ChecklistRunViewModel(checklists: [checklist('a', 2)]);
    viewModel.toggle('a-0');

    viewModel.reset();

    expect(viewModel.checkedCount, 0);
    expect(viewModel.isComplete, isFalse);
  });
}
