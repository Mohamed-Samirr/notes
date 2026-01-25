import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for getting all notes
class GetAllNotesUseCase {
  final NotesRepository repository;
  
  GetAllNotesUseCase(this.repository);
  
  Future<List<Note>> call() async {
    return await repository.getAllNotes();
  }
}

/// Use case for adding a new note
class AddNoteUseCase {
  final NotesRepository repository;
  
  AddNoteUseCase(this.repository);
  
  Future<void> call(Note note) async {
    await repository.addNote(note);
  }
}

/// Use case for updating an existing note
class UpdateNoteUseCase {
  final NotesRepository repository;
  
  UpdateNoteUseCase(this.repository);
  
  Future<void> call(Note note) async {
    await repository.updateNote(note);
  }
}

/// Use case for deleting a note
class DeleteNoteUseCase {
  final NotesRepository repository;
  
  DeleteNoteUseCase(this.repository);
  
  Future<void> call(String id) async {
    await repository.deleteNote(id);
  }
}
