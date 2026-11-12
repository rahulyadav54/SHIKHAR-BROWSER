import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../state/ai_assistant_notifier.dart';
import '../../state/bookmarks_notifier.dart';
import '../../state/tabs_notifier.dart';
import '../ai_assistant/shikhar_ai_panel.dart';
import '../bookmarks/bookmarks_dialog.dart';
import '../downloads/downloads_dialog.dart';
import '../history/history_dialog.dart';
import '../home/shikhar_home_page.dart';
import '../settings/settings_screen.dart';
import 'address_bar.dart';
import 'desktop_tab_strip.dart';
import 'mobile_tab_switcher.dart';

class BrowserScreen extends ConsumerStatefulWidget {
  const BrowserScreen({super.key});

  @override
  ConsumerState<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends ConsumerState<BrowserScreen> {
  final FocusNode _addressBarFocusNode = FocusNode();

  @override
  void dispose() {
    _addressBarFocusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;
    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;

    if (isCtrlPressed) {
      if (event.logicalKey == LogicalKeyboardKey.keyT) {
        ref.read(tabsProvider.notifier).newTab();
      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        final activeId = ref.read(tabsProvider).activeTabId;
        ref.read(tabsProvider.notifier).closeTab(activeId);
      } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
        _addressBarFocusNode.requestFocus();
      } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
        ref.read(tabsProvider.notifier).reloadActiveTab();
      } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
        final activeTab = ref.read(tabsProvider).activeTab;
        ref.read(bookmarksProvider.notifier).toggleBookmark(
          title: activeTab.title,
          url: activeTab.url,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.keyH) {
        _openHistoryDialog();
      } else if (event.logicalKey == LogicalKeyboardKey.keyJ) {
        _openDownloadsDialog();
      } else if (isShiftPressed && event.logicalKey == LogicalKeyboardKey.keyN) {
        ref.read(tabsProvider.notifier).newTab(isPrivate: true);
      }
    }
  }

  void _openBookmarksDialog() {
    showDialog(context: context, builder: (_) => const BookmarksDialog());
  }

  void _openHistoryDialog() {
    showDialog(context: context, builder: (_) => const HistoryDialog());
  }

  void _openDownloadsDialog() {
    showDialog(context: context, builder: (_) => const DownloadsDialog());
  }

  void _openSettingsScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  void _openMobileTabSwitcher() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MobileTabSwitcher(),
    );
  }

  void _openMobileAiAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.88,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: ShikharAiPanel(
            onClose: () => Navigator.pop(ctx),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final activeTab = tabsState.activeTab;
    final activeController = tabsState.activeController;
    final aiState = ref.watch(aiAssistantProvider);
    final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPrivate = activeTab.isPrivate;

    final headerBgColor = isPrivate
        ? (isDark ? const Color(0xFF140F20) : const Color(0xFF2E1065))
        : (isDark ? ShikharColors.darkSurface : Colors.white);

    final bottomBarBgColor = isPrivate
        ? (isDark ? const Color(0xFF140F20) : const Color(0xFF2E1065))
        : (isDark ? ShikharColors.darkSurface : Colors.white);

    final borderColor = isPrivate
        ? const Color(0xFF7C3AED).withValues(alpha: 0.3)
        : (isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder);

    final activeIndex = tabsState.tabs.indexWhere((t) => t.id == tabsState.activeTabId);
    final safeIndex = (activeIndex >= 0 && activeIndex < tabsState.tabs.length) ? activeIndex : 0;

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (activeController != null && await activeController.canGoBack()) {
            await activeController.goBack();
          }
        },
        child: Scaffold(
          backgroundColor: isDark ? ShikharColors.darkBackground : ShikharColors.lightBackground,
          body: SafeArea(
            child: Column(
              children: [
                // Windows Desktop Tab Strip
                if (isDesktop)
                  DesktopTabStrip(
                    tabs: tabsState.tabs,
                    activeTabId: tabsState.activeTabId,
                  ),

                // Browser Header / Navigation Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 8 : 12,
                    vertical: isDesktop ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: headerBgColor,
                    border: Border(
                      bottom: BorderSide(
                        color: borderColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: isDesktop
                      ? _buildDesktopHeader(activeTab, isDark, aiState)
                      : _buildMobileHeader(activeTab, isDark, isPrivate),
                ),

                // Loading Progress Bar
                if (activeTab.isLoading)
                  LinearProgressIndicator(
                    value: activeTab.loadingProgress > 0 ? activeTab.loadingProgress : null,
                    minHeight: 2.5,
                    backgroundColor: Colors.transparent,
                    color: isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary,
                  ),

                // Main Web Viewport (Preserved with IndexedStack so tabs never reload on switch)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: tabsState.tabs.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : IndexedStack(
                                index: safeIndex,
                                children: tabsState.tabs.map((tab) {
                                  if (tab.isHome) {
                                    return ShikharHomePage(isPrivate: tab.isPrivate);
                                  }
                                  final controller = tabsState.controllers[tab.id];
                                  if (controller != null) {
                                    return controller.buildView();
                                  }
                                  return const Center(child: CircularProgressIndicator());
                                }).toList(),
                              ),
                      ),

                      // Desktop AI Assistant Side Panel
                      if (isDesktop && aiState.isOpen)
                        ShikharAiPanel(
                          onClose: () => ref.read(aiAssistantProvider.notifier).close(),
                        ),
                    ],
                  ),
                ),

                // Mobile Bottom Navigation Toolbar
                if (!isDesktop)
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: bottomBarBgColor,
                      border: Border(
                        top: BorderSide(color: borderColor, width: 1.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Back Button
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 19,
                            color: isPrivate ? Colors.white70 : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          tooltip: 'Back',
                          onPressed: () => ref.read(tabsProvider.notifier).goBackActiveTab(),
                        ),

                        // Forward Button
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 19,
                            color: isPrivate ? Colors.white70 : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          tooltip: 'Forward',
                          onPressed: () => ref.read(tabsProvider.notifier).goForwardActiveTab(),
                        ),

                        // Center SHIKHAR AI Assistant Action
                        GestureDetector(
                          onTap: _openMobileAiAssistant,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isPrivate
                                    ? [const Color(0xFF7C3AED), const Color(0xFFA78BFA)]
                                    : [ShikharColors.primary, ShikharColors.accent],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (isPrivate ? const Color(0xFF7C3AED) : ShikharColors.accent)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Tab Switcher Button with count
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _openMobileTabSwitcher,
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isPrivate ? const Color(0xFF7C3AED).withValues(alpha: 0.25) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isPrivate
                                    ? const Color(0xFFA78BFA)
                                    : (isDark ? Colors.white70 : Colors.black87),
                                width: 1.8,
                              ),
                            ),
                            child: Text(
                              '${tabsState.tabs.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isPrivate ? const Color(0xFFA78BFA) : (isDark ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ),

                        // Menu Button
                        IconButton(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            size: 22,
                            color: isPrivate ? Colors.white70 : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          tooltip: 'Options',
                          onPressed: () => _openMobileMenu(context, isPrivate),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader(dynamic activeTab, bool isDark, dynamic aiState) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
          tooltip: 'Back (Alt+Left)',
          splashRadius: 18,
          onPressed: () => ref.read(tabsProvider.notifier).goBackActiveTab(),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_rounded, size: 20),
          tooltip: 'Forward (Alt+Right)',
          splashRadius: 18,
          onPressed: () => ref.read(tabsProvider.notifier).goForwardActiveTab(),
        ),
        IconButton(
          icon: Icon(
            activeTab.isLoading ? Icons.close_rounded : Icons.refresh_rounded,
            size: 20,
          ),
          tooltip: activeTab.isLoading ? 'Stop (Esc)' : 'Reload page (Ctrl+R / F5)',
          splashRadius: 18,
          onPressed: () {
            if (activeTab.isLoading) {
              ref.read(tabsProvider.notifier).stopActiveTabLoading();
            } else {
              ref.read(tabsProvider.notifier).reloadActiveTab();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.home_outlined, size: 20),
          tooltip: 'SHIKHAR Home',
          splashRadius: 18,
          onPressed: () => ref.read(tabsProvider.notifier).goHomeActiveTab(),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: AddressBar(
            activeTab: activeTab,
            focusNode: _addressBarFocusNode,
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          icon: const Icon(Icons.star_outline_rounded, size: 20),
          tooltip: 'Bookmarks (Ctrl+D)',
          splashRadius: 18,
          onPressed: _openBookmarksDialog,
        ),
        IconButton(
          icon: const Icon(Icons.history_rounded, size: 20),
          tooltip: 'History (Ctrl+H)',
          splashRadius: 18,
          onPressed: _openHistoryDialog,
        ),
        IconButton(
          icon: const Icon(Icons.download_rounded, size: 20),
          tooltip: 'Downloads (Ctrl+J)',
          splashRadius: 18,
          onPressed: _openDownloadsDialog,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: aiState.isOpen ? ShikharColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.auto_awesome,
              size: 19,
              color: aiState.isOpen
                  ? Colors.white
                  : (activeTab.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.accent),
            ),
            tooltip: 'SHIKHAR AI Assistant',
            splashRadius: 18,
            onPressed: () {
              ref.read(aiAssistantProvider.notifier).toggleOpen(currentUrl: activeTab.url);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, size: 20),
          tooltip: 'Settings',
          splashRadius: 18,
          onPressed: _openSettingsScreen,
        ),
      ],
    );
  }

  Widget _buildMobileHeader(dynamic activeTab, bool isDark, bool isPrivate) {
    return Row(
      children: [
        // Home Button
        IconButton(
          icon: Icon(
            Icons.home_rounded,
            size: 22,
            color: isPrivate ? const Color(0xFFA78BFA) : (isDark ? Colors.white70 : Colors.black87),
          ),
          tooltip: 'Home',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: () => ref.read(tabsProvider.notifier).goHomeActiveTab(),
        ),

        const SizedBox(width: 4),

        // Full-width Address & Search Bar
        Expanded(
          child: AddressBar(
            activeTab: activeTab,
            focusNode: _addressBarFocusNode,
          ),
        ),

        const SizedBox(width: 4),

        // New Tab Quick Action
        IconButton(
          icon: Icon(
            Icons.add_rounded,
            size: 24,
            color: isPrivate ? const Color(0xFFA78BFA) : (isDark ? Colors.white70 : Colors.black87),
          ),
          tooltip: isPrivate ? 'New Private Tab' : 'New Tab',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          onPressed: () {
            ref.read(tabsProvider.notifier).newTab(isPrivate: isPrivate);
          },
        ),
      ],
    );
  }

  void _openMobileMenu(BuildContext context, bool isPrivate) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'SHIKHAR Browser',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  if (isPrivate)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFA78BFA), width: 1),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_rounded, size: 12, color: Color(0xFFA78BFA)),
                          SizedBox(width: 4),
                          Text(
                            'PRIVATE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA78BFA),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.refresh_rounded),
              title: const Text('Reload Page'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(tabsProvider.notifier).reloadActiveTab();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('New Tab'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(tabsProvider.notifier).newTab(isPrivate: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined, color: Color(0xFFA78BFA)),
              title: const Text('New Private Tab'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(tabsProvider.notifier).newTab(isPrivate: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline_rounded),
              title: const Text('Bookmarks'),
              onTap: () {
                Navigator.pop(ctx);
                _openBookmarksDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(ctx);
                _openHistoryDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: const Text('Downloads'),
              onTap: () {
                Navigator.pop(ctx);
                _openDownloadsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(ctx);
                _openSettingsScreen();
              },
            ),
          ],
        ),
      ),
    );
  }
}
