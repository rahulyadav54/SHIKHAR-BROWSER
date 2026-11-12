import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/branding/shikhar_logo.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../state/ai_assistant_notifier.dart';
import '../../state/history_notifier.dart';
import '../../state/settings_notifier.dart';
import '../../state/tabs_notifier.dart';
import '../ai_assistant/shikhar_ai_panel.dart';
import 'theme_customizer_sheet.dart';

class QuickShortcutItem {
  final String id;
  final String title;
  final String url;
  final bool isCustom;

  const QuickShortcutItem({
    required this.id,
    required this.title,
    required this.url,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'isCustom': isCustom,
      };

  factory QuickShortcutItem.fromJson(Map<String, dynamic> json) {
    return QuickShortcutItem(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? 'Shortcut',
      url: json['url'] as String? ?? 'https://google.com',
      isCustom: json['isCustom'] as bool? ?? true,
    );
  }
}

class ShikharHomePage extends ConsumerStatefulWidget {
  final bool isPrivate;

  const ShikharHomePage({
    super.key,
    this.isPrivate = false,
  });

  @override
  ConsumerState<ShikharHomePage> createState() => _ShikharHomePageState();
}

class _ShikharHomePageState extends ConsumerState<ShikharHomePage> {
  final TextEditingController _searchController = TextEditingController();

  static const List<QuickShortcutItem> _builtinShortcuts = [
    QuickShortcutItem(id: 'google', title: 'Google', url: 'https://www.google.com'),
    QuickShortcutItem(id: 'youtube', title: 'YouTube', url: 'https://www.youtube.com'),
    QuickShortcutItem(id: 'wikipedia', title: 'Wikipedia', url: 'https://www.wikipedia.org'),
    QuickShortcutItem(id: 'github', title: 'GitHub', url: 'https://github.com'),
    QuickShortcutItem(id: 'reddit', title: 'Reddit', url: 'https://www.reddit.com'),
    QuickShortcutItem(id: 'flutter', title: 'Flutter', url: 'https://flutter.dev'),
    QuickShortcutItem(id: 'bbc', title: 'BBC News', url: 'https://www.bbc.com/news'),
    QuickShortcutItem(id: 'amazon', title: 'Amazon', url: 'https://www.amazon.com'),
  ];

  List<QuickShortcutItem> _shortcuts = [];

  @override
  void initState() {
    super.initState();
    _shortcuts = List.from(_builtinShortcuts);
    _loadCustomShortcuts();
  }

  Future<void> _loadCustomShortcuts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString('shikhar_quick_shortcuts');
      if (savedJson != null && savedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(savedJson);
        final loaded = decoded.map((e) => QuickShortcutItem.fromJson(e as Map<String, dynamic>)).toList();
        if (loaded.isNotEmpty && mounted) {
          setState(() {
            _shortcuts = loaded;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _saveShortcuts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_shortcuts.map((e) => e.toJson()).toList());
      await prefs.setString('shikhar_quick_shortcuts', encoded);
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _onSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    final settings = ref.read(settingsProvider);
    ref.read(tabsProvider.notifier).navigateActiveTab(
      query,
      searchTemplate: settings.searchEngine.searchUrlTemplate,
    );
  }

  void _showAddShortcutDialog([QuickShortcutItem? existingItem]) {
    final titleController = TextEditingController(text: existingItem?.title ?? '');
    final urlController = TextEditingController(text: existingItem?.url ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(existingItem == null ? 'Add Shortcut' : 'Edit Shortcut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. My Website',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'e.g. example.com',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final rawTitle = titleController.text.trim();
              String rawUrl = urlController.text.trim();
              if (rawUrl.isEmpty) return;

              if (!rawUrl.startsWith('http://') && !rawUrl.startsWith('https://')) {
                rawUrl = 'https://$rawUrl';
              }

              final title = rawTitle.isNotEmpty
                  ? rawTitle
                  : Uri.tryParse(rawUrl)?.host.replaceAll('www.', '') ?? 'Shortcut';

              setState(() {
                if (existingItem != null) {
                  final index = _shortcuts.indexWhere((e) => e.id == existingItem.id);
                  if (index != -1) {
                    _shortcuts[index] = QuickShortcutItem(
                      id: existingItem.id,
                      title: title,
                      url: rawUrl,
                      isCustom: true,
                    );
                  }
                } else {
                  _shortcuts.add(
                    QuickShortcutItem(
                      id: UniqueKey().toString(),
                      title: title,
                      url: rawUrl,
                      isCustom: true,
                    ),
                  );
                }
              });

              _saveShortcuts();
              Navigator.pop(ctx);
            },
            child: Text(existingItem == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showShortcutOptions(QuickShortcutItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new_rounded),
              title: const Text('Open in New Tab'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(tabsProvider.notifier).newTab(url: item.url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined, color: Color(0xFFA78BFA)),
              title: const Text('Open in Private Tab'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(tabsProvider.notifier).newTab(url: item.url, isPrivate: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Shortcut'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddShortcutDialog(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              title: const Text('Remove Shortcut', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _shortcuts.removeWhere((e) => e.id == item.id);
                });
                _saveShortcuts();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openAiPanel() {
    final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    if (isDesktop) {
      ref.read(aiAssistantProvider.notifier).open();
    } else {
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
  }

  void _openThemeCustomizer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ThemeCustomizerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final isPresetLight = settings.homeThemePreset == 'light';
    final effectiveIsDark = isPresetLight ? false : isDark;

    final historyState = ref.watch(historyProvider);
    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, MMMM d').format(now);
    final timeFormatted = DateFormat('h:mm a').format(now);

    return Scaffold(
      backgroundColor: widget.isPrivate
          ? ShikharColors.privateDarkBg
          : (effectiveIsDark ? ShikharColors.darkBackground : ShikharColors.lightBackground),
      floatingActionButton: widget.isPrivate
          ? null
          : FloatingActionButton.extended(
              onPressed: _openThemeCustomizer,
              icon: const Icon(Icons.palette_rounded, size: 18),
              label: const Text(
                'Customize Theme',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF101B35).withValues(alpha: 0.9),
              foregroundColor: const Color(0xFF26D9FF),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: const Color(0xFF26D9FF).withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
            ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: widget.isPrivate
            ? null
            : ThemeCustomizerSheet.getBackgroundDecoration(
                preset: settings.homeThemePreset,
                customWallpaperPath: settings.customWallpaperPath,
                isDark: effectiveIsDark,
              ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                // Fixed Private Mode Banner (Responsive with Flexible to prevent RenderFlex overflow)
                if (widget.isPrivate)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C1D95).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_rounded, size: 16, color: Color(0xFFA78BFA)),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Private Browsing • History & cookies are purged on exit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFDDD6FE),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Brand Emblem & Title
                ShikharLogo(
                  size: 72,
                  isDark: isDark,
                  showText: true,
                  isPrivate: widget.isPrivate,
                ),

                const SizedBox(height: 12),

                Text(
                  'YOUR WORLD. YOUR WEB.',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4.0,
                    color: widget.isPrivate
                        ? const Color(0xFFC4B5FD)
                        : (isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight),
                  ),
                ),

                const SizedBox(height: 24),

                // Greeting & Date
                Text(
                  '${_getGreeting()}, Explorer',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isPrivate
                        ? Colors.white
                        : (isDark ? ShikharColors.textPrimaryDark : ShikharColors.textPrimaryLight),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$dateFormatted  •  $timeFormatted',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                  ),
                ),

                const SizedBox(height: 28),

                // Central Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: widget.isPrivate
                        ? const Color(0xFF1F1D2B)
                        : (isDark ? ShikharColors.darkSurface : Colors.white),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: widget.isPrivate
                          ? const Color(0xFF6D28D9)
                          : (isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder),
                      width: 1.2,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _onSearchSubmit,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search the web or type a URL...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: widget.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.accent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: widget.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary,
                        ),
                        onPressed: () => _onSearchSubmit(_searchController.text),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Quick Website Shortcuts Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'QUICK ACCESS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showAddShortcutDialog(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: widget.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Add shortcut',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: widget.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // High-End Branded Quick Access Shortcuts Grid
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.start,
                  children: [
                    ..._shortcuts.map((item) => _buildShortcutTile(
                          item: item,
                          isDark: isDark,
                        )),
                    // Add Shortcut Tile (Desktop Style)
                    _buildAddShortcutTile(isDark),
                  ],
                ),

                const SizedBox(height: 32),

                // Recent Sites (if available)
                if (!widget.isPrivate && historyState.recentSites.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RECENTLY VISITED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: historyState.recentSites.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final site = historyState.recentSites[index];
                        return ActionChip(
                          avatar: const Icon(Icons.history_rounded, size: 16),
                          label: Text(
                            site.title.isNotEmpty ? site.title : site.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            ref.read(tabsProvider.notifier).navigateActiveTab(site.url);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // AI Assistant Quick Help Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [const Color(0xFFE0E7FF), const Color(0xFFF1F5F9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? ShikharColors.darkBorder : const Color(0xFFC7D2FE),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [ShikharColors.primary, ShikharColors.accent],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: ShikharColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SHIKHAR AI Assistant',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Summarize pages, ask questions, and translate text instantly while browsing.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: ShikharColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _openAiPanel,
                        child: const Text('Open AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildShortcutTile({
    required QuickShortcutItem item,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        ref.read(tabsProvider.notifier).navigateActiveTab(item.url);
      },
      onLongPress: () => _showShortcutOptions(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 82,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: widget.isPrivate
              ? const Color(0xFF1E162B)
              : (isDark ? ShikharColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isPrivate
                ? const Color(0xFF4C1D95).withValues(alpha: 0.5)
                : (isDark ? ShikharColors.darkBorder : const Color(0xFFE2E8F0)),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBrandBadge(item, isDark),
            const SizedBox(height: 8),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? ShikharColors.textPrimaryDark : ShikharColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandBadge(QuickShortcutItem item, bool isDark) {
    final lowerTitle = item.title.toLowerCase();
    final lowerUrl = item.url.toLowerCase();

    // YouTube: Red brand background with white play triangle
    if (lowerTitle.contains('youtube') || lowerUrl.contains('youtube.com')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF0000).withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
      );
    }

    // Google: Clean white badge with multicolor Google blue search
    if (lowerTitle.contains('google') || lowerUrl.contains('google.com')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF4285F4).withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4285F4).withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.search_rounded, color: Color(0xFF4285F4), size: 24),
      );
    }

    // GitHub: Deep slate/dark background with code icon
    if (lowerTitle.contains('github') || lowerUrl.contains('github.com')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF24292F),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.code_rounded, color: Colors.white, size: 22),
      );
    }

    // Wikipedia: W icon
    if (lowerTitle.contains('wikipedia') || lowerUrl.contains('wikipedia.org')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        alignment: Alignment.center,
        child: const Text(
          'W',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Reddit: Orange-red forum badge
    if (lowerTitle.contains('reddit') || lowerUrl.contains('reddit.com')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFF4500),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4500).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.forum_rounded, color: Colors.white, size: 22),
      );
    }

    // Flutter: Blue flutter icon
    if (lowerTitle.contains('flutter') || lowerUrl.contains('flutter.dev')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF02569B),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF02569B).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.flutter_dash_rounded, color: Colors.white, size: 24),
      );
    }

    // BBC: Deep red newspaper icon
    if (lowerTitle.contains('bbc') || lowerUrl.contains('bbc.com')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFBB1919),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBB1919).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.newspaper_rounded, color: Colors.white, size: 22),
      );
    }

    // Amazon: Dark navy with amber shopping cart
    if (lowerTitle.contains('amazon') || lowerUrl.contains('amazon.com')) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF232F3E),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFFFF9900), size: 22),
      );
    }

    // Custom Shortcut: Monogram with dynamic gradient
    final initial = item.title.isNotEmpty ? item.title[0].toUpperCase() : '★';
    final colors = [
      const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
      const [Color(0xFF10B981), Color(0xFF047857)],
      const [Color(0xFFF59E0B), Color(0xFFD97706)],
      const [Color(0xFFEC4899), Color(0xFFBE185D)],
    ];
    final colorPair = colors[item.title.hashCode.abs() % colors.length];

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colorPair),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorPair[0].withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddShortcutTile(bool isDark) {
    return InkWell(
      onTap: () => _showAddShortcutDialog(),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 82,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.black12,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add_rounded,
                size: 24,
                color: widget.isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
