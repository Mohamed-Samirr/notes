# Daily Notes & Journal - Code Explanation

This document explains the key concepts and code structure of the application.

## Table of Contents
1. [Project Setup](#project-setup)
2. [Clean Architecture Overview](#clean-architecture-overview)
3. [BLoC Pattern Implementation](#bloc-pattern-implementation)
4. [Feature Implementation](#feature-implementation)
5. [UI Components](#ui-components)
6. [Data Persistence](#data-persistence)

---

## Project Setup

### Dependencies Installed

```yaml
# State Management
flutter_bloc: ^8.1.3      # BLoC pattern implementation
equatable: ^2.0.5         # Value equality for entities and states

# Local Storage
hive: ^2.2.3              # NoSQL local database
hive_flutter: ^1.1.0      # Flutter integration for Hive
path_provider: ^2.1.1     # Access device file system paths

# Utilities
intl: ^0.19.0             # Date formatting and internationalization
image_picker: ^1.0.4      # Pick images from gallery/camera

# Dev Dependencies
hive_generator: ^2.0.1    # Generate Hive type adapters
build_runner: ^2.4.6      # Code generation
```

### Running Build Runner

To generate Hive type adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates `.g.dart` files for each model with `@HiveType` annotation.

---

## Clean Architecture Overview

### Three-Layer Structure

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  (UI, Widgets, BLoC, States, Events)    │
└─────────────────────────────────────────┘
              ↓ Uses ↓
┌─────────────────────────────────────────┐
│          DOMAIN LAYER                   │
│  (Entities, Use Cases, Repositories)    │
└─────────────────────────────────────────┘
              ↓ Uses ↓
┌─────────────────────────────────────────┐
│           DATA LAYER                    │
│  (Models, Data Sources, Repo Impl)      │
└─────────────────────────────────────────┘
```

### Layer Responsibilities

**Presentation Layer:**
- Handles UI and user interactions
- Uses BLoC for state management
- Contains screens and reusable widgets
- Depends on Domain layer only

**Domain Layer:**
- Contains business logic (use cases)
- Defines entities (pure Dart objects)
- Defines repository interfaces
- Independent of frameworks

**Data Layer:**
- Implements repositories
- Handles data sources (Hive, API, etc.)
- Contains data models with type adapters
- Maps models to/from entities

---

## BLoC Pattern Implementation

### BLoC Structure

Each feature has:
1. **Bloc** - Business logic coordinator
2. **Events** - User actions or triggers
3. **States** - UI representation states

### Example: Notes BLoC

#### Events (notes_event.dart)
```dart
abstract class NotesEvent extends Equatable {}

class LoadNotesEvent extends NotesEvent {}
class AddNoteEvent extends NotesEvent {
  final Note note;
}
class UpdateNoteEvent extends NotesEvent {
  final Note note;
}
class DeleteNoteEvent extends NotesEvent {
  final String noteId;
}
```

#### States (notes_state.dart)
```dart
abstract class NotesState extends Equatable {}

class NotesInitial extends NotesState {}
class NotesLoading extends NotesState {}
class NotesLoaded extends NotesState {
  final List<Note> notes;
}
class NotesError extends NotesState {
  final String message;
}
```

#### BLoC Logic (notes_bloc.dart)
```dart
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNotesUseCase getAllNotesUseCase;
  // ... other use cases
  
  NotesBloc({required this.getAllNotesUseCase, ...}) 
      : super(NotesInitial()) {
    on<LoadNotesEvent>(_onLoadNotes);
    // ... register other event handlers
  }
  
  Future<void> _onLoadNotes(
    LoadNotesEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    try {
      final notes = await getAllNotesUseCase();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}
```

### Using BLoC in UI

```dart
// 1. Provide BLoC at app level (main.dart)
BlocProvider(
  create: (context) => NotesBloc(...),
  child: MyApp(),
)

// 2. Dispatch events
context.read<NotesBloc>().add(LoadNotesEvent());

// 3. Listen to states
BlocBuilder<NotesBloc, NotesState>(
  builder: (context, state) {
    if (state is NotesLoading) {
      return CircularProgressIndicator();
    }
    if (state is NotesLoaded) {
      return ListView.builder(...);
    }
    return SizedBox.shrink();
  },
)
```

---

## Feature Implementation

### Notes Feature

**Flow:**
1. User opens Notes tab
2. `LoadNotesEvent` dispatched
3. BLoC calls `GetAllNotesUseCase`
4. Use case calls repository
5. Repository fetches from local data source (Hive)
6. Data flows back up as `NotesLoaded` state
7. UI rebuilds with notes list

**Key Files:**
- `note.dart` - Domain entity
- `note_model.dart` - Data model with Hive adapter
- `notes_usecases.dart` - Business logic
- `notes_bloc.dart` - State management
- `notes_screen.dart` - UI screen

### Journal Feature

**Unique Aspects:**
- One entry per day
- Date-based lookup
- Date navigation with date picker

**Key Logic:**
```dart
// Normalize date to day start for comparison
final normalizedDate = DateTime(date.year, date.month, date.day);
```

### ToDo Feature

**Unique Aspects:**
- Tasks grouped by completion status
- Toggle completion without full update
- Date-based filtering

**Sorting Logic:**
```dart
// Sort incomplete tasks first, then by creation date
taskModels.sort((a, b) {
  if (a.isCompleted != b.isCompleted) {
    return a.isCompleted ? 1 : -1;
  }
  return b.createdAt.compareTo(a.createdAt);
});
```

---

## UI Components

### Theme System

**Light and Dark Themes:**
- Custom color palette (Indigo/Purple)
- Material Design 3 components
- Persistent theme preference using Hive

**Theme Toggle:**
```dart
// Toggle theme
context.read<ThemeBloc>().add(ToggleThemeEvent());

// Theme automatically saves to Hive
final box = await Hive.openBox('settings_box');
await box.put('theme_mode', themeMode.index);
```

### Navigation

**Bottom Navigation Bar:**
```dart
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
    BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
    BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'To-Do'),
  ],
)
```

### Reusable Widgets

**NoteCard Widget:**
- Displays note with image, title, description, date
- Tap to edit
- Delete button with confirmation

**TodoItem Widget:**
- Checkbox for completion toggle
- Strikethrough text when completed
- Delete button

### Animations

```dart
AnimatedSwitcher(
  duration: AppConstants.shortAnimationDuration,
  child: _screens[_currentIndex],
)
```

---

## Data Persistence

### Hive Setup

**Initialization in main.dart:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(JournalEntryModelAdapter());
  Hive.registerAdapter(TodoTaskModelAdapter());
  
  runApp(MyApp());
}
```

### Hive Type Adapters

**Model Definition:**
```dart
@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  // ... other fields
}
```

**Generated Adapter:**
Build runner generates `NoteModelAdapter` with read/write methods.

### Data Operations

**Opening a Box:**
```dart
Future<Box<NoteModel>> _getBox() async {
  return await Hive.openBox<NoteModel>('notes_box');
}
```

**CRUD Operations:**
```dart
// Create/Update
await box.put(note.id, note);

// Read
final note = box.get(id);
final allNotes = box.values.toList();

// Delete
await box.delete(id);
```

### Entity-Model Mapping

**From Entity to Model:**
```dart
factory NoteModel.fromEntity(Note note) {
  return NoteModel(
    id: note.id,
    title: note.title,
    // ... map fields
  );
}
```

**From Model to Entity:**
```dart
Note toEntity() {
  return Note(
    id: id,
    title: title,
    // ... map fields
  );
}
```

---

## Best Practices Used

### 1. **Separation of Concerns**
Each layer has a single responsibility and doesn't know about implementation details of other layers.

### 2. **Dependency Inversion**
High-level modules (domain) don't depend on low-level modules (data). Both depend on abstractions (repository interfaces).

### 3. **Single Responsibility Principle**
Each use case handles one specific business operation.

### 4. **Immutability**
Entities and states are immutable using `const` constructors and `copyWith` methods.

### 5. **Type Safety**
Using Equatable for value comparison and proper typing throughout.

### 6. **Error Handling**
Try-catch blocks in BLoCs with error states for UI feedback.

### 7. **Code Comments**
Clear comments explaining purpose and functionality.

### 8. **Null Safety**
Full null-safe Dart code with proper null handling.

---

## Running the App

### Development
```bash
flutter run
```

### Build for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Testing BLoCs
```dart
blocTest<NotesBloc, NotesState>(
  'emits [NotesLoading, NotesLoaded] when LoadNotesEvent is added',
  build: () => NotesBloc(...),
  act: (bloc) => bloc.add(LoadNotesEvent()),
  expect: () => [NotesLoading(), NotesLoaded(notes: [])],
);
```

---

## Extending the App

### Adding a New Feature

1. **Create Feature Folder Structure:**
```
lib/features/new_feature/
  ├── data/
  │   ├── datasources/
  │   ├── models/
  │   └── repositories/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/
  │   └── usecases/
  └── presentation/
      ├── bloc/
      ├── screens/
      └── widgets/
```

2. **Define Entity** (domain layer)
3. **Create Repository Interface** (domain layer)
4. **Create Use Cases** (domain layer)
5. **Create Model with Hive Adapter** (data layer)
6. **Implement Repository** (data layer)
7. **Create BLoC** (presentation layer)
8. **Build UI** (presentation layer)
9. **Register in main.dart**

---

## Summary

This app demonstrates:
- ✅ **Clean Architecture** with clear layer separation
- ✅ **BLoC Pattern** for predictable state management
- ✅ **SOLID Principles** throughout the codebase
- ✅ **Local Data Persistence** with Hive
- ✅ **Modern UI/UX** with Material Design 3
- ✅ **Null Safety** and type safety
- ✅ **Scalable Structure** for easy feature addition

The architecture makes the app:
- **Testable** - Each layer can be tested independently
- **Maintainable** - Clear code organization
- **Scalable** - Easy to add new features
- **Flexible** - Can swap data sources or UI frameworks

---

**Happy Coding! 🚀**
