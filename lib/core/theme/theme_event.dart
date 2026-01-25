part of 'theme_bloc.dart';

/// Base class for theme events
abstract class ThemeEvent {
  const ThemeEvent();
}

/// Event to load the saved theme from storage
class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}

/// Event to toggle between light and dark theme
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}
