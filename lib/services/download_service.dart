import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../core/database/app_database.dart';
import '../models/download_item.dart';

class DownloadService {
  final AppDatabase _dbHelper;
  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};
  final StreamController<DownloadItem> _updateController = StreamController<DownloadItem>.broadcast();
  static const _uuid = Uuid();

  Stream<DownloadItem> get onDownloadUpdate => _updateController.stream;

  DownloadService({AppDatabase? dbHelper}) : _dbHelper = dbHelper ?? AppDatabase.instance;

  Future<String> getDefaultDownloadDirectory() async {
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null) {
        final winDownloads = p.join(userProfile, 'Downloads');
        if (await Directory(winDownloads).exists()) {
          return winDownloads;
        }
      }
    }

    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      return downloadsDir.path;
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final fallbackDir = Directory(p.join(appDocDir.path, 'SHIKHAR_Downloads'));
    if (!await fallbackDir.exists()) {
      await fallbackDir.create(recursive: true);
    }
    return fallbackDir.path;
  }

  /// Avoid overwriting by appending (1), (2), etc.
  Future<String> _resolveUniqueFilePath(String directory, String rawFilename) async {
    String cleanName = rawFilename.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    if (cleanName.isEmpty) cleanName = 'download_${DateTime.now().millisecondsSinceEpoch}';

    String filePath = p.join(directory, cleanName);
    if (!await File(filePath).exists()) {
      return filePath;
    }

    final nameWithoutExt = p.basenameWithoutExtension(cleanName);
    final ext = p.extension(cleanName);
    int counter = 1;

    while (await File(filePath).exists()) {
      filePath = p.join(directory, '$nameWithoutExt ($counter)$ext');
      counter++;
    }

    return filePath;
  }

  Future<List<DownloadItem>> getDownloads() async {
    final db = await _dbHelper.database;
    final maps = await db.query('downloads', orderBy: 'created_at DESC');
    return maps.map((m) => DownloadItem.fromMap(m)).toList();
  }

  Future<DownloadItem> startDownload({
    required String url,
    String? customFilename,
    String? targetDirectory,
  }) async {
    final db = await _dbHelper.database;
    final id = _uuid.v4();

    // Determine target directory
    final saveDir = targetDirectory ?? await getDefaultDownloadDirectory();
    final uri = Uri.parse(url);
    final rawName = customFilename ?? (uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'download');
    final finalFilePath = await _resolveUniqueFilePath(saveDir, rawName);
    final finalFilename = p.basename(finalFilePath);

    var item = DownloadItem(
      id: id,
      filename: finalFilename,
      url: url,
      filePath: finalFilePath,
      status: DownloadStatus.downloading,
      progress: 0.0,
      createdAt: DateTime.now(),
    );

    await db.insert('downloads', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    _updateController.add(item);

    final cancelToken = CancelToken();
    _cancelTokens[id] = cancelToken;

    // Begin download stream
    _executeDownload(item, cancelToken);

    return item;
  }

  void _executeDownload(DownloadItem item, CancelToken cancelToken) async {
    final db = await _dbHelper.database;
    try {
      final response = await _dio.download(
        item.url,
        item.filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = (received / total).clamp(0.0, 1.0);
            final updated = item.copyWith(
              progress: progress,
              totalBytes: total,
              receivedBytes: received,
              status: DownloadStatus.downloading,
            );
            _updateController.add(updated);
          }
        },
      );

      _cancelTokens.remove(item.id);

      // Verify file physically exists on disk before marking completed
      final file = File(item.filePath);
      if (response.statusCode == 200 && await file.exists() && await file.length() > 0) {
        final completed = item.copyWith(
          status: DownloadStatus.completed,
          progress: 1.0,
        );
        await db.update('downloads', completed.toMap(), where: 'id = ?', whereArgs: [item.id]);
        _updateController.add(completed);
      } else {
        throw Exception('Downloaded file was empty or missing');
      }
    } catch (e) {
      _cancelTokens.remove(item.id);
      if (cancelToken.isCancelled) {
        final cancelled = item.copyWith(status: DownloadStatus.cancelled);
        await db.update('downloads', cancelled.toMap(), where: 'id = ?', whereArgs: [item.id]);
        _updateController.add(cancelled);
      } else {
        final failed = item.copyWith(status: DownloadStatus.failed);
        await db.update('downloads', failed.toMap(), where: 'id = ?', whereArgs: [item.id]);
        _updateController.add(failed);
      }
    }
  }

  void cancelDownload(String id) {
    if (_cancelTokens.containsKey(id)) {
      _cancelTokens[id]?.cancel();
      _cancelTokens.remove(id);
    }
  }

  Future<void> retryDownload(DownloadItem item) async {
    cancelDownload(item.id);
    final cancelToken = CancelToken();
    _cancelTokens[item.id] = cancelToken;

    final updated = item.copyWith(status: DownloadStatus.downloading, progress: 0.0);
    final db = await _dbHelper.database;
    await db.update('downloads', updated.toMap(), where: 'id = ?', whereArgs: [item.id]);
    _updateController.add(updated);

    _executeDownload(updated, cancelToken);
  }

  Future<void> deleteDownloadRecord(String id, {bool deleteFileFromDisk = false}) async {
    final db = await _dbHelper.database;
    if (deleteFileFromDisk) {
      final results = await db.query('downloads', where: 'id = ?', whereArgs: [id]);
      if (results.isNotEmpty) {
        final path = results.first['file_path'] as String?;
        if (path != null) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    }
    await db.delete('downloads', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> openFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await OpenFilex.open(filePath);
    }
  }

  Future<void> openDownloadFolder(String filePath) async {
    final dir = Directory(p.dirname(filePath));
    if (await dir.exists()) {
      final uri = Uri.directory(dir.path);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  void dispose() {
    _updateController.close();
  }
}

