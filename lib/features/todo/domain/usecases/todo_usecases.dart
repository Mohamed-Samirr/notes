import '../entities/todo_task.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all tasks
class GetAllTasksUseCase {
  final TodoRepository repository;

  GetAllTasksUseCase(this.repository);

  Future<List<TodoTask>> call() async {
    return await repository.getAllTasks();
  }
}

/// Use case for getting tasks by date
class GetTasksByDateUseCase {
  final TodoRepository repository;

  GetTasksByDateUseCase(this.repository);

  Future<List<TodoTask>> call(DateTime date) async {
    return await repository.getTasksByDate(date);
  }
}

/// Use case for adding a new task
class AddTaskUseCase {
  final TodoRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(TodoTask task) async {
    await repository.addTask(task);
  }
}

/// Use case for updating a task
class UpdateTaskUseCase {
  final TodoRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(TodoTask task) async {
    await repository.updateTask(task);
  }
}

/// Use case for deleting a task
class DeleteTaskUseCase {
  final TodoRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTask(id);
  }
}

/// Use case for toggling task completion
class ToggleTaskCompletionUseCase {
  final TodoRepository repository;

  ToggleTaskCompletionUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.toggleTaskCompletion(id);
  }
}
