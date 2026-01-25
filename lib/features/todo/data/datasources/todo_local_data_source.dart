import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/todo_task_model.dart';

/// Local data source for ToDo tasks using Hive
class TodoLocalDataSource {
  Future<Box<TodoTaskModel>> _getBox() async {
    return await Hive.openBox<TodoTaskModel>(AppConstants.todoBox);
  }
  
  /// Get all tasks
  Future<List<TodoTaskModel>> getAllTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }
  
  /// Get tasks by date (normalized to day)
  Future<List<TodoTaskModel>> getTasksByDate(DateTime date) async {
    final box = await _getBox();
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    return box.values.where((task) {
      final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
      return taskDate == normalizedDate;
    }).toList();
  }
  
  /// Get a specific task by ID
  Future<TodoTaskModel?> getTaskById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }
  
  /// Add a new task
  Future<void> addTask(TodoTaskModel task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }
  
  /// Update an existing task
  Future<void> updateTask(TodoTaskModel task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }
  
  /// Delete a task
  Future<void> deleteTask(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
