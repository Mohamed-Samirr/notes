import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../models/note_model.dart';

/// Implementation of NotesRepository
class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;
  
  NotesRepositoryImpl(this.localDataSource);
  
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
    final noteModel = NoteModel.fromEntity(note);
    await localDataSource.addNote(noteModel);
  }
  
  @override
  Future<void> updateNote(Note note) async {
    final noteModel = NoteModel.fromEntity(note);
    await localDataSource.updateNote(noteModel);
  }
  
  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }
}
