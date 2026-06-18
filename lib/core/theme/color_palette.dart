import 'package:flutter/material.dart';

/// Color palette for notes and journal entries
class ColorPalette {
  // Beautiful pastel colors that work well with dark theme
  static const List<Color> colors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
  ];

  /// Get color by index (rotates through the palette)
  static Color getColor(int index) {
    return colors[index % colors.length];
  }

  /// Get color by ID (uses character sum for consistent colors)
  static Color getColorById(String id, {String prefix = ''}) {
    // Use sum of character codes for better distribution
    String fullId = prefix + id;
    int sum = 0;
    for (int i = 0; i < fullId.length; i++) {
      sum +=
          fullId.codeUnitAt(i) *
          (i + 1); // Multiply by position for more variety
    }
    return colors[sum.abs() % colors.length];
  }
}
