import '../entities/note.dart';

/// Repository interface for Notes
/// Defines the contract for data operations
abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(String id);
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
}
