import 'dart:developer';

import '../../domain/entities/todo_task.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../datasources/todo_remote_data_source.dart';
import '../models/todo_task_model.dart';

/// Implementation of TodoRepository
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  final TodoRemoteDataSource? remoteDataSource;

  TodoRepositoryImpl(this.localDataSource, {this.remoteDataSource});

  @override
  Future<List<TodoTask>> getAllTasks() async {
    final taskModels = await localDataSource.getAllTasks();
    // Sort: incomplete first, then by creation date
    taskModels.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TodoTask>> getTasksByDate(DateTime date) async {
    final taskModels = await localDataSource.getTasksByDate(date);
    // Sort: incomplete first, then by creation date
    taskModels.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTask(TodoTask task) async {
    final taskModel = TodoTaskModel.fromEntity(task).copyWith(isSynced: false);
    await localDataSource.addTask(taskModel);
    await _tryUpload(taskModel);
  }

  @override
  Future<void> updateTask(TodoTask task) async {
    final taskModel = TodoTaskModel.fromEntity(
      task,
    ).copyWith(isSynced: false, isDeleted: false);
    await localDataSource.updateTask(taskModel);
    await _tryUpload(taskModel);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
    if (remoteDataSource == null) return;

    try {
      await remoteDataSource!.deleteTask(id);
      await localDataSource.permanentlyDeleteTask(id);
    } catch (error) {
      log('Failed to sync deleted todo task $id', error: error);
    }
  }

  @override
  Future<void> toggleTaskCompletion(String id) async {
    final taskModel = await localDataSource.getTaskById(id);
    if (taskModel != null) {
      final updatedTask = TodoTaskModel(
        id: taskModel.id,
        title: taskModel.title,
        isCompleted: !taskModel.isCompleted,
        date: taskModel.date,
        createdAt: taskModel.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
        isDeleted: false,
      );
      await localDataSource.updateTask(updatedTask);
      await _tryUpload(updatedTask);
    }
  }

  Future<void> _tryUpload(TodoTaskModel task) async {
    if (remoteDataSource == null) return;

    try {
      await remoteDataSource!.uploadTask(task);
      await localDataSource.updateTask(task.copyWith(isSynced: true));
    } catch (error) {
      log('Failed to sync todo task ${task.id}', error: error);
    }
  }
}
