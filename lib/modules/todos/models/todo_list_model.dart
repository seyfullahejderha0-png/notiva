import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoItem {
  final String id;
  final String text;
  final bool isCompleted;

  ToDoItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
    };
  }

  factory ToDoItem.fromMap(Map<String, dynamic> map) {
    return ToDoItem(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  ToDoItem copyWith({
    String? id,
    String? text,
    bool? isCompleted,
  }) {
    return ToDoItem(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ToDoListModel {
  final String id;
  final String workspaceId;
  final String title;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ToDoItem> items;
  final bool isArchived;

  ToDoListModel({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workspaceId': workspaceId,
      'title': title,
      'color': color,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'items': items.map((x) => x.toMap()).toList(),
      'isArchived': isArchived,
    };
  }

  factory ToDoListModel.fromMap(Map<String, dynamic> map, String id) {
    return ToDoListModel(
      id: id,
      workspaceId: map['workspaceId'] ?? '',
      title: map['title'] ?? '',
      color: map['color'] ?? 0xFFE0E0E0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: List<ToDoItem>.from(
        (map['items'] as List<dynamic>? ?? []).map((x) => ToDoItem.fromMap(x)),
      ),
      isArchived: map['isArchived'] ?? false,
    );
  }

  ToDoListModel copyWith({
    String? id,
    String? workspaceId,
    String? title,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ToDoItem>? items,
    bool? isArchived,
  }) {
    return ToDoListModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      title: title ?? this.title,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
