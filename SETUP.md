# Quick Setup Guide - Daily Notes & Journal

## 📋 Prerequisites

Before you begin, ensure you have:
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code with Flutter extensions
- Git (optional, for version control)

## 🚀 Setup Steps

### 1. Navigate to Project Directory
```bash
cd "d:\Mohamed\DEPI\note app\notes"
```

### 2. Install Dependencies
```bash
flutter pub get
```

Expected output: "Got dependencies!"

### 3. Generate Hive Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/features/notes/data/models/note_model.g.dart`
- `lib/features/journal/data/models/journal_entry_model.g.dart`
- `lib/features/todo/data/models/todo_task_model.g.dart`

Expected output: "[INFO] Succeeded after X.Xs with Y outputs"

### 4. Run the App
```bash
flutter run
```

Or use VS Code/Android Studio's run button.

## 🎯 First Run

When you first run the app:
1. The app will initialize Hive database
2. Default theme will be system theme
3. All features will have empty states
4. You can immediately start adding:
   - Notes (with optional images)
   - Journal entries
   - To-do tasks

## 📱 Testing the Features

### Notes
1. Tap the + button
2. Enter title and description
3. Optionally add an image
4. Tap ✓ to save
5. Tap a note to edit
6. Swipe to delete (or tap trash icon)

### Journal
1. Select today's date (or any date)
2. Write your thoughts
3. Tap "Save Entry"
4. Navigate dates using calendar icon
5. View past entries

### To-Do
1. Type a task in the input field
2. Press Enter or tap +
3. Check box to mark complete
4. Use date picker to view tasks for different days
5. Delete tasks as needed

## 🎨 Theme Toggle

To toggle between light and dark mode:
- Add a settings icon in the app bar
- Or implement: `context.read<ThemeBloc>().add(ToggleThemeEvent())`

## 🛠️ Troubleshooting

### Build Runner Issues
If code generation fails:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Missing Packages
```bash
# Reinstall dependencies
flutter pub cache repair
flutter pub get
```

### Android Build Issues
```bash
# Clean Android build
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

### iOS Build Issues
```bash
# Clean iOS build
cd ios
pod install
cd ..
flutter clean
flutter run
```

## 📦 Project Structure Summary

```
lib/
├── main.dart                  # App entry point
├── core/                      # Core utilities
│   ├── constants/
│   └── theme/
└── features/                  # Feature modules
    ├── common/                # Shared components
    ├── notes/                 # Notes feature
    ├── journal/               # Journal feature
    └── todo/                  # To-Do feature
```

Each feature follows Clean Architecture:
- `data/` - Models, data sources, repositories
- `domain/` - Entities, use cases
- `presentation/` - BLoC, screens, widgets

## 🔧 Development Commands

```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Analyze code
flutter analyze

# Format code
dart format .

# Run tests (when added)
flutter test

# Check for outdated packages
flutter pub outdated
```

## 📚 Additional Resources

- **README.md** - Project overview and features
- **ARCHITECTURE.md** - Detailed code explanation
- **pubspec.yaml** - Dependencies and configuration

## ✅ Verification Checklist

Before considering setup complete:
- [ ] `flutter pub get` succeeds
- [ ] Build runner generates `.g.dart` files
- [ ] App runs without errors
- [ ] Can add a note
- [ ] Can write journal entry
- [ ] Can create to-do task
- [ ] Theme toggle works
- [ ] Data persists after app restart

## 🎉 You're Ready!

The app is now fully set up and ready for:
- Development
- Testing
- Customization
- Deployment

Enjoy building with Flutter! 🚀

---

For questions or issues, refer to:
- README.md for feature documentation
- ARCHITECTURE.md for code structure
- Flutter docs: https://flutter.dev/docs
