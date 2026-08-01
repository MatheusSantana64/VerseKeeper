import 'package:flutter/material.dart';

import '../shared/themes/app_theme.dart';
import 'features/home/home_screen.dart';

/// Root widget of the application.
///
/// Kept intentionally small and Flutter-only: application bootstrap
/// (Firebase init, DI container) lives in `main.dart`, and routing/state
/// providers are added as those features land.
class VerseKeeperApp extends StatelessWidget {
  const VerseKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerseKeeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
