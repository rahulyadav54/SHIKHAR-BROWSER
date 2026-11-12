import 'package:flutter_test/flutter_test.dart';
import 'package:shikhar_browser/core/network/search_engines.dart';
import 'package:shikhar_browser/core/network/url_utils.dart';
import 'package:shikhar_browser/models/bookmark_item.dart';
import 'package:shikhar_browser/models/download_item.dart';
import 'package:shikhar_browser/models/history_item.dart';
import 'package:shikhar_browser/models/tab_item.dart';

void main() {
  group('URL & Search Detection Tests', () {
    test('Identifies standard web domains and prepends https', () {
      expect(UrlUtils.formatInput('google.com'), equals('https://google.com'));
      expect(UrlUtils.formatInput('en.wikipedia.org/wiki/Flutter'), equals('https://en.wikipedia.org/wiki/Flutter'));
      expect(UrlUtils.formatInput('github.com/flutter/flutter'), equals('https://github.com/flutter/flutter'));
    });

    test('Preserves explicit http and https schemes', () {
      expect(UrlUtils.formatInput('http://example.com'), equals('http://example.com'));
      expect(UrlUtils.formatInput('https://flutter.dev'), equals('https://flutter.dev'));
    });

    test('Handles localhost and local IP addresses', () {
      expect(UrlUtils.formatInput('localhost:3000'), equals('https://localhost:3000'));
      expect(UrlUtils.formatInput('127.0.0.1:8080'), equals('https://127.0.0.1:8080'));
    });

    test('Converts search queries to engine search URL', () {
      const searchTemplate = 'https://www.google.com/search?q={q}';
      expect(
        UrlUtils.formatInput('flutter programming tutorial', searchTemplate: searchTemplate),
        equals('https://www.google.com/search?q=flutter+programming+tutorial'),
      );
    });

    test('Correctly identifies secure HTTPS connections', () {
      expect(UrlUtils.isSecure('https://shikhar.org'), isTrue);
      expect(UrlUtils.isSecure('http://insecure-site.com'), isFalse);
      expect(UrlUtils.isSecure('shikhar://home'), isFalse);
    });

    test('Extracts readable domain correctly', () {
      expect(UrlUtils.extractDomain('https://en.wikipedia.org/wiki/Dart'), equals('en.wikipedia.org'));
      expect(UrlUtils.extractDomain('shikhar://home'), equals('SHIKHAR Home'));
    });
  });

  group('Search Engine Registry Tests', () {
    test('Default search engines contain Google, Bing, DuckDuckGo, Brave', () {
      final names = SearchEngine.defaults.map((e) => e.name).toList();
      expect(names, containsAll(['Google', 'Bing', 'DuckDuckGo', 'Brave Search']));
    });

    test('Builds search URL correctly for Google and DuckDuckGo', () {
      final google = SearchEngine.defaults.firstWhere((e) => e.id == 'google');
      expect(google.buildSearchUrl('SHIKHAR Browser'), equals('https://www.google.com/search?q=SHIKHAR+Browser'));

      final ddg = SearchEngine.defaults.firstWhere((e) => e.id == 'duckduckgo');
      expect(ddg.buildSearchUrl('open source web'), equals('https://duckduckgo.com/?q=open+source+web'));
    });
  });

  group('Model Serialization & Isolation Tests', () {
    test('BookmarkItem serializes to and from map correctly', () {
      final now = DateTime.now();
      final item = BookmarkItem(
        id: 'bm-1',
        title: 'Flutter Documentation',
        url: 'https://docs.flutter.dev',
        createdAt: now,
      );

      final map = item.toMap();
      final fromMap = BookmarkItem.fromMap(map);

      expect(fromMap.id, equals('bm-1'));
      expect(fromMap.title, equals('Flutter Documentation'));
      expect(fromMap.url, equals('https://docs.flutter.dev'));
      expect(fromMap.createdAt.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
    });

    test('HistoryItem serializes to and from map correctly', () {
      final now = DateTime.now();
      final item = HistoryItem(
        id: 'hist-1',
        title: 'Wikipedia',
        url: 'https://wikipedia.org',
        visitedAt: now,
      );

      final map = item.toMap();
      final fromMap = HistoryItem.fromMap(map);

      expect(fromMap.id, equals('hist-1'));
      expect(fromMap.url, equals('https://wikipedia.org'));
      expect(fromMap.visitedAt.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
    });

    test('DownloadItem status transitions and progress calculation', () {
      final download = DownloadItem(
        id: 'dl-1',
        filename: 'setup.exe',
        url: 'https://example.com/setup.exe',
        filePath: 'C:\\Downloads\\setup.exe',
        status: DownloadStatus.downloading,
        progress: 0.5,
      );

      final completed = download.copyWith(
        status: DownloadStatus.completed,
        progress: 1.0,
      );

      expect(completed.status, equals(DownloadStatus.completed));
      expect(completed.progress, equals(1.0));
    });

    test('TabItem private mode flag isolation', () {
      final normalTab = TabItem(id: 'tab-1', url: 'https://google.com', isPrivate: false);
      final privateTab = TabItem(id: 'tab-2', url: 'https://google.com', isPrivate: true);

      expect(normalTab.isPrivate, isFalse);
      expect(privateTab.isPrivate, isTrue);
    });
  });
}

