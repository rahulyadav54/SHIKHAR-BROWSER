class UrlUtils {
  UrlUtils._();

  static const String homeScheme = 'shikhar://home';

  /// Standard Top-Level Domains regex pattern to detect naked domains like "wikipedia.org"
  static final RegExp _domainRegex = RegExp(
    r'^(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,63}(?::\d+)?(?:/.*)?$',
  );

  /// Localhost or IPv4 pattern (e.g. localhost:8080 or 127.0.0.1:3000)
  static final RegExp _localHostRegex = RegExp(
    r'^(?:localhost|127\.0\.0\.1|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(?::\d+)?(?:/.*)?$',
  );

  /// Analyzes input from the address bar. If it's a valid URL or domain, returns normalized URL.
  /// If it's a search term, constructs the search URL using the provided search template.
  static String formatInput(String rawInput, {String searchTemplate = 'https://www.google.com/search?q={q}'}) {
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) return homeScheme;

    if (trimmed == 'shikhar://home' || trimmed == 'about:blank') {
      return trimmed;
    }

    // Explicit valid URI scheme
    if (trimmed.startsWith('https://') || trimmed.startsWith('http://') || trimmed.startsWith('file://')) {
      final uri = Uri.tryParse(trimmed);
      if (uri != null && uri.hasAuthority) {
        return trimmed;
      }
    }

    // Check if user typed a bare domain or localhost without scheme
    if (_domainRegex.hasMatch(trimmed) || _localHostRegex.hasMatch(trimmed)) {
      // Default to HTTPS for security
      return 'https://$trimmed';
    }

    // Treat as search query
    final encodedQuery = Uri.encodeQueryComponent(trimmed);
    return searchTemplate.replaceAll('{q}', encodedQuery);
  }

  /// Determines if a URL uses a secure HTTPS connection.
  static bool isSecure(String? url) {
    if (url == null || url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.startsWith('https://');
  }

  /// Determines if the URL represents the internal SHIKHAR homepage.
  static bool isHome(String? url) {
    return url == null || url.isEmpty || url == homeScheme || url == 'about:blank';
  }

  /// Extracts the readable host/domain from a URL for display in the address bar.
  static String extractDomain(String? url) {
    if (url == null || url.isEmpty || isHome(url)) {
      return 'SHIKHAR Home';
    }
    try {
      final uri = Uri.parse(url);
      if (uri.host.isNotEmpty) {
        return uri.host;
      }
      return url;
    } catch (_) {
      return url;
    }
  }

  /// Extract root favicon URL for a given webpage URL
  static String getFaviconUrl(String? pageUrl) {
    if (pageUrl == null || pageUrl.isEmpty || isHome(pageUrl)) {
      return '';
    }
    try {
      final uri = Uri.parse(pageUrl);
      if (uri.host.isNotEmpty) {
        return 'https://www.google.com/s2/favicons?domain=${uri.host}&sz=64';
      }
    } catch (_) {}
    return '';
  }
}

