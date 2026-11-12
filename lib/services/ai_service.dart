import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../core/database/app_database.dart';
import '../models/ai_message_item.dart';
import 'settings_service.dart';

abstract class AiProvider {
  String get name;
  Future<String> generateResponse({
    required String prompt,
    required String? apiKey,
    required String model,
    String? proxyEndpoint,
    Duration timeout = const Duration(seconds: 20),
  });
}

class GeminiAiProvider implements AiProvider {
  @override
  String get name => 'gemini';

  @override
  Future<String> generateResponse({
    required String prompt,
    required String? apiKey,
    required String model,
    String? proxyEndpoint,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (apiKey == null || apiKey.trim().isEmpty) {
      throw Exception('AI API key is not configured. Please add your API key in Settings.');
    }

    final url = proxyEndpoint != null && proxyEndpoint.isNotEmpty
        ? Uri.parse(proxyEndpoint)
        : Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
          );

    final payload = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.3,
        'maxOutputTokens': 1500,
      }
    };

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final candidates = json['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content?['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'] as String;
        }
      }
      return 'No response generated from the model.';
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit exceeded. Please wait a few moments before sending another request.');
    } else {
      throw Exception('AI service request failed (Code: ${response.statusCode}): ${response.reasonPhrase}');
    }
  }
}

class CustomProxyAiProvider implements AiProvider {
  @override
  String get name => 'custom_proxy';

  @override
  Future<String> generateResponse({
    required String prompt,
    required String? apiKey,
    required String model,
    String? proxyEndpoint,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (proxyEndpoint == null || proxyEndpoint.trim().isEmpty) {
      throw Exception('Secure Backend Proxy endpoint is not configured.');
    }

    final response = await http
        .post(
          Uri.parse(proxyEndpoint),
          headers: {
            'Content-Type': 'application/json',
            if (apiKey != null && apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({'prompt': prompt, 'model': model}),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? data['reply'] ?? data['text'] ?? 'Response received.';
    } else {
      throw Exception('Proxy server returned code ${response.statusCode}');
    }
  }
}

class AiService {
  final SettingsService _settingsService;
  final AppDatabase _dbHelper;
  final Map<String, AiProvider> _providers = {
    'gemini': GeminiAiProvider(),
    'custom_proxy': CustomProxyAiProvider(),
  };
  static const _uuid = Uuid();

  AiService({SettingsService? settingsService, AppDatabase? dbHelper})
      : _settingsService = settingsService ?? SettingsService(),
        _dbHelper = dbHelper ?? AppDatabase.instance;

  Future<bool> isAiEnabled() async {
    final prefs = await _settingsService.getAiPreferences();
    return (prefs['enabled'] as int? ?? 1) == 1;
  }

  Future<bool> hasConsent() async {
    final prefs = await _settingsService.getAiPreferences();
    return (prefs['consent_status'] as int? ?? 0) == 1;
  }

  Future<void> grantConsent() async {
    await _settingsService.updateAiPreferences(consentStatus: true);
  }

  Future<void> revokeConsent() async {
    await _settingsService.updateAiPreferences(consentStatus: false);
  }

  Future<List<AiMessageItem>> getLocalHistory() async {
    final db = await _dbHelper.database;
    final rows = await db.query('ai_history', orderBy: 'timestamp ASC', limit: 100);
    return rows.map((r) => AiMessageItem.fromMap(r)).toList();
  }

  Future<void> clearLocalHistory() async {
    final db = await _dbHelper.database;
    await db.delete('ai_history');
  }

  Future<AiMessageItem> executePrompt({
    required String prompt,
    String? sourceUrl,
  }) async {
    final db = await _dbHelper.database;

    // Check if AI is enabled
    if (!await isAiEnabled()) {
      throw Exception('SHIKHAR AI is currently disabled in Settings.');
    }

    // Check user privacy consent
    if (!await hasConsent()) {
      throw Exception('Consent Required: Please authorize webpage content transmission in the AI panel.');
    }

    final prefs = await _settingsService.getAiPreferences();
    final providerKey = (prefs['provider'] as String?) ?? 'gemini';
    final model = (prefs['model'] as String?) ?? 'gemini-1.5-flash';
    final proxyEndpoint = await _settingsService.getSetting('ai_proxy_endpoint');
    final apiKey = await _settingsService.getAiApiKey();

    final provider = _providers[providerKey] ?? _providers['gemini']!;

    // Save user prompt in local history
    final userMsg = AiMessageItem(
      id: _uuid.v4(),
      role: 'user',
      content: prompt,
      sourceUrl: sourceUrl,
    );
    await db.insert('ai_history', userMsg.toMap());

    try {
      final responseText = await provider.generateResponse(
        prompt: prompt,
        apiKey: apiKey,
        model: model,
        proxyEndpoint: proxyEndpoint,
      );

      final assistantMsg = AiMessageItem(
        id: _uuid.v4(),
        role: 'assistant',
        content: responseText,
        sourceUrl: sourceUrl,
      );
      await db.insert('ai_history', assistantMsg.toMap());
      return assistantMsg;
    } catch (e) {
      final errorMsg = AiMessageItem(
        id: _uuid.v4(),
        role: 'assistant',
        content: e.toString().replaceFirst('Exception: ', ''),
        sourceUrl: sourceUrl,
        isError: true,
      );
      await db.insert('ai_history', errorMsg.toMap());
      return errorMsg;
    }
  }

  // Pre-configured browser AI actions
  String buildSummarizePrompt(String pageContent, String url) {
    return '''
You are SHIKHAR AI, the intelligent browser assistant.
Summarize the following webpage content concisely into key takeaways, core findings, and important details.
URL: $url

Content:
$pageContent
''';
  }

  String buildExplainParagraphPrompt(String paragraph) {
    return '''
You are SHIKHAR AI. Explain the following paragraph clearly in simple, accessible language. Clarify any complex jargon, concepts, or idioms:

$paragraph
''';
  }

  String buildFaqPrompt(String pageContent) {
    return '''
You are SHIKHAR AI. Based on the following webpage content, generate 4-5 high-value Frequently Asked Questions (FAQs) and their concise answers:

$pageContent
''';
  }

  String buildTranslatePrompt(String text, String targetLanguage) {
    return '''
You are SHIKHAR AI. Translate the following text accurately into $targetLanguage while preserving context and tone:

$text
''';
  }
}
