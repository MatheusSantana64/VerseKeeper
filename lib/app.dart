import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/themes/app_theme.dart';
import 'features/router/app_router.dart';

/// Root widget of the application.
///
/// Kept intentionally small: application bootstrap (Firebase init) lives in
/// `main.dart`, routing in [goRouterProvider], feature screens under
/// `lib/features`.
class VerseKeeperApp extends ConsumerWidget {
  const VerseKeeperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'VerseKeeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
