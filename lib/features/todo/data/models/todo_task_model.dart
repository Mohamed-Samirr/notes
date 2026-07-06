import 'package:hive/hive.dart';
import '../../domain/entities/todo_task.dart';

part 'todo_task_model.g.dart';

/// Data model for ToDo Task with Hive adapter
@HiveType(typeId: 2)
class TodoTaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final bool isSynced;

  @HiveField(7)
  final bool isDeleted;

  TodoTaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  factory TodoTaskModel.fromJson(Map<String, dynamic> json) {
    // Tombstone docs may only carry id/isDeleted/updatedAt.
    final updatedAt =
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return TodoTaskModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? updatedAt,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? updatedAt,
      updatedAt: updatedAt,
      isSynced: true,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  TodoTaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TodoTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// Convert domain entity to data model
  factory TodoTaskModel.fromEntity(TodoTask task) {
    return TodoTaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      date: task.date,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      isSynced: task.isSynced,
      isDeleted: task.isDeleted,
    );
  }

  /// Convert data model to domain entity
  TodoTask toEntity() {
    return TodoTask(
      id: id,
      title: title,
      isCompleted: isCompleted,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }
}
