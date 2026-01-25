import '../entities/todo_task.dart';

/// Repository interface for ToDo tasks
abstract class TodoRepository {
  Future<List<TodoTask>> getAllTasks();
  Future<List<TodoTask>> getTasksByDate(DateTime date);
  Future<void> addTask(TodoTask task);
  Future<void> updateTask(TodoTask task);
  Future<void> deleteTask(String id);
  Future<void> toggleTaskCompletion(String id);
}
