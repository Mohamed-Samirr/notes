import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_data_source.dart';
import '../models/journal_entry_model.dart';

/// Implementation of JournalRepository
class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;
  
  JournalRepositoryImpl(this.localDataSource);
  
  @override
  Future<List<JournalEntry>> getAllEntries() async {
    final entryModels = await localDataSource.getAllEntries();
    // Sort by most recent first
    entryModels.sort((a, b) => b.date.compareTo(a.date));
    return entryModels.map((model) => model.toEntity()).toList();
  }
  
  @override
  Future<JournalEntry?> getEntryByDate(DateTime date) async {
    final entryModel = await localDataSource.getEntryByDate(date);
    return entryModel?.toEntity();
  }
  
  @override
  Future<void> saveEntry(JournalEntry entry) async {
    final entryModel = JournalEntryModel.fromEntity(entry);
    await localDataSource.saveEntry(entryModel);
  }
  
  @override
  Future<void> deleteEntry(String id) async {
    await localDataSource.deleteEntry(id);
  }
}
