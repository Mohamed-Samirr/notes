
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../../../core/auth/auth_service.dart';
import '../../../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<NoteModel> uploadNote(NoteModel note);
  Future<List<NoteModel>> getNotes();
  Future<void> deleteNote(String id);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final firestore.FirebaseFirestore _firestore;

  final AuthService _authService;

  NotesRemoteDataSourceImpl({
    firestore.FirebaseFirestore? firestoreInstance,

    required AuthService authService,
  }) : _firestore = firestoreInstance ?? firestore.FirebaseFirestore.instance,
       _authService = authService;

  @override
  Future<NoteModel> uploadNote(NoteModel note) async {
    try {
      final uid = await _authService.getCurrentUid();
      await _collection(uid).doc(note.id).set(note.toJson());
      return note;
    } catch (error) {
      throw FirebaseException('Failed to upload note ${note.id}: $error');
    }
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final uid = await _authService.getCurrentUid();
      final snapshot = await _collection(uid).get();
      return snapshot.docs
          .map((doc) => NoteModel.fromJson(doc.data()))
          .toList();
    } catch (error) {
      throw FirebaseException('Failed to fetch remote notes: $error');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final uid = await _authService.getCurrentUid();
      await _collection(uid).doc(id).delete();
    } catch (error) {
      throw FirebaseException('Failed to delete remote note $id: $error');
    }
  }

  firestore.CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('notes');
  }


}
