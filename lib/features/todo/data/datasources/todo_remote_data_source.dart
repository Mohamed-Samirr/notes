import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../../../core/auth/auth_service.dart';
import '../../../../core/error/exceptions.dart';
import '../models/todo_task_model.dart';

abstract class TodoRemoteDataSource {
  Future<void> uploadTask(TodoTaskModel task);
  Future<List<TodoTaskModel>> getTasks();
  Future<void> deleteTask(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final firestore.FirebaseFirestore _firestore;
  final AuthService _authService;

  TodoRemoteDataSourceImpl({
    firestore.FirebaseFirestore? firestoreInstance,
    required AuthService authService,
  }) : _firestore = firestoreInstance ?? firestore.FirebaseFirestore.instance,
       _authService = authService;

  @override
  Future<void> uploadTask(TodoTaskModel task) async {
    try {
      final uid = await _authService.getCurrentUid();
      await _collection(uid).doc(task.id).set(task.toJson());
    } catch (error) {
      throw FirebaseException('Failed to upload todo task ${task.id}: $error');
    }
  }

  @override
  Future<List<TodoTaskModel>> getTasks() async {
    try {
      final uid = await _authService.getCurrentUid();
      final snapshot = await _collection(uid).get();
      return snapshot.docs
          .map((doc) => TodoTaskModel.fromJson(doc.data()))
          .toList();
    } catch (error) {
      throw FirebaseException('Failed to fetch remote todo tasks: $error');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final uid = await _authService.getCurrentUid();
      // Tombstone instead of hard delete so other devices see the deletion
      // and don't re-upload their stale copy.
      await _collection(uid).doc(id).set({
        'id': id,
        'isDeleted': true,
        'updatedAt': DateTime.now().toIso8601String(),
      }, firestore.SetOptions(merge: true));
    } catch (error) {
      throw FirebaseException('Failed to delete remote todo task $id: $error');
    }
  }

  firestore.CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('todos');
  }
}
