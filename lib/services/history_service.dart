import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../core/database/app_database.dart';
import '../models/history_item.dart';

class HistoryService {
  final AppDatabase _dbHelper;
  static const _uuid = Uuid();

  HistoryService({AppDatabase? dbHelper}) : _dbHelper = dbHelper ?? AppDatabase.instance;

  Future<void> addHistory({
    required String title,
    required String url,
    bool isPrivate = false,
  }) async {
    // Privacy protection: Never record private browsing sessions in normal history
    if (isPrivate) return;

    // Do not record internal or blank URLs
    if (url.isEmpty || url == 'shikhar://home' || url == 'about:blank') return;

    final db = await _dbHelper.database;
    final item = HistoryItem(
      id: _uuid.v4(),
      title: title.isEmpty ? url : title,
      url: url,
      visitedAt: DateTime.now(),
    );

    // Delete immediate duplicate for clean history
    await db.delete('history', where: 'url = ?', whereArgs: [url]);
    await db.insert('history', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HistoryItem>> getHistory({int limit = 200}) async {
    final db = await _dbHelper.database;
    final maps = await db.query('history', orderBy: 'visited_at DESC', limit: limit);
    return maps.map((m) => HistoryItem.fromMap(m)).toList();
  }

  Future<List<HistoryItem>> getRecentSites({int limit = 8}) async {
    final db = await _dbHelper.database;
    final maps = await db.query('history', orderBy: 'visited_at DESC', limit: limit);
    return maps.map((m) => HistoryItem.fromMap(m)).toList();
  }

  Future<void> deleteHistory(String id) async {
    final db = await _dbHelper.database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearHistory() async {
    final db = await _dbHelper.database;
    await db.delete('history');
  }

  Future<void> clearHistoryRange(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    await db.delete(
      'history',
      where: 'visited_at >= ? AND visited_at <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );
  }

  Future<List<HistoryItem>> searchHistory(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'history',
      where: 'title LIKE ? OR url LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'visited_at DESC',
      limit: 100,
    );
    return maps.map((m) => HistoryItem.fromMap(m)).toList();
  }
}

