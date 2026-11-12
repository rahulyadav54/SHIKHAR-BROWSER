class BookmarkItem {
  final String id;
  final String title;
  final String url;
  final String? folderId;
  final String? favicon;
  final DateTime createdAt;

  BookmarkItem({
    required this.id,
    required this.title,
    required this.url,
    this.folderId,
    this.favicon,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'folder_id': folderId,
      'favicon': favicon,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BookmarkItem.fromMap(Map<String, dynamic> map) {
    return BookmarkItem(
      id: map['id'] as String,
      title: map['title'] as String,
      url: map['url'] as String,
      folderId: map['folder_id'] as String?,
      favicon: map['favicon'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  BookmarkItem copyWith({
    String? id,
    String? title,
    String? url,
    String? folderId,
    String? favicon,
    DateTime? createdAt,
  }) {
    return BookmarkItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      folderId: folderId ?? this.folderId,
      favicon: favicon ?? this.favicon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

