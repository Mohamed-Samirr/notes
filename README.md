# Daily Notes & Journal

A beautiful and minimalistic Flutter application for managing daily notes, journal entries, and to-do tasks with Clean Architecture and BLoC state management.

## Features

### 📝 Notes
- Create, edit, and delete notes
- Add optional images to notes
- Sort by most recent
- Clean card-based UI

### 📖 Journal
- One journal entry per day
- Date picker to navigate between days
- Auto-save functionality
- View all past entries

### ✅ To-Do List
- Daily task management
- Add, complete, and delete tasks
- Date navigation
- Checkbox state persistence
- Separate completed/incomplete sections

### 🎨 Theme
- Light and Dark mode
- Smooth theme transitions
- Modern Material Design 3
- Persistent theme preference

## Architecture

This project follows **Clean Architecture** principles with three distinct layers:

```
lib/
├── core/                          # Core utilities and configurations
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   └── theme/
│       ├── app_theme.dart         # Theme definitions
│       ├── theme_bloc.dart        # Theme state management
│       ├── theme_event.dart       # Theme events
│       └── theme_state.dart       # Theme states
│
├── features/                      # Feature modules
│   ├── common/                    # Shared UI components
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart  # Main navigation screen
│   │
│   ├── notes/                     # Notes feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── notes_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── note_model.dart
│   │   │   │   └── note_model.g.dart (generated)
│   │   │   └── repositories/
│   │   │       └── notes_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── note.dart
│   │   │   ├── repositories/
│   │   │   │   └── notes_repository.dart
│   │   │   └── usecases/
│   │   │       └── notes_usecases.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── notes_bloc.dart
│   │       │   ├── notes_event.dart
│   │       │   └── notes_state.dart
│   │       ├── screens/
│   │       │   ├── notes_screen.dart
│   │       │   └── add_edit_note_screen.dart
│   │       └── widgets/
│   │           └── note_card.dart
│   │
│   ├── journal/                   # Journal feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── journal_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── journal_entry_model.dart
│   │   │   │   └── journal_entry_model.g.dart (generated)
│   │   │   └── repositories/
│   │   │       └── journal_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── journal_entry.dart
│   │   │   ├── repositories/
│   │   │   │   └── journal_repository.dart
│   │   │   └── usecases/
│   │   │       └── journal_usecases.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── journal_bloc.dart
│   │       │   ├── journal_event.dart
│   │       │   └── journal_state.dart
│   │       └── screens/
│   │           └── journal_screen.dart
│   │
│   └── todo/                      # To-Do feature
│       ├── data/
│       │   ├── datasources/
│       │   │   └── todo_local_data_source.dart
│       │   ├── models/
│       │   │   ├── todo_task_model.dart
│       │   │   └── todo_task_model.g.dart (generated)
│       │   └── repositories/
│       │       └── todo_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── todo_task.dart
│       │   ├── repositories/
│       │   │   └── todo_repository.dart
│       │   └── usecases/
│       │       └── todo_usecases.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── todo_bloc.dart
│           │   ├── todo_event.dart
│           │   └── todo_state.dart
│           ├── screens/
│           │   └── todo_screen.dart
│           └── widgets/
│               └── todo_item.dart
│
└── main.dart                      # App entry point
```

## Layer Responsibilities

### 📦 Data Layer
- **Models**: Data classes with Hive type adapters for persistence
- **Data Sources**: Hive box operations for local storage
- **Repository Implementations**: Concrete implementations of domain repositories

### 🎯 Domain Layer
- **Entities**: Pure business objects (immutable, with Equatable)
- **Repositories**: Abstract contracts for data operations
- **Use Cases**: Single-responsibility business logic

### 🎨 Presentation Layer
- **BLoC**: State management with Events, States, and Business Logic
- **Screens**: Full-page UI components
- **Widgets**: Reusable UI components

## State Management - BLoC Pattern

### Notes BLoC
**Events:**
- `LoadNotesEvent` - Load all notes
- `AddNoteEvent` - Add a new note
- `UpdateNoteEvent` - Update existing note
- `DeleteNoteEvent` - Delete a note

**States:**
- `NotesInitial` - Initial state
- `NotesLoading` - Loading data
- `NotesLoaded` - Data loaded successfully
- `NotesError` - Error occurred

### Journal BLoC
**Events:**
- `LoadAllEntriesEvent` - Load all journal entries
- `LoadEntryByDateEvent` - Load entry for specific date
- `SaveJournalEntryEvent` - Save/update journal entry
- `DeleteJournalEntryEvent` - Delete entry

**States:**
- `JournalInitial` - Initial state
- `JournalLoading` - Loading data
- `JournalEntriesLoaded` - All entries loaded
- `JournalEntryLoaded` - Single entry loaded
- `JournalError` - Error occurred

### ToDo BLoC
**Events:**
- `LoadAllTasksEvent` - Load all tasks
- `LoadTasksByDateEvent` - Load tasks for specific date
- `AddTaskEvent` - Add a new task
- `UpdateTaskEvent` - Update existing task
- `DeleteTaskEvent` - Delete a task
- `ToggleTaskCompletionEvent` - Toggle task completion status

**States:**
- `TodoInitial` - Initial state
- `TodoLoading` - Loading data
- `TodoLoaded` - Tasks loaded
- `TodoError` - Error occurred

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3       # State management
  equatable: ^2.0.5          # Value equality
  hive: ^2.2.3               # Local database
  hive_flutter: ^1.1.0       # Hive Flutter integration
  path_provider: ^2.1.1      # File system paths
  intl: ^0.19.0              # Internationalization
  image_picker: ^1.0.4       # Image selection

dev_dependencies:
  hive_generator: ^2.0.1     # Hive code generation
  build_runner: ^2.4.6       # Code generation runner
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd notes
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Data Persistence

The app uses **Hive** for local data storage with three separate boxes:
- `notes_box` - Stores all notes
- `journal_box` - Stores journal entries
- `todo_box` - Stores to-do tasks
- `settings_box` - Stores app settings (theme preference)

All data is stored locally on the device and persists between app sessions.

## UI/UX Highlights

- **Material Design 3** with custom color schemes
- **Smooth animations** using AnimatedSwitcher
- **Bottom Navigation** for easy tab switching
- **Date pickers** for journal and to-do features
- **Image support** for notes
- **Empty states** with helpful messages
- **Confirmation dialogs** for destructive actions
- **Responsive design** that works on all screen sizes

## Code Quality

- ✅ Null-safe Dart code
- ✅ Clean Architecture separation
- ✅ SOLID principles
- ✅ Well-commented code
- ✅ Reusable widgets
- ✅ Type-safe BLoC pattern
- ✅ Proper error handling

## Future Enhancements

Possible improvements for the future:
- [ ] Search functionality for notes
- [ ] Categories/tags for notes
- [ ] Export/backup functionality
- [ ] Reminders for to-do tasks
- [ ] Rich text editor for journal
- [ ] Biometric authentication

## Firebase Sync

Hive remains the primary local database. Firebase is used only for cloud sync and backup, so the app continues to work normally when the user is offline or Firebase sync fails.

### Setup

1. Create a Firebase project.
2. Enable Anonymous Authentication in Firebase Auth.
3. Enable Cloud Firestore.

5. Configure the Flutter app with FlutterFire:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
flutter pub get
```

Firebase initializes in `lib/main.dart`. Authentication is isolated in `lib/core/auth/auth_service.dart`, and features do not access `FirebaseAuth` directly.

### Firestore Structure

```text
users
  uid
    notes
      noteId
    journal
      entryId
    todos
      taskId
```



### Sync Strategy

- Save every create, update, and delete to Hive first.
- Mark new and edited records as `isSynced = false`.
- Use soft deletes with `isDeleted = true` before cloud deletion.
- Try Firebase upload/delete after the local write.
- Mark records as `isSynced = true` after successful cloud sync.
- Keep local data unchanged when sync fails.
- Listen for connectivity changes in `lib/core/services/sync_service.dart`.
- Resolve conflicts with `updatedAt`; the newest version wins.
- Keep note images offline using `localImagePath` only.

## License

This project is open source and available under the MIT License.

## Author

Built with ❤️ using Flutter and Clean Architecture

---

**Happy Coding! 🚀**
