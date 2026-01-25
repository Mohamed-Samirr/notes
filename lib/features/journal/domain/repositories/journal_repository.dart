import '../entities/journal_entry.dart';

/// Repository interface for Journal entries
abstract class JournalRepository {
  Future<List<JournalEntry>> getAllEntries();
  Future<JournalEntry?> getEntryByDate(DateTime date);
  Future<void> saveEntry(JournalEntry entry);
  Future<void> deleteEntry(String id);
}
