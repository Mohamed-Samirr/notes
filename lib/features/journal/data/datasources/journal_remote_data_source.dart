import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../../../core/auth/auth_service.dart';
import '../../../../core/error/exceptions.dart';
import '../models/journal_entry_model.dart';

abstract class JournalRemoteDataSource {
  Future<void> uploadEntry(JournalEntryModel entry);
  Future<List<JournalEntryModel>> getEntries();
  Future<void> deleteEntry(String id);
}

class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final firestore.FirebaseFirestore _firestore;
  final AuthService _authService;

  JournalRemoteDataSourceImpl({
    firestore.FirebaseFirestore? firestoreInstance,
    required AuthService authService,
  }) : _firestore = firestoreInstance ?? firestore.FirebaseFirestore.instance,
       _authService = authService;

  @override
  Future<void> uploadEntry(JournalEntryModel entry) async {
    try {
      final uid = await _authService.getCurrentUid();
      await _collection(uid).doc(entry.id).set(entry.toJson());
    } catch (error) {
      throw FirebaseException(
        'Failed to upload journal entry ${entry.id}: $error',
      );
    }
  }

  @override
  Future<List<JournalEntryModel>> getEntries() async {
    try {
      final uid = await _authService.getCurrentUid();
      final snapshot = await _collection(uid).get();
      return snapshot.docs
          .map((doc) => JournalEntryModel.fromJson(doc.data()))
          .toList();
    } catch (error) {
      throw FirebaseException('Failed to fetch remote journal entries: $error');
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      final uid = await _authService.getCurrentUid();
      await _collection(uid).doc(id).delete();
    } catch (error) {
      throw FirebaseException(
        'Failed to delete remote journal entry $id: $error',
      );
    }
  }

  firestore.CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('journal');
  }
}
