import 'dart:developer';

import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../datasources/notes_remote_data_source.dart';
import '../models/note_model.dart';

/// Implementation of NotesRepository
class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;
  final NotesRemoteDataSource? remoteDataSource;

  NotesRepositoryImpl(this.localDataSource, {this.remoteDataSource});

  @override
  Future<List<Note>> getAllNotes() async {
    final noteModels = await localDataSource.getAllNotes();
    // Sort by most recent first
    noteModels.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return noteModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final noteModel = await localDataSource.getNoteById(id);
    return noteModel?.toEntity();
  }

  @override
  Future<void> addNote(Note note) async {
    final noteModel = NoteModel.fromEntity(note).copyWith(isSynced: false);
    await localDataSource.addNote(noteModel);
    await _tryUpload(noteModel);
  }

  @override
  Future<void> updateNote(Note note) async {
    final noteModel = NoteModel.fromEntity(
      note,
    ).copyWith(updatedAt: note.updatedAt, isSynced: false, isDeleted: false);
    await localDataSource.updateNote(noteModel);
    await _tryUpload(noteModel);
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
    if (remoteDataSource == null) return;

    try {
      await remoteDataSource!.deleteNote(id);
      await localDataSource.permanentlyDeleteNote(id);
    } catch (error) {
      log('Failed to sync deleted note $id', error: error);
    }
  }

  Future<void> _tryUpload(NoteModel note) async {
    if (remoteDataSource == null) return;

    try {
      final syncedNote = await remoteDataSource!.uploadNote(note);
      await localDataSource.updateNote(syncedNote.copyWith(isSynced: true));
    } catch (error) {
      log('Failed to sync note ${note.id}', error: error);
    }
  }
}
