import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../models/tab_item.dart';
import '../../state/tabs_notifier.dart';

class MobileTabSwitcher extends ConsumerStatefulWidget {
  const MobileTabSwitcher({super.key});

  @override
  ConsumerState<MobileTabSwitcher> createState() => _MobileTabSwitcherState();
}

class _MobileTabSwitcherState extends ConsumerState<MobileTabSwitcher> {
  bool _isPrivateView = false;

  @override
  void initState() {
    super.initState();
    // Default to the mode of the currently active tab
    final activeTab = ref.read(tabsProvider).activeTab;
    _isPrivateView = activeTab.isPrivate;
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final normalTabs = tabsState.normalTabs;
    final privateTabs = tabsState.privateTabs;
    final currentList = _isPrivateView ? privateTabs : normalTabs;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: _isPrivateView
            ? const Color(0xFF0F0B18)
            : (isDark ? ShikharColors.darkBackground : const Color(0xFFF1F5F9)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Segmented Switcher & Action Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Segmented Toggle (Normal / Private)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Normal Tabs Tab
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => _isPrivateView = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: !_isPrivateView ? ShikharColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tab_rounded,
                                size: 16,
                                color: !_isPrivateView ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${normalTabs.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: !_isPrivateView ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Private Tabs Tab
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => _isPrivateView = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isPrivateView ? const Color(0xFF7C3AED) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                size: 16,
                                color: _isPrivateView ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${privateTabs.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: _isPrivateView ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Close All Private Tabs (if in private view and tabs exist)
                if (_isPrivateView && privateTabs.isNotEmpty)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF87171),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                    label: const Text('Close All', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      ref.read(tabsProvider.notifier).closeAllPrivateTabs();
                    },
                  ),

                // New Tab Button
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _isPrivateView ? const Color(0xFF7C3AED) : ShikharColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                  tooltip: _isPrivateView ? 'New Private Tab' : 'New Tab',
                  onPressed: () {
                    ref.read(tabsProvider.notifier).newTab(isPrivate: _isPrivateView);
                    Navigator.pop(context);
                  },
                ),

                // Close Switcher
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Tabs Grid or Empty State
          Expanded(
            child: currentList.isEmpty
                ? _buildEmptyState(_isPrivateView)
                : GridView.builder(
                    padding: const EdgeInsets.all(14),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      final tab = currentList[index];
                      final isActive = tab.id == tabsState.activeTabId;

                      return _buildTabCard(context, ref, tab, isActive, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isPrivate) {
    if (isPrivate) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.4)),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 42,
                  color: Color(0xFFA78BFA),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Private Tabs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Private tabs do not save history, cookies, or site credentials. Everything is purged when closed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Open Private Tab'),
                onPressed: () {
                  ref.read(tabsProvider.notifier).newTab(isPrivate: true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: Text('No open tabs'),
    );
  }

  Widget _buildTabCard(
    BuildContext context,
    WidgetRef ref,
    TabItem tab,
    bool isActive,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(tabsProvider.notifier).switchTab(tab.id);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: tab.isPrivate
              ? const Color(0xFF1E162D)
              : (isDark ? ShikharColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? (tab.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary)
                : (tab.isPrivate ? const Color(0xFF3B2E58) : (isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder)),
            width: isActive ? 2.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? (tab.isPrivate ? const Color(0xFF7C3AED).withValues(alpha: 0.3) : ShikharColors.primary.withValues(alpha: 0.2))
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Tab Header with icon, title, and close
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: tab.isPrivate
                    ? const Color(0xFF2A1F40)
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Icon(
                    tab.isPrivate ? Icons.shield_rounded : (tab.isHome ? Icons.home_rounded : Icons.public_rounded),
                    size: 14,
                    color: tab.isPrivate
                        ? const Color(0xFFA78BFA)
                        : (isActive ? ShikharColors.primary : (isDark ? Colors.white60 : Colors.black54)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tab.title.isEmpty ? (tab.isHome ? 'New Tab' : tab.url) : tab.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                        color: tab.isPrivate ? Colors.white : null,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ref.read(tabsProvider.notifier).closeTab(tab.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: tab.isPrivate ? Colors.white70 : (isDark ? Colors.white70 : Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Preview body
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: tab.isHome
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tab.isPrivate ? Icons.shield_outlined : Icons.explore_outlined,
                              size: 34,
                              color: tab.isPrivate
                                  ? const Color(0xFFA78BFA).withValues(alpha: 0.6)
                                  : ShikharColors.primary.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tab.isPrivate ? 'Private Home' : 'SHIKHAR Home',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.language_rounded,
                              size: 32,
                              color: tab.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.accent,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tab.title.isNotEmpty ? tab.title : tab.url,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: tab.isPrivate ? Colors.white70 : (isDark ? Colors.white70 : Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tab.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                color: tab.isPrivate ? Colors.white38 : (isDark ? Colors.white38 : Colors.black38),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
