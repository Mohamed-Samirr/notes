import 'dart:developer';

import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_data_source.dart';
import '../datasources/journal_remote_data_source.dart';
import '../models/journal_entry_model.dart';

/// Implementation of JournalRepository
class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;
  final JournalRemoteDataSource? remoteDataSource;

  JournalRepositoryImpl(this.localDataSource, {this.remoteDataSource});

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
    final entryModel = JournalEntryModel.fromEntity(
      entry,
    ).copyWith(isSynced: false, isDeleted: false);
    await localDataSource.saveEntry(entryModel);
    await _tryUpload(entryModel);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await localDataSource.deleteEntry(id);
    if (remoteDataSource == null) return;

    try {
      await remoteDataSource!.deleteEntry(id);
      await localDataSource.permanentlyDeleteEntry(id);
    } catch (error) {
      log('Failed to sync deleted journal entry $id', error: error);
    }
  }

  Future<void> _tryUpload(JournalEntryModel entry) async {
    if (remoteDataSource == null) return;

    try {
      await remoteDataSource!.uploadEntry(entry);
      await localDataSource.saveEntry(entry.copyWith(isSynced: true));
    } catch (error) {
      log('Failed to sync journal entry ${entry.id}', error: error);
    }
  }
}
