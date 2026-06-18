part of 'todo_bloc.dart';

/// Base class for ToDo events
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all tasks
class LoadAllTasksEvent extends TodoEvent {
  const LoadAllTasksEvent();
}

/// Event to load tasks by specific date
class LoadTasksByDateEvent extends TodoEvent {
  final DateTime date;

  const LoadTasksByDateEvent({required this.date});

  @override
  List<Object?> get props => [date];
}

/// Event to add a new task
class AddTaskEvent extends TodoEvent {
  final TodoTask task;

  const AddTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Event to update an existing task
class UpdateTaskEvent extends TodoEvent {
  final TodoTask task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Event to delete a task
class DeleteTaskEvent extends TodoEvent {
  final String taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

/// Event to toggle task completion
class ToggleTaskCompletionEvent extends TodoEvent {
  final String taskId;

  const ToggleTaskCompletionEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
