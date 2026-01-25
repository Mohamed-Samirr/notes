import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/usecases/todo_usecases.dart';

part 'todo_event.dart';
part 'todo_state.dart';

/// BLoC for managing ToDo tasks
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetAllTasksUseCase getAllTasksUseCase;
  final GetTasksByDateUseCase getTasksByDateUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final ToggleTaskCompletionUseCase toggleTaskCompletionUseCase;
  
  TodoBloc({
    required this.getAllTasksUseCase,
    required this.getTasksByDateUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.toggleTaskCompletionUseCase,
  }) : super(TodoInitial()) {
    on<LoadAllTasksEvent>(_onLoadAllTasks);
    on<LoadTasksByDateEvent>(_onLoadTasksByDate);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
  }
  
  /// Load all tasks
  Future<void> _onLoadAllTasks(
    LoadAllTasksEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      final tasks = await getAllTasksUseCase();
      emit(TodoLoaded(tasks: tasks));
    } catch (e) {
      emit(TodoError(message: 'Failed to load tasks: ${e.toString()}'));
    }
  }
  
  /// Load tasks for a specific date
  Future<void> _onLoadTasksByDate(
    LoadTasksByDateEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      final tasks = await getTasksByDateUseCase(event.date);
      emit(TodoLoaded(tasks: tasks));
    } catch (e) {
      emit(TodoError(message: 'Failed to load tasks: ${e.toString()}'));
    }
  }
  
  /// Add a new task
  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await addTaskUseCase(event.task);
      // Reload tasks for the task's date
      final tasks = await getTasksByDateUseCase(event.task.date);
      emit(TodoLoaded(tasks: tasks));
    } catch (e) {
      emit(TodoError(message: 'Failed to add task: ${e.toString()}'));
    }
  }
  
  /// Update an existing task
  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await updateTaskUseCase(event.task);
      // Reload tasks for the task's date
      final tasks = await getTasksByDateUseCase(event.task.date);
      emit(TodoLoaded(tasks: tasks));
    } catch (e) {
      emit(TodoError(message: 'Failed to update task: ${e.toString()}'));
    }
  }
  
  /// Delete a task
  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await deleteTaskUseCase(event.taskId);
      // Reload all tasks (or you can track the current date)
      final tasks = await getTasksByDateUseCase(DateTime.now());
      emit(TodoLoaded(tasks: tasks));
    } catch (e) {
      emit(TodoError(message: 'Failed to delete task: ${e.toString()}'));
    }
  }
  
  /// Toggle task completion status
  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await toggleTaskCompletionUseCase(event.taskId);
      // Reload tasks for today
      final tasks = await getTasksByDateUseCase(DateTime.now());
      emit(TodoLoaded(tasks: tasks));
    } catch (e) {
      emit(TodoError(message: 'Failed to toggle task: ${e.toString()}'));
    }
  }
}
