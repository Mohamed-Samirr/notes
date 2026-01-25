part of 'todo_bloc.dart';

/// Base class for ToDo states
abstract class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class TodoInitial extends TodoState {}

/// Loading state
class TodoLoading extends TodoState {}

/// Loaded state with tasks data
class TodoLoaded extends TodoState {
  final List<TodoTask> tasks;
  
  const TodoLoaded({required this.tasks});
  
  @override
  List<Object?> get props => [tasks];
}

/// Error state
class TodoError extends TodoState {
  final String message;
  
  const TodoError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
