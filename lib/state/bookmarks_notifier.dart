import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/network/url_utils.dart';
import '../models/bookmark_item.dart';
import '../services/bookmark_service.dart';

class BookmarksState {
  final List<BookmarkItem> items;
  final bool isLoading;

  const BookmarksState({
    required this.items,
    this.isLoading = false,
  });

  bool isBookmarked(String url) {
    return items.any((b) => b.url == url);
  }

  BookmarksState copyWith({
    List<BookmarkItem>? items,
    bool? isLoading,
  }) {
    return BookmarksState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BookmarksNotifier extends StateNotifier<BookmarksState> {
  final BookmarkService _service;
  static const _uuid = Uuid();

  BookmarksNotifier({BookmarkService? service})
      : _service = service ?? BookmarkService(),
        super(const BookmarksState(items: [], isLoading: true)) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true);
    final items = await _service.getBookmarks();
    state = state.copyWith(items: items, isLoading: false);
  }

  Future<void> toggleBookmark({required String title, required String url}) async {
    if (url.isEmpty || UrlUtils.isHome(url)) return;

    final existing = state.items.where((b) => b.url == url).toList();
    if (existing.isNotEmpty) {
      await _service.removeBookmark(existing.first.id);
      state = state.copyWith(
        items: state.items.where((b) => b.url != url).toList(),
      );
    } else {
      final newItem = BookmarkItem(
        id: _uuid.v4(),
        title: title.isEmpty ? url : title,
        url: url,
        favicon: UrlUtils.getFaviconUrl(url),
      );
      await _service.addBookmark(newItem);
      state = state.copyWith(items: [newItem, ...state.items]);
    }
  }

  Future<void> deleteBookmark(String id) async {
    await _service.removeBookmark(id);
    state = state.copyWith(
      items: state.items.where((b) => b.id != id).toList(),
    );
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadBookmarks();
      return;
    }
    state = state.copyWith(isLoading: true);
    final results = await _service.searchBookmarks(query);
    state = state.copyWith(items: results, isLoading: false);
  }
}

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, BookmarksState>((ref) {
  return BookmarksNotifier();
});

