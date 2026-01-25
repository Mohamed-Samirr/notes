import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/usecases/journal_usecases.dart';

part 'journal_event.dart';
part 'journal_state.dart';

/// BLoC for managing journal entries
class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final GetAllEntriesUseCase getAllEntriesUseCase;
  final GetEntryByDateUseCase getEntryByDateUseCase;
  final SaveJournalEntryUseCase saveJournalEntryUseCase;
  final DeleteJournalEntryUseCase deleteJournalEntryUseCase;
  
  JournalBloc({
    required this.getAllEntriesUseCase,
    required this.getEntryByDateUseCase,
    required this.saveJournalEntryUseCase,
    required this.deleteJournalEntryUseCase,
  }) : super(JournalInitial()) {
    on<LoadAllEntriesEvent>(_onLoadAllEntries);
    on<LoadEntryByDateEvent>(_onLoadEntryByDate);
    on<SaveJournalEntryEvent>(_onSaveEntry);
    on<DeleteJournalEntryEvent>(_onDeleteEntry);
  }
  
  /// Load all journal entries
  Future<void> _onLoadAllEntries(
    LoadAllEntriesEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    try {
      final entries = await getAllEntriesUseCase();
      emit(JournalEntriesLoaded(entries: entries));
    } catch (e) {
      emit(JournalError(message: 'Failed to load entries: ${e.toString()}'));
    }
  }
  
  /// Load entry for a specific date
  Future<void> _onLoadEntryByDate(
    LoadEntryByDateEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    try {
      final entry = await getEntryByDateUseCase(event.date);
      emit(JournalEntryLoaded(entry: entry, date: event.date));
    } catch (e) {
      emit(JournalError(message: 'Failed to load entry: ${e.toString()}'));
    }
  }
  
  /// Save a journal entry
  Future<void> _onSaveEntry(
    SaveJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await saveJournalEntryUseCase(event.entry);
      // Reload all entries to show the new one
      final entries = await getAllEntriesUseCase();
      emit(JournalEntriesLoaded(entries: entries));
    } catch (e) {
      emit(JournalError(message: 'Failed to save entry: ${e.toString()}'));
    }
  }
  
  /// Delete a journal entry
  Future<void> _onDeleteEntry(
    DeleteJournalEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await deleteJournalEntryUseCase(event.entryId);
      // Reload all entries
      final entries = await getAllEntriesUseCase();
      emit(JournalEntriesLoaded(entries: entries));
    } catch (e) {
      emit(JournalError(message: 'Failed to delete entry: ${e.toString()}'));
    }
  }
}
