part of 'journal_bloc.dart';

/// Base class for Journal events
abstract class JournalEvent extends Equatable {
  const JournalEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load all journal entries
class LoadAllEntriesEvent extends JournalEvent {
  const LoadAllEntriesEvent();
}

/// Event to load entry by specific date
class LoadEntryByDateEvent extends JournalEvent {
  final DateTime date;
  
  const LoadEntryByDateEvent({required this.date});
  
  @override
  List<Object?> get props => [date];
}

/// Event to save a journal entry
class SaveJournalEntryEvent extends JournalEvent {
  final JournalEntry entry;
  
  const SaveJournalEntryEvent({required this.entry});
  
  @override
  List<Object?> get props => [entry];
}

/// Event to delete a journal entry
class DeleteJournalEntryEvent extends JournalEvent {
  final String entryId;
  
  const DeleteJournalEntryEvent({required this.entryId});
  
  @override
  List<Object?> get props => [entryId];
}
