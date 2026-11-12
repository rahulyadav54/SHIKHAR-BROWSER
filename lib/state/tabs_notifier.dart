import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/network/url_utils.dart';
import '../models/tab_item.dart';
import '../services/download_service.dart';
import '../services/history_service.dart';
import '../services/webview/browser_controller.dart';

class TabsState {
  final List<TabItem> tabs;
  final String activeTabId;
  final Map<String, BrowserController> controllers;

  const TabsState({
    required this.tabs,
    required this.activeTabId,
    required this.controllers,
  });

  TabItem get activeTab {
    return tabs.firstWhere(
      (t) => t.id == activeTabId,
      orElse: () => tabs.isNotEmpty
          ? tabs.first
          : TabItem(id: 'default', title: 'New Tab', url: 'shikhar://home'),
    );
  }

  List<TabItem> get normalTabs => tabs.where((t) => !t.isPrivate).toList();
  List<TabItem> get privateTabs => tabs.where((t) => t.isPrivate).toList();

  BrowserController? get activeController => controllers[activeTabId];

  TabsState copyWith({
    List<TabItem>? tabs,
    String? activeTabId,
    Map<String, BrowserController>? controllers,
  }) {
    return TabsState(
      tabs: tabs ?? this.tabs,
      activeTabId: activeTabId ?? this.activeTabId,
      controllers: controllers ?? this.controllers,
    );
  }
}

class TabsNotifier extends StateNotifier<TabsState> {
  final HistoryService _historyService;
  final DownloadService _downloadService;
  static const _uuid = Uuid();

  TabsNotifier({HistoryService? historyService, DownloadService? downloadService})
      : _historyService = historyService ?? HistoryService(),
        _downloadService = downloadService ?? DownloadService(),
        super(const TabsState(tabs: [], activeTabId: '', controllers: {})) {
    // Open initial tab
    newTab();
  }

  Future<void> newTab({
    String url = 'shikhar://home',
    bool isPrivate = false,
  }) async {
    final tabId = _uuid.v4();
    final newTabItem = TabItem(
      id: tabId,
      url: url,
      title: isPrivate ? 'Private Tab' : 'New Tab',
      isPrivate: isPrivate,
      isSecure: UrlUtils.isSecure(url),
    );

    final controller = BrowserController.create(tabId: tabId, isPrivate: isPrivate);

    final updatedTabs = [...state.tabs, newTabItem];
    final updatedControllers = Map<String, BrowserController>.from(state.controllers);
    updatedControllers[tabId] = controller;

    state = state.copyWith(
      tabs: updatedTabs,
      activeTabId: tabId,
      controllers: updatedControllers,
    );

    // Initialize controller lifecycle
    await controller.initialize(
      initialUrl: url,
      onTitleChanged: (title) => _onTitleChanged(tabId, title),
      onUrlChanged: (newUrl) => _onUrlChanged(tabId, newUrl),
      onProgressChanged: (progress) => _onProgressChanged(tabId, progress),
      onLoadingChanged: (isLoading) => _onLoadingChanged(tabId, isLoading),
      onError: (error) => _onError(tabId, error),
      onDownloadRequested: (downloadUrl, filename) {
        _downloadService.startDownload(url: downloadUrl, customFilename: filename);
      },
    );
  }

  void switchTab(String tabId) {
    if (state.tabs.any((t) => t.id == tabId)) {
      state = state.copyWith(activeTabId: tabId);
    }
  }

  Future<void> closeTab(String tabId) async {
    final index = state.tabs.indexWhere((t) => t.id == tabId);
    if (index == -1) return;

    final controller = state.controllers[tabId];
    if (controller != null) {
      if (controller.isPrivate) {
        await controller.clearSessionData();
      }
      controller.dispose();
    }

    final updatedTabs = state.tabs.where((t) => t.id != tabId).toList();
    final updatedControllers = Map<String, BrowserController>.from(state.controllers);
    updatedControllers.remove(tabId);

    if (updatedTabs.isEmpty) {
      state = state.copyWith(tabs: [], activeTabId: '', controllers: updatedControllers);
      await newTab();
      return;
    }

    String nextActiveId = state.activeTabId;
    if (state.activeTabId == tabId) {
      final nextIndex = (index - 1).clamp(0, updatedTabs.length - 1);
      nextActiveId = updatedTabs[nextIndex].id;
    }

    state = state.copyWith(
      tabs: updatedTabs,
      activeTabId: nextActiveId,
      controllers: updatedControllers,
    );
  }

  Future<void> closeAllPrivateTabs() async {
    final privateIds = state.tabs.where((t) => t.isPrivate).map((t) => t.id).toList();
    for (final id in privateIds) {
      final controller = state.controllers[id];
      if (controller != null) {
        await controller.clearSessionData();
        controller.dispose();
      }
    }

    final updatedTabs = state.tabs.where((t) => !t.isPrivate).toList();
    final updatedControllers = Map<String, BrowserController>.from(state.controllers)
      ..removeWhere((key, value) => privateIds.contains(key));

    if (updatedTabs.isEmpty) {
      state = state.copyWith(tabs: [], activeTabId: '', controllers: updatedControllers);
      await newTab();
      return;
    }

    String nextActiveId = state.activeTabId;
    if (privateIds.contains(state.activeTabId)) {
      nextActiveId = updatedTabs.last.id;
    }

    state = state.copyWith(
      tabs: updatedTabs,
      activeTabId: nextActiveId,
      controllers: updatedControllers,
    );
  }

  void duplicateTab(String tabId) {
    final tab = state.tabs.firstWhere((t) => t.id == tabId);
    newTab(url: tab.url, isPrivate: tab.isPrivate);
  }

  Future<void> navigateActiveTab(String input, {String searchTemplate = 'https://www.google.com/search?q={q}'}) async {
    final formattedUrl = UrlUtils.formatInput(input, searchTemplate: searchTemplate);
    final activeId = state.activeTabId;
    final controller = state.controllers[activeId];

    _updateTab(activeId, (t) => t.copyWith(
      url: formattedUrl,
      isLoading: true,
      loadingProgress: 0.1,
      isSecure: UrlUtils.isSecure(formattedUrl),
      faviconUrl: UrlUtils.getFaviconUrl(formattedUrl),
    ));

    if (controller != null) {
      await controller.loadUrl(formattedUrl);
    }
  }

  Future<void> reloadActiveTab() async {
    final controller = state.activeController;
    if (controller != null) {
      await controller.reload();
    }
  }

  Future<void> stopActiveTabLoading() async {
    final controller = state.activeController;
    if (controller != null) {
      await controller.stopLoading();
    }
  }

  Future<void> goBackActiveTab() async {
    final controller = state.activeController;
    if (controller != null) {
      await controller.goBack();
    }
  }

  Future<void> goForwardActiveTab() async {
    final controller = state.activeController;
    if (controller != null) {
      await controller.goForward();
    }
  }

  void goHomeActiveTab() {
    navigateActiveTab('shikhar://home');
  }

  void _onTitleChanged(String tabId, String title) {
    _updateTab(tabId, (t) {
      // Record in history if not private and not home
      if (!t.isPrivate && !t.isHome && t.url.isNotEmpty) {
        _historyService.addHistory(title: title, url: t.url, isPrivate: false);
      }
      return t.copyWith(title: title);
    });
  }

  void _onUrlChanged(String tabId, String url) {
    _updateTab(tabId, (t) => t.copyWith(
      url: url,
      isSecure: UrlUtils.isSecure(url),
      faviconUrl: UrlUtils.getFaviconUrl(url),
    ));
  }

  void _onProgressChanged(String tabId, double progress) {
    _updateTab(tabId, (t) => t.copyWith(loadingProgress: progress));
  }

  void _onLoadingChanged(String tabId, bool isLoading) {
    _updateTab(tabId, (t) => t.copyWith(
      isLoading: isLoading,
      loadingProgress: isLoading ? t.loadingProgress : 1.0,
    ));
  }

  void _onError(String tabId, String error) {
    _updateTab(tabId, (t) => t.copyWith(isLoading: false));
  }

  void _updateTab(String tabId, TabItem Function(TabItem) updater) {
    state = state.copyWith(
      tabs: state.tabs.map((tab) => tab.id == tabId ? updater(tab) : tab).toList(),
    );
  }

  @override
  void dispose() {
    for (final controller in state.controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

final tabsProvider = StateNotifierProvider<TabsNotifier, TabsState>((ref) {
  return TabsNotifier();
});

