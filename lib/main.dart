import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'features/common/presentation/screens/home_screen.dart';
import 'features/notes/data/datasources/notes_local_data_source.dart';
import 'features/notes/data/models/note_model.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/usecases/notes_usecases.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';
import 'features/journal/data/datasources/journal_local_data_source.dart';
import 'features/journal/data/models/journal_entry_model.dart';
import 'features/journal/data/repositories/journal_repository_impl.dart';
import 'features/journal/domain/usecases/journal_usecases.dart';
import 'features/journal/presentation/bloc/journal_bloc.dart';
import 'features/todo/data/datasources/todo_local_data_source.dart';
import 'features/todo/data/models/todo_task_model.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/usecases/todo_usecases.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(JournalEntryModelAdapter());
  Hive.registerAdapter(TodoTaskModelAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme BLoC
        BlocProvider(
          create: (context) => ThemeBloc()..add(const LoadThemeEvent()),
        ),
        
        // Notes BLoC
        BlocProvider(
          create: (context) {
            final dataSource = NotesLocalDataSource();
            final repository = NotesRepositoryImpl(dataSource);
            return NotesBloc(
              getAllNotesUseCase: GetAllNotesUseCase(repository),
              addNoteUseCase: AddNoteUseCase(repository),
              updateNoteUseCase: UpdateNoteUseCase(repository),
              deleteNoteUseCase: DeleteNoteUseCase(repository),
            );
          },
        ),
        
        // Journal BLoC
        BlocProvider(
          create: (context) {
            final dataSource = JournalLocalDataSource();
            final repository = JournalRepositoryImpl(dataSource);
            return JournalBloc(
              getAllEntriesUseCase: GetAllEntriesUseCase(repository),
              getEntryByDateUseCase: GetEntryByDateUseCase(repository),
              saveJournalEntryUseCase: SaveJournalEntryUseCase(repository),
              deleteJournalEntryUseCase: DeleteJournalEntryUseCase(repository),
            );
          },
        ),
        
        // ToDo BLoC
        BlocProvider(
          create: (context) {
            final dataSource = TodoLocalDataSource();
            final repository = TodoRepositoryImpl(dataSource);
            return TodoBloc(
              getAllTasksUseCase: GetAllTasksUseCase(repository),
              getTasksByDateUseCase: GetTasksByDateUseCase(repository),
              addTaskUseCase: AddTaskUseCase(repository),
              updateTaskUseCase: UpdateTaskUseCase(repository),
              deleteTaskUseCase: DeleteTaskUseCase(repository),
              toggleTaskCompletionUseCase: ToggleTaskCompletionUseCase(repository),
            );
          },
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
