class SearchEngine {
  final String id;
  final String name;
  final String searchUrlTemplate;
  final String iconKey;
  final bool isDefault;

  const SearchEngine({
    required this.id,
    required this.name,
    required this.searchUrlTemplate,
    required this.iconKey,
    this.isDefault = false,
  });

  String buildSearchUrl(String query) {
    return searchUrlTemplate.replaceAll('{q}', Uri.encodeQueryComponent(query));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'search_url': searchUrlTemplate,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory SearchEngine.fromMap(Map<String, dynamic> map) {
    return SearchEngine(
      id: map['id'] as String,
      name: map['name'] as String,
      searchUrlTemplate: map['search_url'] as String,
      iconKey: (map['name'] as String).toLowerCase(),
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }

  static const List<SearchEngine> defaults = [
    SearchEngine(
      id: 'google',
      name: 'Google',
      searchUrlTemplate: 'https://www.google.com/search?q={q}',
      iconKey: 'google',
      isDefault: true,
    ),
    SearchEngine(
      id: 'duckduckgo',
      name: 'DuckDuckGo',
      searchUrlTemplate: 'https://duckduckgo.com/?q={q}',
      iconKey: 'duckduckgo',
    ),
    SearchEngine(
      id: 'bing',
      name: 'Bing',
      searchUrlTemplate: 'https://www.bing.com/search?q={q}',
      iconKey: 'bing',
    ),
    SearchEngine(
      id: 'brave',
      name: 'Brave Search',
      searchUrlTemplate: 'https://search.brave.com/search?q={q}',
      iconKey: 'brave',
    ),
  ];
}

