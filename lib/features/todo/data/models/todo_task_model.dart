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
  
  TodoTaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.createdAt,
  });
  
  /// Convert domain entity to data model
  factory TodoTaskModel.fromEntity(TodoTask task) {
    return TodoTaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      date: task.date,
      createdAt: task.createdAt,
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
    );
  }
}
