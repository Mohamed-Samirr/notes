import 'package:equatable/equatable.dart';

/// Domain entity representing a ToDo Task
class TodoTask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;

  const TodoTask({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
    this.isDeleted = false,
  });

  TodoTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TodoTask(
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

  @override
  List<Object?> get props => [
    id,
    title,
    isCompleted,
    date,
    createdAt,
    updatedAt,
    isSynced,
    isDeleted,
  ];
}
