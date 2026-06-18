import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// BLoC for managing app theme (Light/Dark mode)
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  /// Load saved theme from local storage
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final box = await Hive.openBox(AppConstants.settingsBox);
      final themeModeIndex =
          box.get(
                AppConstants.themeModeKey,
                defaultValue: ThemeMode.system.index,
              )
              as int;

      final themeMode = ThemeMode.values[themeModeIndex];
      emit(ThemeState(themeMode: themeMode));
    } catch (e) {
      // If error, default to system theme
      emit(const ThemeState(themeMode: ThemeMode.system));
    }
  }

  /// Toggle between light and dark theme
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final newThemeMode = state.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

      final box = await Hive.openBox(AppConstants.settingsBox);
      await box.put(AppConstants.themeModeKey, newThemeMode.index);

      emit(ThemeState(themeMode: newThemeMode));
    } catch (e) {
      // Keep current theme if error occurs
    }
  }
}
