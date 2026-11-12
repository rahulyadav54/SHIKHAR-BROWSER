import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/download_item.dart';
import '../services/download_service.dart';

class DownloadsState {
  final List<DownloadItem> items;
  final bool isLoading;

  const DownloadsState({
    required this.items,
    this.isLoading = false,
  });

  DownloadsState copyWith({
    List<DownloadItem>? items,
    bool? isLoading,
  }) {
    return DownloadsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DownloadsNotifier extends StateNotifier<DownloadsState> {
  final DownloadService _service;
  StreamSubscription<DownloadItem>? _subscription;

  DownloadsNotifier({DownloadService? service})
      : _service = service ?? DownloadService(),
        super(const DownloadsState(items: [], isLoading: true)) {
    loadDownloads();
    _subscription = _service.onDownloadUpdate.listen((updatedItem) {
      _handleDownloadUpdate(updatedItem);
    });
  }

  Future<void> loadDownloads() async {
    state = state.copyWith(isLoading: true);
    final items = await _service.getDownloads();
    state = state.copyWith(items: items, isLoading: false);
  }

  Future<void> startDownload(String url, {String? customFilename}) async {
    await _service.startDownload(url: url, customFilename: customFilename);
  }

  void cancel(String id) {
    _service.cancelDownload(id);
  }

  Future<void> retry(DownloadItem item) async {
    await _service.retryDownload(item);
  }

  Future<void> deleteRecord(String id, {bool deleteFileFromDisk = false}) async {
    await _service.deleteDownloadRecord(id, deleteFileFromDisk: deleteFileFromDisk);
    state = state.copyWith(
      items: state.items.where((d) => d.id != id).toList(),
    );
  }

  Future<void> openFile(String filePath) async {
    await _service.openFile(filePath);
  }

  Future<void> openFolder(String filePath) async {
    await _service.openDownloadFolder(filePath);
  }

  void _handleDownloadUpdate(DownloadItem updatedItem) {
    final index = state.items.indexWhere((i) => i.id == updatedItem.id);
    if (index != -1) {
      final updatedList = List<DownloadItem>.from(state.items);
      updatedList[index] = updatedItem;
      state = state.copyWith(items: updatedList);
    } else {
      state = state.copyWith(items: [updatedItem, ...state.items]);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final downloadsProvider = StateNotifierProvider<DownloadsNotifier, DownloadsState>((ref) {
  return DownloadsNotifier();
});

