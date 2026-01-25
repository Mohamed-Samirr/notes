import 'package:equatable/equatable.dart';

/// Domain entity representing a ToDo Task
class TodoTask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime date;
  final DateTime createdAt;
  
  const TodoTask({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.createdAt,
  });
  
  TodoTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return TodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [id, title, isCompleted, date, createdAt];
}
