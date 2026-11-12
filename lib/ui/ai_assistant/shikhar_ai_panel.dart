import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/branding/shikhar_logo.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../models/ai_message_item.dart';
import '../../state/ai_assistant_notifier.dart';
import '../../state/settings_notifier.dart';
import '../../state/tabs_notifier.dart';
import '../settings/settings_screen.dart';

class ShikharAiPanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const ShikharAiPanel({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<ShikharAiPanel> createState() => _ShikharAiPanelState();
}

class _ShikharAiPanelState extends ConsumerState<ShikharAiPanel> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _extractAndRun(Future<void> Function(String pageText, String url) action) async {
    final tabsState = ref.read(tabsProvider);
    final activeTab = tabsState.activeTab;
    final controller = tabsState.activeController;

    String pageContent = '';
    if (controller != null && !activeTab.isHome) {
      pageContent = await controller.extractPageText();
    }

    await action(pageContent, activeTab.url);
    _scrollToBottom();
  }

  void _onSend() {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;
    _promptController.clear();

    _extractAndRun((pageText, url) async {
      await ref.read(aiAssistantProvider.notifier).sendMessage(
        text,
        pageContent: pageText.isNotEmpty ? pageText : null,
        sourceUrl: url,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aiState = ref.watch(aiAssistantProvider);
    final settings = ref.watch(settingsProvider);

    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: isDark ? ShikharColors.darkSurface : Colors.white,
        border: Border(
          left: BorderSide(
            color: isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder,
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? ShikharColors.darkCard : const Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                const ShikharLogo(size: 28),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHIKHAR AI',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Smart Browsing Assistant',
                      style: TextStyle(fontSize: 11, color: ShikharColors.accent),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  tooltip: 'Clear Conversation',
                  onPressed: () {
                    ref.read(aiAssistantProvider.notifier).clearHistory();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Privacy Consent Banner (if not yet authorized)
          if (!settings.aiConsent)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: ShikharColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Privacy Consent Required',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ShikharColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'To assist with the current webpage, SHIKHAR AI needs your consent to process the active page text. No browsing history is shared.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ShikharColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        ref.read(settingsProvider.notifier).setAiConsent(true);
                        ref.read(aiAssistantProvider.notifier).grantConsent();
                      },
                      child: const Text('Authorize Page Analysis', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),

          // API Key Alert (if not set)
          if (!settings.hasApiKey)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.key_rounded, size: 16, color: Color(0xFFB45309)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'AI API Key not configured.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                    child: const Text('Add Key', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),

          // Quick Action Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.summarize_outlined, size: 14),
                    label: const Text('Summarize Page', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      _extractAndRun((pageText, url) async {
                        await ref.read(aiAssistantProvider.notifier).summarizePage(pageText, url);
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    avatar: const Icon(Icons.quiz_outlined, size: 14),
                    label: const Text('Generate FAQs', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      _extractAndRun((pageText, url) async {
                        await ref.read(aiAssistantProvider.notifier).generateFaqs(pageText, url);
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  ActionChip(
                    avatar: const Icon(Icons.lightbulb_outline, size: 14),
                    label: const Text('Explain Concepts', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      _promptController.text = 'Explain the main concepts of this page simply:';
                    },
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Conversation Messages
          Expanded(
            child: aiState.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 44,
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ask SHIKHAR AI anything',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Summarize articles, ask questions about web content, or translate text safely.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    itemCount: aiState.messages.length,
                    itemBuilder: (context, index) {
                      final msg = aiState.messages[index];
                      return _buildMessageBubble(context, msg, isDark);
                    },
                  ),
          ),

          if (aiState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('SHIKHAR AI is thinking...', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? ShikharColors.darkCard : const Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(
                  color: isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    onSubmitted: (_) => _onSend(),
                    maxLines: 3,
                    minLines: 1,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Ask about this page...',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      fillColor: isDark ? ShikharColors.darkSurface : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 16),
                  style: IconButton.styleFrom(
                    backgroundColor: ShikharColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: aiState.isLoading ? null : _onSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, AiMessageItem msg, bool isDark) {
    final isUser = msg.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? ShikharColors.primary
              : (msg.isError
                  ? const Color(0xFFFEF2F2)
                  : (isDark ? ShikharColors.darkCard : const Color(0xFFF1F5F9))),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: msg.isError
                ? const Color(0xFFFCA5A5)
                : (isUser ? Colors.transparent : (isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    msg.isError ? Icons.error_outline : Icons.auto_awesome,
                    size: 12,
                    color: msg.isError ? Colors.red : ShikharColors.accent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    msg.isError ? 'Error' : 'SHIKHAR AI',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: msg.isError ? Colors.red : ShikharColors.accent,
                    ),
                  ),
                ],
              ),
            if (!isUser) const SizedBox(height: 4),
            SelectableText(
              msg.content,
              style: TextStyle(
                fontSize: 13,
                color: isUser
                    ? Colors.white
                    : (msg.isError ? Colors.red.shade900 : (isDark ? Colors.white : Colors.black87)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
