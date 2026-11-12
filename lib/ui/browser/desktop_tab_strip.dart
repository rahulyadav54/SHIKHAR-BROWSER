import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/branding/shikhar_logo.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../models/tab_item.dart';
import '../../state/tabs_notifier.dart';

class DesktopTabStrip extends ConsumerWidget {
  final List<TabItem> tabs;
  final String activeTabId;

  const DesktopTabStrip({
    super.key,
    required this.tabs,
    required this.activeTabId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 40,
      color: isDark ? const Color(0xFF0D131F) : const Color(0xFFE2E8F0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          // Small SHIKHAR brand icon
          const ShikharLogo(size: 24),
          const SizedBox(width: 8),

          // Scrollable tab list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isActive = tab.id == activeTabId;

                return _buildTabItem(context, ref, tab, isActive, isDark);
              },
            ),
          ),

          // New Tab Button (+)
          Tooltip(
            message: 'New tab (Ctrl+T)',
            child: IconButton(
              icon: const Icon(Icons.add, size: 18),
              splashRadius: 18,
              onPressed: () {
                ref.read(tabsProvider.notifier).newTab();
              },
            ),
          ),

          // New Private Tab Button
          Tooltip(
            message: 'New private window (Ctrl+Shift+N)',
            child: IconButton(
              icon: const Icon(Icons.shield_outlined, size: 18, color: Color(0xFFA78BFA)),
              splashRadius: 18,
              onPressed: () {
                ref.read(tabsProvider.notifier).newTab(isPrivate: true);
              },
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    WidgetRef ref,
    TabItem tab,
    bool isActive,
    bool isDark,
  ) {
    final tabBgColor = isActive
        ? (tab.isPrivate
            ? ShikharColors.privateDarkBg
            : (isDark ? ShikharColors.darkSurface : ShikharColors.lightBackground))
        : Colors.transparent;

    return GestureDetector(
      onTap: () {
        ref.read(tabsProvider.notifier).switchTab(tab.id);
      },
      onSecondaryTapDown: (details) {
        _showTabContextMenu(context, ref, tab, details.globalPosition);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 190,
        height: 36,
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: tabBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: isActive
              ? Border(
                  top: BorderSide(
                    color: tab.isPrivate ? const Color(0xFF8B5CF6) : ShikharColors.primary,
                    width: 2.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            // Favicon or status icon
            if (tab.isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (tab.isPrivate)
              const Icon(Icons.shield_outlined, size: 14, color: Color(0xFFA78BFA))
            else if (tab.faviconUrl != null && tab.faviconUrl!.isNotEmpty)
              Image.network(
                tab.faviconUrl!,
                width: 14,
                height: 14,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.public, size: 14),
              )
            else
              const Icon(Icons.public, size: 14),

            const SizedBox(width: 8),

            // Tab Title
            Expanded(
              child: Text(
                tab.title.isEmpty ? (tab.isHome ? 'New Tab' : tab.url) : tab.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight),
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Close Tab (X)
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                ref.read(tabsProvider.notifier).closeTab(tab.id);
              },
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(Icons.close, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTabContextMenu(BuildContext context, WidgetRef ref, TabItem tab, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem(
          onTap: () => ref.read(tabsProvider.notifier).newTab(),
          child: const Row(
            children: [
              Icon(Icons.add, size: 18),
              SizedBox(width: 8),
              Text('New Tab'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => ref.read(tabsProvider.notifier).duplicateTab(tab.id),
          child: const Row(
            children: [
              Icon(Icons.content_copy, size: 18),
              SizedBox(width: 8),
              Text('Duplicate Tab'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => ref.read(tabsProvider.notifier).closeTab(tab.id),
          child: const Row(
            children: [
              Icon(Icons.close, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Close Tab', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
