import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../features/journal/data/datasources/journal_local_data_source.dart';
import '../../features/journal/data/datasources/journal_remote_data_source.dart';
import '../../features/journal/data/models/journal_entry_model.dart';
import '../../features/notes/data/datasources/notes_local_data_source.dart';
import '../../features/notes/data/datasources/notes_remote_data_source.dart';
import '../../features/todo/data/datasources/todo_local_data_source.dart';
import '../../features/todo/data/datasources/todo_remote_data_source.dart';
import '../../features/todo/data/models/todo_task_model.dart';

class SyncService {
  final Connectivity _connectivity;
  final NotesLocalDataSource _notesLocalDataSource;
  final NotesRemoteDataSource _notesRemoteDataSource;
  final JournalLocalDataSource _journalLocalDataSource;
  final JournalRemoteDataSource _journalRemoteDataSource;
  final TodoLocalDataSource _todoLocalDataSource;
  final TodoRemoteDataSource _todoRemoteDataSource;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService({
    Connectivity? connectivity,
    required NotesLocalDataSource notesLocalDataSource,
    required NotesRemoteDataSource notesRemoteDataSource,
    required JournalLocalDataSource journalLocalDataSource,
    required JournalRemoteDataSource journalRemoteDataSource,
    required TodoLocalDataSource todoLocalDataSource,
    required TodoRemoteDataSource todoRemoteDataSource,
  }) : _connectivity = connectivity ?? Connectivity(),
       _notesLocalDataSource = notesLocalDataSource,
       _notesRemoteDataSource = notesRemoteDataSource,
       _journalLocalDataSource = journalLocalDataSource,
       _journalRemoteDataSource = journalRemoteDataSource,
       _todoLocalDataSource = todoLocalDataSource,
       _todoRemoteDataSource = todoRemoteDataSource;

  Future<void> start() async {
    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      if (_hasConnection(results)) {
        unawaited(syncAll());
      }
    });

    final currentStatus = await _connectivity.checkConnectivity();
    if (_hasConnection(currentStatus)) {
      await syncAll();
    }
  }

  Future<void> stop() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await Future.wait([_syncNotes(), _syncJournal(), _syncTodos()]);
    } catch (error) {
      log('Sync failed', error: error);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncNotes() async {
    final localNotes = await _notesLocalDataSource
        .getAllNotesIncludingDeleted();
    final remoteNotes = await _notesRemoteDataSource.getNotes();
    final remoteById = {for (final note in remoteNotes) note.id: note};

    for (final local in localNotes) {
      if (local.isDeleted) {
        await _notesRemoteDataSource.deleteNote(local.id);
        await _notesLocalDataSource.permanentlyDeleteNote(local.id);
        continue;
      }

      final remote = remoteById[local.id];
      if (remote == null || local.updatedAt.isAfter(remote.updatedAt)) {
        final synced = await _notesRemoteDataSource.uploadNote(local);
        await _notesLocalDataSource.upsertNote(synced.copyWith(isSynced: true));
      }
    }

    final refreshedLocal = await _notesLocalDataSource
        .getAllNotesIncludingDeleted();
    final refreshedLocalById = {
      for (final note in refreshedLocal) note.id: note,
    };

    for (final remote in remoteNotes) {
      final local = refreshedLocalById[remote.id];
      if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
        if (remote.isDeleted) {
          await _notesLocalDataSource.permanentlyDeleteNote(remote.id);
        } else {
          await _notesLocalDataSource.upsertNote(
            remote.copyWith(isSynced: true),
          );
        }
      }
    }
  }

  Future<void> _syncJournal() async {
    final localEntries = await _journalLocalDataSource
        .getAllEntriesIncludingDeleted();
    final remoteEntries = await _journalRemoteDataSource.getEntries();
    final remoteById = {for (final entry in remoteEntries) entry.id: entry};

    for (final local in localEntries) {
      if (local.isDeleted) {
        await _journalRemoteDataSource.deleteEntry(local.id);
        await _journalLocalDataSource.permanentlyDeleteEntry(local.id);
        continue;
      }

      final remote = remoteById[local.id];
      if (remote == null || local.updatedAt.isAfter(remote.updatedAt)) {
        await _journalRemoteDataSource.uploadEntry(local);
        await _journalLocalDataSource.upsertEntry(
          local.copyWith(isSynced: true),
        );
      }
    }

    await _mergeRemoteJournal(remoteEntries);
  }

  Future<void> _mergeRemoteJournal(
    List<JournalEntryModel> remoteEntries,
  ) async {
    final refreshedLocal = await _journalLocalDataSource
        .getAllEntriesIncludingDeleted();
    final localById = {for (final entry in refreshedLocal) entry.id: entry};

    for (final remote in remoteEntries) {
      final local = localById[remote.id];
      if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
        if (remote.isDeleted) {
          await _journalLocalDataSource.permanentlyDeleteEntry(remote.id);
        } else {
          await _journalLocalDataSource.upsertEntry(
            remote.copyWith(isSynced: true),
          );
        }
      }
    }
  }

  Future<void> _syncTodos() async {
    final localTasks = await _todoLocalDataSource.getAllTasksIncludingDeleted();
    final remoteTasks = await _todoRemoteDataSource.getTasks();
    final remoteById = {for (final task in remoteTasks) task.id: task};

    for (final local in localTasks) {
      if (local.isDeleted) {
        await _todoRemoteDataSource.deleteTask(local.id);
        await _todoLocalDataSource.permanentlyDeleteTask(local.id);
        continue;
      }

      final remote = remoteById[local.id];
      if (remote == null || local.updatedAt.isAfter(remote.updatedAt)) {
        await _todoRemoteDataSource.uploadTask(local);
        await _todoLocalDataSource.upsertTask(local.copyWith(isSynced: true));
      }
    }

    await _mergeRemoteTodos(remoteTasks);
  }

  Future<void> _mergeRemoteTodos(List<TodoTaskModel> remoteTasks) async {
    final refreshedLocal = await _todoLocalDataSource
        .getAllTasksIncludingDeleted();
    final localById = {for (final task in refreshedLocal) task.id: task};

    for (final remote in remoteTasks) {
      final local = localById[remote.id];
      if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
        if (remote.isDeleted) {
          await _todoLocalDataSource.permanentlyDeleteTask(remote.id);
        } else {
          await _todoLocalDataSource.upsertTask(
            remote.copyWith(isSynced: true),
          );
        }
      }
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
