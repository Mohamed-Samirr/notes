part of 'journal_bloc.dart';

/// Base class for Journal states
abstract class JournalState extends Equatable {
  const JournalState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class JournalInitial extends JournalState {}

/// Loading state
class JournalLoading extends JournalState {}

/// State when all entries are loaded
class JournalEntriesLoaded extends JournalState {
  final List<JournalEntry> entries;
  
  const JournalEntriesLoaded({required this.entries});
  
  @override
  List<Object?> get props => [entries];
}

/// State when a specific date's entry is loaded
class JournalEntryLoaded extends JournalState {
  final JournalEntry? entry;
  final DateTime date;
  
  const JournalEntryLoaded({required this.entry, required this.date});
  
  @override
  List<Object?> get props => [entry, date];
}

/// Error state
class JournalError extends JournalState {
  final String message;
  
  const JournalError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
