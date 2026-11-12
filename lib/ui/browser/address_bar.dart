import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../models/tab_item.dart';
import '../../state/bookmarks_notifier.dart';
import '../../state/settings_notifier.dart';
import '../../state/tabs_notifier.dart';

class AddressBar extends ConsumerStatefulWidget {
  final TabItem activeTab;
  final FocusNode focusNode;

  const AddressBar({
    super.key,
    required this.activeTab,
    required this.focusNode,
  });

  @override
  ConsumerState<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends ConsumerState<AddressBar> {
  late TextEditingController _textController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _getDisplayText());
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant AddressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.activeTab.url != widget.activeTab.url) {
      _textController.text = _getDisplayText();
    }
  }

  void _onFocusChange() {
    setState(() {
      _isEditing = widget.focusNode.hasFocus;
      if (_isEditing) {
        if (!widget.activeTab.isHome) {
          _textController.text = widget.activeTab.url;
          _textController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _textController.text.length,
          );
        } else {
          _textController.clear();
        }
      } else {
        _textController.text = _getDisplayText();
      }
    });
  }

  String _getDisplayText() {
    if (widget.activeTab.isHome) {
      return '';
    }
    return widget.activeTab.url;
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _textController.dispose();
    super.dispose();
  }

  void _onSubmit(String text) {
    final query = text.trim();
    if (query.isEmpty) return;
    widget.focusNode.unfocus();
    final settings = ref.read(settingsProvider);
    ref.read(tabsProvider.notifier).navigateActiveTab(
      query,
      searchTemplate: settings.searchEngine.searchUrlTemplate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarksState = ref.watch(bookmarksProvider);
    final isBookmarked = bookmarksState.isBookmarked(widget.activeTab.url);
    final isSecure = widget.activeTab.isSecure;
    final isHome = widget.activeTab.isHome;
    final isPrivate = widget.activeTab.isPrivate;

    final borderColor = widget.focusNode.hasFocus
        ? (isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary)
        : (isPrivate
            ? const Color(0xFF4C1D95).withValues(alpha: 0.5)
            : (isDark ? ShikharColors.darkBorder : const Color(0xFFD1D5DB)));

    final bgColor = isPrivate
        ? (isDark ? const Color(0xFF1E1528) : const Color(0xFFF3E8FF))
        : (isDark ? ShikharColors.darkSurface : const Color(0xFFF1F5F9));

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
          width: widget.focusNode.hasFocus ? 1.8 : 1.0,
        ),
        boxShadow: widget.focusNode.hasFocus
            ? [
                BoxShadow(
                  color: (isPrivate ? const Color(0xFF8B5CF6) : ShikharColors.primary)
                      .withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          // Security / Private / Search Icon
          if (isPrivate)
            Tooltip(
              message: 'Private browsing mode active',
              child: const Icon(
                Icons.shield_rounded,
                size: 18,
                color: Color(0xFFA78BFA),
              ),
            )
          else if (isHome)
            Icon(
              Icons.search_rounded,
              size: 20,
              color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
            )
          else if (isSecure)
            Tooltip(
              message: 'Connection is secure (HTTPS)',
              child: const Icon(Icons.lock_rounded, size: 16, color: ShikharColors.secureGreen),
            )
          else
            Tooltip(
              message: 'Connection is not secure (HTTP)',
              child: const Icon(Icons.warning_amber_rounded, size: 16, color: ShikharColors.warningOrange),
            ),

          const SizedBox(width: 8),

          // Address & Search Text Field
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: widget.focusNode,
              onSubmitted: _onSubmit,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.url,
              autocorrect: false,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: isPrivate
                    ? 'Search privately or type URL...'
                    : 'Search or type web address...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                fillColor: Colors.transparent,
              ),
            ),
          ),

          // Clear button if user has entered text
          if (_textController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.cancel_rounded, size: 18),
              splashRadius: 18,
              color: isDark ? Colors.white54 : Colors.black45,
              tooltip: 'Clear',
              onPressed: () {
                _textController.clear();
                setState(() {});
              },
            ),

          // Go button if editing
          if (_isEditing && _textController.text.trim().isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: isPrivate ? const Color(0xFFA78BFA) : ShikharColors.primary,
              ),
              splashRadius: 18,
              tooltip: 'Go',
              onPressed: () => _onSubmit(_textController.text),
            ),

          // Bookmark Star Icon (when not editing and not on home)
          if (!_isEditing && !isHome)
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.star_rounded : Icons.star_border_rounded,
                size: 20,
                color: isBookmarked ? Colors.amber : (isDark ? Colors.white70 : Colors.black54),
              ),
              splashRadius: 18,
              tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark page',
              onPressed: () {
                ref.read(bookmarksProvider.notifier).toggleBookmark(
                  title: widget.activeTab.title,
                  url: widget.activeTab.url,
                );
              },
            ),

          // Refresh / Stop Button (when not editing and not on home)
          if (!_isEditing && !isHome)
            IconButton(
              icon: Icon(
                widget.activeTab.isLoading ? Icons.close_rounded : Icons.refresh_rounded,
                size: 18,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              splashRadius: 18,
              tooltip: widget.activeTab.isLoading ? 'Stop loading' : 'Reload',
              onPressed: () {
                if (widget.activeTab.isLoading) {
                  ref.read(tabsProvider.notifier).stopActiveTabLoading();
                } else {
                  ref.read(tabsProvider.notifier).reloadActiveTab();
                }
              },
            ),

          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
