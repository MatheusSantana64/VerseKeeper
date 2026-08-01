import 'package:flutter/material.dart';

/// Centralized [ThemeData] for the app.
///
/// Material 3, seeded from a single color so the palette stays consistent
/// across light and dark mode.
abstract final class AppTheme {
  static const Color _seedColor = Color(0xFF4F46E5);

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
    );
  }
}
