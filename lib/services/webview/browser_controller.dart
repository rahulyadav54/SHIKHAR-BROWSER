import 'dart:io';
import 'package:flutter/widgets.dart';
import 'android_browser_controller.dart';
import 'windows_browser_controller.dart';

abstract class BrowserController {
  String get tabId;
  bool get isPrivate;
  bool get isDisposed;

  Future<void> initialize({
    required String initialUrl,
    required void Function(String title) onTitleChanged,
    required void Function(String url) onUrlChanged,
    required void Function(double progress) onProgressChanged,
    required void Function(bool isLoading) onLoadingChanged,
    required void Function(String error) onError,
    void Function(String url, String? filename)? onDownloadRequested,
  });

  Future<void> loadUrl(String url);
  Future<void> reload();
  Future<void> stopLoading();
  Future<void> goBack();
  Future<void> goForward();
  Future<bool> canGoBack();
  Future<bool> canGoForward();
  Future<String> extractPageText();
  Future<void> clearSessionData();
  void dispose();

  Widget buildView();

  static BrowserController create({
    required String tabId,
    bool isPrivate = false,
  }) {
    if (Platform.isWindows) {
      return WindowsBrowserController(tabId: tabId, isPrivate: isPrivate);
    } else {
      return AndroidBrowserController(tabId: tabId, isPrivate: isPrivate);
    }
  }
}

