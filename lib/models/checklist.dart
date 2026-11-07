import 'dart:math';
import 'checklist_trigger.dart';

/// Item de um checklist.
class ChecklistItem {
  final String id;
  final String text;

  const ChecklistItem({required this.id, required this.text});

  ChecklistItem copyWith({String? text}) =>
      ChecklistItem(id: id, text: text ?? this.text);

  Map<String, dynamic> toJson() => {'id': id, 'text': text};

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }
}

/// Checklist salvo no aparelho. Não guarda o que foi marcado: cada
/// execução começa desmarcada.
class Checklist {
  static const int maxNameLength = 60;
  static const int maxItemLength = 120;
  static const int maxItems = 50;

  final String id;
  final String name;
  final ChecklistTrigger trigger;
  final List<ChecklistItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Checklist({
    required this.id,
    required this.name,
    required this.trigger,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  static final Random _random = Random();

  /// Id local único o bastante para o aparelho, sem dependência extra.
  static String generateId() {
    final time = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final noise = _random.nextInt(1 << 32).toRadixString(36);
    return '$time$noise';
  }

  Checklist copyWith({
    String? name,
    ChecklistTrigger? trigger,
    List<ChecklistItem>? items,
    DateTime? updatedAt,
  }) {
    return Checklist(
      id: id,
      name: name ?? this.name,
      trigger: trigger ?? this.trigger,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'trigger': trigger.apiValue,
    'items': items.map((item) => item.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'] as String,
      name: json['name'] as String,
      trigger: ChecklistTrigger.fromApiValue(json['trigger'] as String?),
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
