import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import '../core/database/app_database.dart';
import '../core/network/search_engines.dart';

class SettingsService {
  final AppDatabase _dbHelper;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SettingsService({AppDatabase? dbHelper}) : _dbHelper = dbHelper ?? AppDatabase.instance;

  Future<Map<String, String>> getAllSettings() async {
    final db = await _dbHelper.database;
    final rows = await db.query('settings');
    final Map<String, String> result = {};
    for (final row in rows) {
      result[row['key'] as String] = row['value'] as String;
    }
    return result;
  }

  Future<String?> getSetting(String key, {String? defaultValue}) async {
    final db = await _dbHelper.database;
    final rows = await db.query('settings', where: 'key = ?', whereArgs: [key], limit: 1);
    if (rows.isNotEmpty) {
      return rows.first['value'] as String?;
    }
    return defaultValue;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await _dbHelper.database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SearchEngine>> getSearchEngines() async {
    final db = await _dbHelper.database;
    final rows = await db.query('search_engines');
    if (rows.isEmpty) return SearchEngine.defaults;
    return rows.map((r) => SearchEngine.fromMap(r)).toList();
  }

  Future<SearchEngine> getDefaultSearchEngine() async {
    final db = await _dbHelper.database;
    // Check settings table first
    final prefSetting = await getSetting('search_engine');
    if (prefSetting != null && prefSetting.isNotEmpty) {
      final rows = await db.query('search_engines', where: 'id = ?', whereArgs: [prefSetting], limit: 1);
      if (rows.isNotEmpty) {
        return SearchEngine.fromMap(rows.first);
      }
      final defaultMatch = SearchEngine.defaults.where((e) => e.id == prefSetting);
      if (defaultMatch.isNotEmpty) {
        return defaultMatch.first;
      }
    }

    final rows = await db.query('search_engines', where: 'is_default = 1', limit: 1);
    if (rows.isNotEmpty) {
      return SearchEngine.fromMap(rows.first);
    }
    return SearchEngine.defaults.first;
  }

  Future<void> setDefaultSearchEngine(String id) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.update('search_engines', {'is_default': 0});
      await txn.update('search_engines', {'is_default': 1}, where: 'id = ?', whereArgs: [id]);
    });
    // Persist explicitly to settings table as well
    await setSetting('search_engine', id);
  }

  // Secure storage for optional user API Key (never saved in plaintext database)
  Future<void> saveAiApiKey(String apiKey) async {
    await _secureStorage.write(key: 'shikhar_ai_api_key', value: apiKey);
  }

  Future<String?> getAiApiKey() async {
    return await _secureStorage.read(key: 'shikhar_ai_api_key');
  }

  Future<void> clearAiApiKey() async {
    await _secureStorage.delete(key: 'shikhar_ai_api_key');
  }

  // AI Preferences
  Future<Map<String, dynamic>> getAiPreferences() async {
    final db = await _dbHelper.database;
    final rows = await db.query('ai_preferences', limit: 1);
    if (rows.isNotEmpty) {
      return rows.first;
    }
    return {
      'enabled': 1,
      'provider': 'gemini',
      'model': 'gemini-1.5-flash',
      'consent_status': 0,
    };
  }

  Future<void> updateAiPreferences({
    bool? enabled,
    String? provider,
    String? model,
    bool? consentStatus,
  }) async {
    final db = await _dbHelper.database;
    final current = await getAiPreferences();
    final updateData = <String, dynamic>{
      'enabled': enabled != null ? (enabled ? 1 : 0) : current['enabled'],
      'provider': provider ?? current['provider'],
      'model': model ?? current['model'],
      'consent_status': consentStatus != null ? (consentStatus ? 1 : 0) : current['consent_status'],
    };
    await db.update('ai_preferences', updateData, where: 'id = ?', whereArgs: [current['id'] ?? 1]);
  }
}

