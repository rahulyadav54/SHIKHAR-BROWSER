import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:video_player_win/video_player_win.dart';
import 'core/branding/brand_constants.dart';
import 'core/database/app_database.dart';
import 'core/theme/app_theme.dart';
import 'state/settings_notifier.dart';
import 'ui/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite FFI and VideoPlayer for Windows desktop
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  if (Platform.isWindows) {
    WindowsVideoPlayer.registerWith();
  }

  // Pre-initialize local database
  await AppDatabase.instance.database;

  runApp(
    const ProviderScope(
      child: ShikharBrowserApp(),
    ),
  );
}

class ShikharBrowserApp extends ConsumerWidget {
  const ShikharBrowserApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: BrandConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const SplashScreen(),
    );
  }
}
