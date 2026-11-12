class AiMessageItem {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;
  final String? sourceUrl;
  final bool isError;

  AiMessageItem({
    required this.id,
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.sourceUrl,
    this.isError = false,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isUser => role == 'user';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'source_url': sourceUrl,
      'is_error': isError ? 1 : 0,
    };
  }

  factory AiMessageItem.fromMap(Map<String, dynamic> map) {
    return AiMessageItem(
      id: map['id'] as String,
      role: map['role'] as String,
      content: map['content'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      sourceUrl: map['source_url'] as String?,
      isError: (map['is_error'] as int? ?? 0) == 1,
    );
  }
}

