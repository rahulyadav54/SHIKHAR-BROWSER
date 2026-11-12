import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_item.dart';
import '../services/history_service.dart';

class HistoryState {
  final List<HistoryItem> items;
  final List<HistoryItem> recentSites;
  final bool isLoading;

  const HistoryState({
    required this.items,
    required this.recentSites,
    this.isLoading = false,
  });

  HistoryState copyWith({
    List<HistoryItem>? items,
    List<HistoryItem>? recentSites,
    bool? isLoading,
  }) {
    return HistoryState(
      items: items ?? this.items,
      recentSites: recentSites ?? this.recentSites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryService _service;

  HistoryNotifier({HistoryService? service})
      : _service = service ?? HistoryService(),
        super(const HistoryState(items: [], recentSites: [], isLoading: true)) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);
    final history = await _service.getHistory();
    final recent = await _service.getRecentSites(limit: 8);
    state = state.copyWith(items: history, recentSites: recent, isLoading: false);
  }

  Future<void> deleteItem(String id) async {
    await _service.deleteHistory(id);
    state = state.copyWith(
      items: state.items.where((h) => h.id != id).toList(),
      recentSites: state.recentSites.where((h) => h.id != id).toList(),
    );
  }

  Future<void> clearAll() async {
    await _service.clearHistory();
    state = state.copyWith(items: [], recentSites: []);
  }

  Future<void> clearDateRange(DateTime start, DateTime end) async {
    await _service.clearHistoryRange(start, end);
    await loadHistory();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadHistory();
      return;
    }
    state = state.copyWith(isLoading: true);
    final results = await _service.searchHistory(query);
    state = state.copyWith(items: results, isLoading: false);
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});

