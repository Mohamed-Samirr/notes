import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/notes_usecases.dart';

part 'notes_event.dart';
part 'notes_state.dart';

/// BLoC for managing notes
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNotesUseCase getAllNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NotesBloc({
    required this.getAllNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(NotesInitial()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  /// Load all notes
  Future<void> _onLoadNotes(
    LoadNotesEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    try {
      final notes = await getAllNotesUseCase();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to load notes: ${e.toString()}'));
    }
  }

  /// Add a new note
  Future<void> _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await addNoteUseCase(event.note);
      // Reload notes after adding
      final notes = await getAllNotesUseCase();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to add note: ${e.toString()}'));
    }
  }

  /// Update an existing note
  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await updateNoteUseCase(event.note);
      // Reload notes after updating
      final notes = await getAllNotesUseCase();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to update note: ${e.toString()}'));
    }
  }

  /// Delete a note
  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await deleteNoteUseCase(event.noteId);
      // Reload notes after deleting
      final notes = await getAllNotesUseCase();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to delete note: ${e.toString()}'));
    }
  }
}
