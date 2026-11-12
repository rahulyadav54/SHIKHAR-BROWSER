class TabItem {
  final String id;
  final String url;
  final String title;
  final String? faviconUrl;
  final bool isLoading;
  final double loadingProgress;
  final bool isPrivate;
  final bool canGoBack;
  final bool canGoForward;
  final bool isSecure;
  final DateTime createdAt;

  TabItem({
    required this.id,
    this.url = 'shikhar://home',
    this.title = 'New Tab',
    this.faviconUrl,
    this.isLoading = false,
    this.loadingProgress = 0.0,
    this.isPrivate = false,
    this.canGoBack = false,
    this.canGoForward = false,
    this.isSecure = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isHome => url.isEmpty || url == 'shikhar://home' || url == 'about:blank';

  TabItem copyWith({
    String? id,
    String? url,
    String? title,
    String? faviconUrl,
    bool? isLoading,
    double? loadingProgress,
    bool? isPrivate,
    bool? canGoBack,
    bool? canGoForward,
    bool? isSecure,
    DateTime? createdAt,
  }) {
    return TabItem(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      isLoading: isLoading ?? this.isLoading,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      isPrivate: isPrivate ?? this.isPrivate,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
      isSecure: isSecure ?? this.isSecure,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'favicon_url': faviconUrl,
      'is_private': isPrivate ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TabItem.fromMap(Map<String, dynamic> map) {
    return TabItem(
      id: map['id'] as String,
      url: map['url'] as String? ?? 'shikhar://home',
      title: map['title'] as String? ?? 'New Tab',
      faviconUrl: map['favicon_url'] as String?,
      isPrivate: (map['is_private'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
}

