import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/journal_entry_model.dart';

/// Local data source for Journal using Hive
class JournalLocalDataSource {
  Future<Box<JournalEntryModel>> _getBox() async {
    return await Hive.openBox<JournalEntryModel>(AppConstants.journalBox);
  }
  
  /// Get all journal entries
  Future<List<JournalEntryModel>> getAllEntries() async {
    final box = await _getBox();
    return box.values.toList();
  }
  
  /// Get entry by date (normalized to day start)
  Future<JournalEntryModel?> getEntryByDate(DateTime date) async {
    final box = await _getBox();
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    for (var entry in box.values) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (entryDate == normalizedDate) {
        return entry;
      }
    }
    return null;
  }
  
  /// Save a journal entry
  Future<void> saveEntry(JournalEntryModel entry) async {
    final box = await _getBox();
    await box.put(entry.id, entry);
  }
  
  /// Delete a journal entry
  Future<void> deleteEntry(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
