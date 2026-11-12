import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_message_item.dart';
import '../services/ai_service.dart';

class AiAssistantState {
  final bool isOpen;
  final bool isLoading;
  final List<AiMessageItem> messages;
  final String? activeUrl;

  const AiAssistantState({
    this.isOpen = false,
    this.isLoading = false,
    this.messages = const [],
    this.activeUrl,
  });

  AiAssistantState copyWith({
    bool? isOpen,
    bool? isLoading,
    List<AiMessageItem>? messages,
    String? activeUrl,
  }) {
    return AiAssistantState(
      isOpen: isOpen ?? this.isOpen,
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      activeUrl: activeUrl ?? this.activeUrl,
    );
  }
}

class AiAssistantNotifier extends StateNotifier<AiAssistantState> {
  final AiService _service;

  AiAssistantNotifier({AiService? service})
      : _service = service ?? AiService(),
        super(const AiAssistantState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final history = await _service.getLocalHistory();
    state = state.copyWith(messages: history);
  }

  void toggleOpen({String? currentUrl}) {
    state = state.copyWith(
      isOpen: !state.isOpen,
      activeUrl: currentUrl ?? state.activeUrl,
    );
  }

  void open({String? currentUrl}) {
    state = state.copyWith(
      isOpen: true,
      activeUrl: currentUrl ?? state.activeUrl,
    );
  }

  void close() {
    state = state.copyWith(isOpen: false);
  }

  Future<void> grantConsent() async {
    await _service.grantConsent();
  }

  Future<void> clearHistory() async {
    await _service.clearLocalHistory();
    state = state.copyWith(messages: []);
  }

  Future<void> sendMessage(String text, {String? pageContent, String? sourceUrl}) async {
    if (text.trim().isEmpty) return;

    state = state.copyWith(isLoading: true);

    String prompt = text;
    if (pageContent != null && pageContent.trim().isNotEmpty) {
      prompt = 'Context from webpage (${sourceUrl ?? "current"}):\n$pageContent\n\nUser Question:\n$text';
    }

    try {
      await _service.executePrompt(prompt: prompt, sourceUrl: sourceUrl);
      final history = await _service.getLocalHistory();
      state = state.copyWith(messages: history, isLoading: false);
    } catch (_) {
      final history = await _service.getLocalHistory();
      state = state.copyWith(messages: history, isLoading: false);
    }
  }

  Future<void> summarizePage(String pageContent, String url) async {
    if (pageContent.trim().isEmpty) {
      sendMessage('Please summarize this page, but note that the page body text could not be extracted directly.', sourceUrl: url);
      return;
    }
    final prompt = _service.buildSummarizePrompt(pageContent, url);
    await sendMessage(prompt, sourceUrl: url);
  }

  Future<void> explainParagraph(String paragraph, {String? sourceUrl}) async {
    final prompt = _service.buildExplainParagraphPrompt(paragraph);
    await sendMessage(prompt, sourceUrl: sourceUrl);
  }

  Future<void> generateFaqs(String pageContent, String url) async {
    final prompt = _service.buildFaqPrompt(pageContent);
    await sendMessage(prompt, sourceUrl: url);
  }

  Future<void> translate(String text, String targetLang, {String? sourceUrl}) async {
    final prompt = _service.buildTranslatePrompt(text, targetLang);
    await sendMessage(prompt, sourceUrl: sourceUrl);
  }
}

final aiAssistantProvider = StateNotifierProvider<AiAssistantNotifier, AiAssistantState>((ref) {
  return AiAssistantNotifier();
});
