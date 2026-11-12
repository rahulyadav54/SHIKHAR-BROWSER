import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'browser_controller.dart';

class AndroidBrowserController implements BrowserController {
  @override
  final String tabId;

  @override
  final bool isPrivate;

  bool _isDisposed = false;
  @override
  bool get isDisposed => _isDisposed;

  WebViewController? _controller;
  Widget? _viewWidget;

  // Known ad request filters
  static final List<String> _adFilterPatterns = [
    'googleads.g.doubleclick.net',
    'pagead2.googlesyndication.com',
    'adservice.google.com',
    'pubads.g.doubleclick.net',
    'securepubads.g.doubleclick.net',
    'youtube.com/api/stats/ads',
    'youtube.com/pagead/',
    'youtube.com/ptracking',
    'fls-na.amazon.com',
    'scorecardresearch.com',
  ];

  // YouTube & Web AdBlocker JavaScript Engine
  static const String _adBlockScript = '''
(function() {
  if (window.__shikhar_adblock_installed) return;
  window.__shikhar_adblock_installed = true;

  // 1. Hide ad elements via injected style
  try {
    var style = document.createElement('style');
    style.id = 'shikhar-adblock-styles';
    style.textContent = `
      .video-ads, .ytp-ad-module, .ytp-ad-overlay-container,
      .ytp-ad-player-overlay, .ytp-ad-player-overlay-layout,
      .ytp-ad-text, .ytp-ad-preview-container, .ytp-ad-image-overlay,
      ytd-promoted-sparkles-web-renderer, ytd-display-ad-renderer,
      ytd-statement-banner-renderer, ytd-in-feed-ad-layout-renderer,
      ytd-banner-promo-renderer, ytm-promoted-sparkles-web-renderer,
      ytm-companion-ad-renderer, .ad-container, .ad-showing, .ad-interrupting,
      #player-ads, ytm-promoted-video-renderer, .sparkles-light-cta,
      .ytp-ad-action-interstitial, .ytp-ad-overlay-image,
      div[class*="ad-showing"], div[class*="ad-interrupting"] {
        display: none !important;
        visibility: hidden !important;
        opacity: 0 !important;
        pointer-events: none !important;
        height: 0 !important;
        width: 0 !important;
      }
    `;
    if (document.head) {
      document.head.appendChild(style);
    } else {
      document.documentElement.appendChild(style);
    }
  } catch(e) {}

  // 2. High-speed detector to dismiss and skip YouTube video ads instantly
  function purgeVideoAds() {
    try {
      // Auto-click any skip ad button
      var skipBtns = document.querySelectorAll(
        '.ytp-ad-skip-button, .ytp-ad-skip-button-modern, .ytp-skip-ad-button, .videoAdUiSkipButton, .ytp-ad-skip-button-slot button, [class*="skip-button"]'
      );
      for (var i = 0; i < skipBtns.length; i++) {
        skipBtns[i].click();
      }

      // If ad is playing inside the video element, skip straight to the end
      var moviePlayer = document.getElementById('movie_player') || document.querySelector('.html5-video-player');
      var isAdShowing = false;
      if (moviePlayer && (moviePlayer.classList.contains('ad-showing') || moviePlayer.classList.contains('ad-interrupting'))) {
        isAdShowing = true;
      }
      var adModule = document.querySelector('.ytp-ad-module') || document.querySelector('.video-ads');
      if (adModule && adModule.children.length > 0) {
        isAdShowing = true;
      }

      if (isAdShowing) {
        var video = document.querySelector('video');
        if (video) {
          if (!isNaN(video.duration) && video.duration > 0) {
            video.currentTime = video.duration;
          }
          video.playbackRate = 16.0;
        }
      }
    } catch(err) {}
  }

  // Run immediately and every 100ms
  purgeVideoAds();
  setInterval(purgeVideoAds, 100);
})();
''';

  // JavaScript for enabling long-press media downloading on images and videos
  static const String _mediaDownloadScript = '''
(function() {
  if (window.__shikhar_media_downloader_installed) return;
  window.__shikhar_media_downloader_installed = true;

  var touchTimer = null;
  var touchTarget = null;

  function handleMediaDownload(src) {
    if (!src) return;
    if (window.ShikharMediaDownloader) {
      window.ShikharMediaDownloader.postMessage(src);
    }
  }

  document.addEventListener('contextmenu', function(e) {
    var target = e.target;
    if (target.tagName === 'IMG' && target.src) {
      e.preventDefault();
      handleMediaDownload(target.src);
    } else if (target.tagName === 'VIDEO' && (target.src || target.currentSrc)) {
      e.preventDefault();
      handleMediaDownload(target.currentSrc || target.src);
    } else if (target.closest('a') && target.closest('a').href) {
      var href = target.closest('a').href;
      var extMatch = /\\.(mp4|mkv|webm|avi|mov|mp3|m4a|wav|jpg|jpeg|png|gif|webp|pdf|apk)(\\?|\$)/i;
      if (extMatch.test(href)) {
        e.preventDefault();
        handleMediaDownload(href);
      }
    }
  }, false);

  // Long press listener on touch devices
  document.addEventListener('touchstart', function(e) {
    var target = e.target;
    var mediaEl = null;
    if (target.tagName === 'IMG') {
      mediaEl = target;
    } else if (target.tagName === 'VIDEO') {
      mediaEl = target;
    } else {
      var img = target.querySelector ? target.querySelector('img, video') : null;
      if (img) mediaEl = img;
    }

    if (mediaEl) {
      touchTarget = mediaEl;
      touchTimer = setTimeout(function() {
        var src = touchTarget.currentSrc || touchTarget.src;
        if (src) {
          handleMediaDownload(src);
        }
      }, 700);
    }
  }, { passive: true });

  document.addEventListener('touchend', function() {
    if (touchTimer) {
      clearTimeout(touchTimer);
      touchTimer = null;
    }
  }, { passive: true });

  document.addEventListener('touchmove', function() {
    if (touchTimer) {
      clearTimeout(touchTimer);
      touchTimer = null;
    }
  }, { passive: true });
})();
''';

  AndroidBrowserController({
    required this.tabId,
    this.isPrivate = false,
  });

  static const List<String> _mediaExtensions = [
    '.mp4', '.mkv', '.webm', '.avi', '.mov', '.mp3', '.m4a', '.wav', '.ogg',
    '.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg',
    '.pdf', '.zip', '.rar', '.7z', '.tar', '.gz', '.apk', '.exe', '.dmg',
  ];

  @override
  Future<void> initialize({
    required String initialUrl,
    required void Function(String title) onTitleChanged,
    required void Function(String url) onUrlChanged,
    required void Function(double progress) onProgressChanged,
    required void Function(bool isLoading) onLoadingChanged,
    required void Function(String error) onError,
    void Function(String url, String? filename)? onDownloadRequested,
  }) async {
    final controller = WebViewController();

    // Android-specific configuration
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      final androidController = controller.platform as AndroidWebViewController;
      await androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    // Register JavaScript channel for long-press image/video downloads and context options
    await controller.addJavaScriptChannel(
      'ShikharMediaDownloader',
      onMessageReceived: (JavaScriptMessage msg) {
        if (!_isDisposed && onDownloadRequested != null) {
          final mediaUrl = msg.message.trim();
          if (mediaUrl.isNotEmpty && (mediaUrl.startsWith('http://') || mediaUrl.startsWith('https://'))) {
            final uri = Uri.tryParse(mediaUrl);
            final filename = uri != null && uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
            onDownloadRequested(mediaUrl, filename);
          }
        }
      },
    );

    // If private mode, isolate storage
    if (isPrivate) {
      await controller.clearCache();
      await controller.clearLocalStorage();
    }

    await controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          if (!_isDisposed) {
            final frac = progress / 100.0;
            onProgressChanged(frac);
            if (frac > 0.3) {
              _injectScripts(controller);
            }
          }
        },
        onPageStarted: (String url) {
          if (!_isDisposed) {
            onLoadingChanged(true);
            onUrlChanged(url);
            _injectScripts(controller);
          }
        },
        onPageFinished: (String url) async {
          if (!_isDisposed) {
            onLoadingChanged(false);
            onUrlChanged(url);
            _injectScripts(controller);
            final title = await controller.getTitle();
            if (title != null && title.isNotEmpty) {
              onTitleChanged(title);
            }
          }
        },
        onWebResourceError: (WebResourceError error) {
          if (!_isDisposed) {
            // Ignore cancelled or filtered ad resource errors
            if (!error.description.contains('net::ERR_BLOCKED_BY_CLIENT')) {
              onError(error.description);
            }
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          final url = request.url;
          final urlLower = url.toLowerCase();

          // Block ad requests
          for (final pattern in _adFilterPatterns) {
            if (urlLower.contains(pattern)) {
              return NavigationDecision.prevent;
            }
          }

          // Handle special URI schemes (market://, intent://, tel:, mailto:, sms:, etc.)
          final uri = Uri.tryParse(url);
          final scheme = uri?.scheme.toLowerCase() ?? '';

          if (scheme == 'market' ||
              scheme == 'tel' ||
              scheme == 'mailto' ||
              scheme == 'sms' ||
              scheme == 'whatsapp' ||
              scheme == 'geo' ||
              scheme == 'intent') {
            _handleExternalScheme(url);
            return NavigationDecision.prevent;
          }

          // Play Store web links that user expects to open in Play Store app if available
          if (uri != null && (uri.host == 'play.google.com' || uri.host == 'market.android.com')) {
            // Check if it's an app details page: /store/apps/details?id=...
            if (uri.path.contains('/details') || uri.path.contains('/store/apps')) {
              _handlePlayStoreUrl(url, uri);
              return NavigationDecision.prevent;
            }
          }

          // Direct media/file download detection
          if (onDownloadRequested != null && uri != null) {
            final pathLower = uri.path.toLowerCase();
            for (final ext in _mediaExtensions) {
              if (pathLower.endsWith(ext) || pathLower.contains('$ext?')) {
                final filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
                onDownloadRequested(url, filename);
                return NavigationDecision.prevent;
              }
            }
          }

          return NavigationDecision.navigate;
        },
      ),
    );

    _controller = controller;
    _viewWidget = WebViewWidget(controller: controller);

    if (initialUrl.isNotEmpty && initialUrl != 'shikhar://home' && initialUrl != 'about:blank') {
      await controller.loadRequest(Uri.parse(initialUrl));
    }
  }

  void _handleExternalScheme(String urlString) async {
    try {
      if (urlString.startsWith('intent:')) {
        // Parse Android intent scheme e.g.
        // intent://details?id=com.example#Intent;scheme=market;package=com.android.vending;end
        // Extract fallback or direct market URI
        final fallbackMatch = RegExp(r'S\.browser_fallback_url=([^;]+)').firstMatch(urlString);
        final packageMatch = RegExp(r'package=([^;]+)').firstMatch(urlString);
        final schemeMatch = RegExp(r'scheme=([^;]+)').firstMatch(urlString);

        if (packageMatch != null) {
          final pkg = packageMatch.group(1);
          final marketUri = Uri.parse('market://details?id=$pkg');
          if (await canLaunchUrl(marketUri)) {
            await launchUrl(marketUri, mode: LaunchMode.externalApplication);
            return;
          }
        }

        if (schemeMatch != null && schemeMatch.group(1) == 'market') {
          final pathAndQuery = urlString.substring(9).split('#').first;
          final marketUri = Uri.parse('market://$pathAndQuery');
          if (await canLaunchUrl(marketUri)) {
            await launchUrl(marketUri, mode: LaunchMode.externalApplication);
            return;
          }
        }

        if (fallbackMatch != null) {
          final fallbackUrl = Uri.decodeComponent(fallbackMatch.group(1)!);
          final fallbackUri = Uri.tryParse(fallbackUrl);
          if (fallbackUri != null) {
            await loadUrl(fallbackUrl);
            return;
          }
        }
      }

      final uri = Uri.tryParse(urlString);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _handlePlayStoreUrl(String originalUrl, Uri uri) async {
    try {
      // Extract package id query param
      final appId = uri.queryParameters['id'];
      if (appId != null && appId.isNotEmpty) {
        final marketUri = Uri.parse('market://details?id=$appId');
        if (await canLaunchUrl(marketUri)) {
          await launchUrl(marketUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      // If market:// isn't directly resolvable, open standard https url via external app / browser
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: load inside webview
        await _controller?.loadRequest(uri);
      }
    } catch (_) {
      final fallback = Uri.tryParse(originalUrl);
      if (fallback != null) {
        await _controller?.loadRequest(fallback);
      }
    }
  }

  void _injectScripts(WebViewController controller) {
    if (_isDisposed) return;
    try {
      controller.runJavaScript(_adBlockScript);
      controller.runJavaScript(_mediaDownloadScript);
    } catch (_) {}
  }

  @override
  Future<void> loadUrl(String url) async {
    if (_controller == null || _isDisposed) return;
    if (url == 'shikhar://home' || url == 'about:blank' || url.isEmpty) {
      await _controller!.loadHtmlString('<html><body></body></html>');
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await _controller!.loadRequest(uri);
    }
  }

  @override
  Future<void> reload() async {
    if (_controller != null && !_isDisposed) {
      await _controller!.reload();
    }
  }

  @override
  Future<void> stopLoading() async {
    if (_controller != null && !_isDisposed) {
      // Stopping ongoing navigation
      await _controller!.runJavaScript('window.stop ? window.stop() : null;');
    }
  }

  @override
  Future<void> goBack() async {
    if (_controller != null && !_isDisposed && await _controller!.canGoBack()) {
      await _controller!.goBack();
    }
  }

  @override
  Future<void> goForward() async {
    if (_controller != null && !_isDisposed && await _controller!.canGoForward()) {
      await _controller!.goForward();
    }
  }

  @override
  Future<bool> canGoBack() async {
    if (_controller != null && !_isDisposed) {
      return await _controller!.canGoBack();
    }
    return false;
  }

  @override
  Future<bool> canGoForward() async {
    if (_controller != null && !_isDisposed) {
      return await _controller!.canGoForward();
    }
    return false;
  }

  @override
  Future<String> extractPageText() async {
    if (_controller == null || _isDisposed) return '';
    try {
      final result = await _controller!.runJavaScriptReturningResult(
        'document.body ? (document.body.innerText || document.body.textContent || "") : ""',
      );
      return result.toString();
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> clearSessionData() async {
    if (_controller != null && !_isDisposed) {
      await _controller!.clearCache();
      await _controller!.clearLocalStorage();
      final cookieManager = WebViewCookieManager();
      await cookieManager.clearCookies();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller = null;
    _viewWidget = null;
  }

  @override
  Widget buildView() {
    return _viewWidget ?? const SizedBox.shrink();
  }
}
