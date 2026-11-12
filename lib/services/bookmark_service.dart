import 'package:sqflite/sqflite.dart';
import '../core/database/app_database.dart';
import '../models/bookmark_item.dart';

class BookmarkService {
  final AppDatabase _dbHelper;

  BookmarkService({AppDatabase? dbHelper}) : _dbHelper = dbHelper ?? AppDatabase.instance;

  Future<List<BookmarkItem>> getBookmarks() async {
    final db = await _dbHelper.database;
    final maps = await db.query('bookmarks', orderBy: 'created_at DESC');
    return maps.map((m) => BookmarkItem.fromMap(m)).toList();
  }

  Future<void> addBookmark(BookmarkItem item) async {
    final db = await _dbHelper.database;
    await db.insert('bookmarks', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeBookmark(String id) async {
    final db = await _dbHelper.database;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeBookmarkByUrl(String url) async {
    final db = await _dbHelper.database;
    await db.delete('bookmarks', where: 'url = ?', whereArgs: [url]);
  }

  Future<void> updateBookmark(BookmarkItem item) async {
    final db = await _dbHelper.database;
    await db.update('bookmarks', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<bool> isBookmarked(String url) async {
    final db = await _dbHelper.database;
    final results = await db.query('bookmarks', where: 'url = ?', whereArgs: [url], limit: 1);
    return results.isNotEmpty;
  }

  Future<List<BookmarkItem>> searchBookmarks(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'bookmarks',
      where: 'title LIKE ? OR url LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) => BookmarkItem.fromMap(m)).toList();
  }
}

