import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';
import 'browser_controller.dart';

class WindowsBrowserController implements BrowserController {
  @override
  final String tabId;

  @override
  final bool isPrivate;

  bool _isDisposed = false;
  @override
  bool get isDisposed => _isDisposed;

  final WebviewController _controller = WebviewController();
  final List<StreamSubscription> _subscriptions = [];
  bool _isInitialized = false;

  WindowsBrowserController({
    required this.tabId,
    this.isPrivate = false,
  });

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
    try {
      await _controller.initialize();
      _isInitialized = true;

      // URL change listener
      _subscriptions.add(
        _controller.url.listen((url) {
          if (!_isDisposed) {
            onUrlChanged(url);
          }
        }),
      );

      // Title change listener
      _subscriptions.add(
        _controller.title.listen((title) {
          if (!_isDisposed) {
            onTitleChanged(title);
          }
        }),
      );

      // Loading state listener
      _subscriptions.add(
        _controller.loadingState.listen((state) {
          if (!_isDisposed) {
            if (state == LoadingState.loading) {
              onLoadingChanged(true);
              onProgressChanged(0.5);
            } else if (state == LoadingState.navigationCompleted) {
              onLoadingChanged(false);
              onProgressChanged(1.0);
              _injectAdBlocker();
            }
          }
        }),
      );

      // Set background color to match browser theme
      await _controller.setBackgroundColor(Colors.transparent);

      if (initialUrl.isNotEmpty && initialUrl != 'shikhar://home' && initialUrl != 'about:blank') {
        await _controller.loadUrl(initialUrl);
      }
    } catch (e) {
      onError('WebView2 initialization error: $e');
    }
  }

  @override
  Future<void> loadUrl(String url) async {
    if (!_isInitialized || _isDisposed) return;
    if (url == 'shikhar://home' || url == 'about:blank' || url.isEmpty) {
      await _controller.loadStringContent('<html><body></body></html>');
      return;
    }
    await _controller.loadUrl(url);
  }

  @override
  Future<void> reload() async {
    if (_isInitialized && !_isDisposed) {
      await _controller.reload();
    }
  }

  @override
  Future<void> stopLoading() async {
    if (_isInitialized && !_isDisposed) {
      await _controller.stop();
    }
  }

  @override
  Future<void> goBack() async {
    if (_isInitialized && !_isDisposed) {
      await _controller.goBack();
    }
  }

  @override
  Future<void> goForward() async {
    if (_isInitialized && !_isDisposed) {
      await _controller.goForward();
    }
  }

  @override
  Future<bool> canGoBack() async {
    // Windows WebView2 handles back stack natively
    return true;
  }

  @override
  Future<bool> canGoForward() async {
    return true;
  }

  @override
  Future<String> extractPageText() async {
    if (!_isInitialized || _isDisposed) return '';
    try {
      final result = await _controller.executeScript(
        'document.body ? (document.body.innerText || document.body.textContent || "") : ""',
      );
      return result?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Future<void> clearSessionData() async {
    if (_isInitialized && !_isDisposed) {
      try {
        await _controller.clearCookies();
        await _controller.clearCache();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    _controller.dispose();
  }

  Future<void> _injectAdBlocker() async {
    if (!_isInitialized || _isDisposed) return;
    try {
      await _controller.executeScript('''
        (function() {
          if (window.__shikhar_win_adblock_installed) return;
          window.__shikhar_win_adblock_installed = true;

          // 1. Comprehensive element-hiding CSS rule injection
          try {
            const style = document.createElement('style');
            style.id = 'shikhar-win-adblock-styles';
            style.textContent = `
              .ad-showing, .ad-interrupting, .ad-container, .ytp-ad-overlay-container,
              .video-ads, .ytp-ad-module, ytd-ad-slot-renderer,
              #player-ads, .sparkles-light-cta, ytd-in-feed-ad-layout-renderer,
              .ytd-banner-promo-renderer, ytd-statement-banner-renderer,
              #masthead-ad, .ytd-merch-shelf-renderer, .ytp-ad-player-overlay,
              .ytp-ad-player-overlay-layout, .ytp-ad-text, .ytp-ad-preview-container,
              .ytp-ad-image-overlay, ytd-promoted-sparkles-web-renderer,
              ytd-display-ad-renderer, ytm-promoted-sparkles-web-renderer,
              ytm-companion-ad-renderer, ytm-promoted-video-renderer,
              .ytp-ad-action-interstitial, .ytp-ad-overlay-image,
              div[class*="ad-showing"], div[class*="ad-interrupting"],
              ytd-rich-item-renderer:has(ytd-ad-slot-renderer),
              ytd-banner-promo-renderer-background,
              #panels:has(ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-ads"]),
              google-ad, ins.adsbygoogle {
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
            } else if (document.documentElement) {
              document.documentElement.appendChild(style);
            }
          } catch(e) {}

          // 2. High-speed aggressive video ad skipper & mutation listener
          function purgeAds() {
            try {
              // Click modern & legacy skip buttons
              const skipSelectors = [
                '.ytp-ad-skip-button',
                '.ytp-ad-skip-button-modern',
                '.ytp-skip-ad-button',
                '.videoAdUiSkipButton',
                '.ytp-ad-skip-button-slot button',
                '[class*="skip-button"]',
                '.ytp-ad-preview-container button'
              ];
              const skipBtns = document.querySelectorAll(skipSelectors.join(','));
              for (let i = 0; i < skipBtns.length; i++) {
                skipBtns[i].click();
              }

              // Detect video ad playing
              const moviePlayer = document.getElementById('movie_player') || document.querySelector('.html5-video-player');
              let isAd = false;
              if (moviePlayer && (moviePlayer.classList.contains('ad-showing') || moviePlayer.classList.contains('ad-interrupting'))) {
                isAd = true;
              }
              const adModule = document.querySelector('.ytp-ad-module, .video-ads');
              if (adModule && adModule.children.length > 0) {
                isAd = true;
              }

              if (isAd) {
                const video = document.querySelector('video');
                if (video) {
                  video.muted = true;
                  if (!isNaN(video.duration) && video.duration > 0) {
                    video.currentTime = video.duration;
                  }
                  video.playbackRate = 16.0;
                }
              }
            } catch (_) {}
          }

          purgeAds();
          setInterval(purgeAds, 80);

          // Listen for DOM changes to strip ad nodes before paint
          const observer = new MutationObserver(purgeAds);
          observer.observe(document.documentElement || document.body, {
            childList: true,
            subtree: true
          });
        })();
      ''');
    } catch (_) {}
  }

  @override
  Widget buildView() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Webview(_controller);
  }
}

