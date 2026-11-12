class HistoryItem {
  final String id;
  final String title;
  final String url;
  final DateTime visitedAt;

  HistoryItem({
    required this.id,
    required this.title,
    required this.url,
    DateTime? visitedAt,
  }) : visitedAt = visitedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'visited_at': visitedAt.millisecondsSinceEpoch,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as String,
      title: map['title'] as String,
      url: map['url'] as String,
      visitedAt: DateTime.fromMillisecondsSinceEpoch(map['visited_at'] as int),
    );
  }
}

