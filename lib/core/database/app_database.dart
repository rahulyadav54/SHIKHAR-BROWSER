import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../network/search_engines.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal();

  static Database? _database;
  static const String _dbFileName = 'shikhar_browser.db';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Cross-platform SQLite factory initialization
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, _dbFileName);

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Bookmarks Table
    await db.execute('''
      CREATE TABLE bookmarks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        folder_id TEXT,
        favicon TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_bookmarks_url ON bookmarks(url)');

    // History Table
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        url TEXT NOT NULL,
        visited_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_history_visited_at ON history(visited_at DESC)');
    await db.execute('CREATE INDEX idx_history_url ON history(url)');

    // Downloads Table
    await db.execute('''
      CREATE TABLE downloads (
        id TEXT PRIMARY KEY,
        filename TEXT NOT NULL,
        url TEXT NOT NULL,
        file_path TEXT NOT NULL,
        status TEXT NOT NULL,
        progress REAL NOT NULL DEFAULT 0.0,
        created_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_downloads_created_at ON downloads(created_at DESC)');

    // Settings Table
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_settings_key ON settings(key)');

    // Search Engines Table
    await db.execute('''
      CREATE TABLE search_engines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        search_url TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // AI Preferences Table
    await db.execute('''
      CREATE TABLE ai_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        enabled INTEGER NOT NULL DEFAULT 1,
        provider TEXT NOT NULL DEFAULT 'gemini',
        model TEXT NOT NULL DEFAULT 'gemini-1.5-flash',
        consent_status INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // AI Conversation History Table (local only)
    await db.execute('''
      CREATE TABLE ai_history (
        id TEXT PRIMARY KEY,
        role TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        source_url TEXT,
        is_error INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Seed default search engines
    for (final se in SearchEngine.defaults) {
      await db.insert('search_engines', se.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Seed default settings
    final defaultSettings = {
      'homepage': 'shikhar://home',
      'theme_mode': 'system',
      'search_engine': 'google',
      'javascript_enabled': 'true',
      'block_popups': 'true',
      'restore_tabs': 'false',
      'do_not_track': 'true',
      'ask_download_location': 'false',
    };

    for (final entry in defaultSettings.entries) {
      await db.insert('settings', {'key': entry.key, 'value': entry.value});
    }

    // Seed default AI preferences
    await db.insert('ai_preferences', {
      'enabled': 1,
      'provider': 'gemini',
      'model': 'gemini-1.5-flash',
      'consent_status': 0,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future schema migrations
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
