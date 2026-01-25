import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

/// Use case for getting all journal entries
class GetAllEntriesUseCase {
  final JournalRepository repository;
  
  GetAllEntriesUseCase(this.repository);
  
  Future<List<JournalEntry>> call() async {
    return await repository.getAllEntries();
  }
}

/// Use case for getting entry by date
class GetEntryByDateUseCase {
  final JournalRepository repository;
  
  GetEntryByDateUseCase(this.repository);
  
  Future<JournalEntry?> call(DateTime date) async {
    return await repository.getEntryByDate(date);
  }
}

/// Use case for saving a journal entry
class SaveJournalEntryUseCase {
  final JournalRepository repository;
  
  SaveJournalEntryUseCase(this.repository);
  
  Future<void> call(JournalEntry entry) async {
    await repository.saveEntry(entry);
  }
}

/// Use case for deleting a journal entry
class DeleteJournalEntryUseCase {
  final JournalRepository repository;
  
  DeleteJournalEntryUseCase(this.repository);
  
  Future<void> call(String id) async {
    await repository.deleteEntry(id);
  }
}
