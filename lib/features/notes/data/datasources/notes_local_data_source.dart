import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/note_model.dart';

/// Local data source for Notes using Hive
class NotesLocalDataSource {
  Future<Box<NoteModel>> _getBox() async {
    return await Hive.openBox<NoteModel>(AppConstants.notesBox);
  }

  /// Get all notes from local storage
  Future<List<NoteModel>> getAllNotes() async {
    final box = await _getBox();
    return box.values.where((note) => !note.isDeleted).toList();
  }

  Future<List<NoteModel>> getAllNotesIncludingDeleted() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<List<NoteModel>> getUnsyncedNotes() async {
    final box = await _getBox();
    return box.values.where((note) => !note.isSynced).toList();
  }

  /// Get a specific note by ID
  Future<NoteModel?> getNoteById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  /// Add a new note to local storage
  Future<void> addNote(NoteModel note) async {
    final box = await _getBox();
    await box.put(note.id, note);
  }

  /// Update an existing note
  Future<void> updateNote(NoteModel note) async {
    final box = await _getBox();
    await box.put(note.id, note);
  }

  Future<void> upsertNote(NoteModel note) async {
    final box = await _getBox();
    await box.put(note.id, note);
  }

  /// Soft delete a note by ID so Firebase can sync the deletion.
  Future<void> deleteNote(String id) async {
    final box = await _getBox();
    final note = box.get(id);
    if (note == null) return;
    await box.put(
      id,
      note.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
        isDeleted: true,
      ),
    );
  }

  Future<void> permanentlyDeleteNote(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
