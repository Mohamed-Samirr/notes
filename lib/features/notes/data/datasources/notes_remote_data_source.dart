import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;

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
  final storage.FirebaseStorage _storage;
  final AuthService _authService;

  NotesRemoteDataSourceImpl({
    firestore.FirebaseFirestore? firestoreInstance,
    storage.FirebaseStorage? storageInstance,
    required AuthService authService,
  }) : _firestore = firestoreInstance ?? firestore.FirebaseFirestore.instance,
       _storage = storageInstance ?? storage.FirebaseStorage.instance,
       _authService = authService;

  @override
  Future<NoteModel> uploadNote(NoteModel note) async {
    try {
      final uid = await _authService.getCurrentUid();
      final remoteImageUrl = await _uploadImageIfNeeded(uid, note);
      final syncedNote = note.copyWith(remoteImageUrl: remoteImageUrl);

      await _collection(uid).doc(note.id).set(syncedNote.toJson());
      return syncedNote;
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

  Future<String?> _uploadImageIfNeeded(String uid, NoteModel note) async {
    final localPath = note.localImagePath ?? note.imagePath;
    if (localPath == null || localPath.isEmpty) return note.remoteImageUrl;
    if (note.remoteImageUrl != null && note.remoteImageUrl!.isNotEmpty) {
      return note.remoteImageUrl;
    }

    final file = File(localPath);
    if (!file.existsSync()) return note.remoteImageUrl;

    final imageRef = _storage.ref('users/$uid/images/${note.id}');
    await imageRef.putFile(file);
    return imageRef.getDownloadURL();
  }
}
