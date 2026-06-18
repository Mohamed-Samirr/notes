part of 'notes_bloc.dart';

/// Base class for Notes events
abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all notes
class LoadNotesEvent extends NotesEvent {
  const LoadNotesEvent();
}

/// Event to add a new note
class AddNoteEvent extends NotesEvent {
  final Note note;

  const AddNoteEvent({required this.note});

  @override
  List<Object?> get props => [note];
}

/// Event to update an existing note
class UpdateNoteEvent extends NotesEvent {
  final Note note;

  const UpdateNoteEvent({required this.note});

  @override
  List<Object?> get props => [note];
}

/// Event to delete a note
class DeleteNoteEvent extends NotesEvent {
  final String noteId;

  const DeleteNoteEvent({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}
