import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/search_engines.dart';
import '../services/settings_service.dart';

class SettingsState {
  final ThemeMode themeMode;
  final SearchEngine searchEngine;
  final List<SearchEngine> searchEngines;
  final String homepage;
  final bool javascriptEnabled;
  final bool blockPopups;
  final bool restoreTabs;
  final bool doNotTrack;
  final bool aiEnabled;
  final String aiProvider;
  final String aiModel;
  final bool aiConsent;
  final bool hasApiKey;
  final String homeThemePreset;
  final String? customWallpaperPath;
  final bool isLoading;

  const SettingsState({
    required this.themeMode,
    required this.searchEngine,
    required this.searchEngines,
    required this.homepage,
    required this.javascriptEnabled,
    required this.blockPopups,
    required this.restoreTabs,
    required this.doNotTrack,
    required this.aiEnabled,
    required this.aiProvider,
    required this.aiModel,
    required this.aiConsent,
    required this.hasApiKey,
    this.homeThemePreset = 'default',
    this.customWallpaperPath,
    this.isLoading = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    SearchEngine? searchEngine,
    List<SearchEngine>? searchEngines,
    String? homepage,
    bool? javascriptEnabled,
    bool? blockPopups,
    bool? restoreTabs,
    bool? doNotTrack,
    bool? aiEnabled,
    String? aiProvider,
    String? aiModel,
    bool? aiConsent,
    bool? hasApiKey,
    String? homeThemePreset,
    String? customWallpaperPath,
    bool? isLoading,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      searchEngine: searchEngine ?? this.searchEngine,
      searchEngines: searchEngines ?? this.searchEngines,
      homepage: homepage ?? this.homepage,
      javascriptEnabled: javascriptEnabled ?? this.javascriptEnabled,
      blockPopups: blockPopups ?? this.blockPopups,
      restoreTabs: restoreTabs ?? this.restoreTabs,
      doNotTrack: doNotTrack ?? this.doNotTrack,
      aiEnabled: aiEnabled ?? this.aiEnabled,
      aiProvider: aiProvider ?? this.aiProvider,
      aiModel: aiModel ?? this.aiModel,
      aiConsent: aiConsent ?? this.aiConsent,
      hasApiKey: hasApiKey ?? this.hasApiKey,
      homeThemePreset: homeThemePreset ?? this.homeThemePreset,
      customWallpaperPath: customWallpaperPath ?? this.customWallpaperPath,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsService _service;

  SettingsNotifier({SettingsService? service})
      : _service = service ?? SettingsService(),
        super(SettingsState(
          themeMode: ThemeMode.system,
          searchEngine: SearchEngine.defaults.first,
          searchEngines: SearchEngine.defaults,
          homepage: 'shikhar://home',
          javascriptEnabled: true,
          blockPopups: true,
          restoreTabs: false,
          doNotTrack: true,
          aiEnabled: true,
          aiProvider: 'gemini',
          aiModel: 'gemini-1.5-flash',
          aiConsent: false,
          hasApiKey: false,
          homeThemePreset: 'default',
          customWallpaperPath: null,
          isLoading: true,
        )) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true);
    final all = await _service.getAllSettings();
    final engines = await _service.getSearchEngines();
    final defaultEngine = await _service.getDefaultSearchEngine();
    final aiPrefs = await _service.getAiPreferences();
    final apiKey = await _service.getAiApiKey();

    ThemeMode mode = ThemeMode.system;
    final modeStr = all['theme_mode'];
    if (modeStr == 'light') mode = ThemeMode.light;
    if (modeStr == 'dark') mode = ThemeMode.dark;

    final wallpaper = all['custom_wallpaper_path'];

    state = state.copyWith(
      themeMode: mode,
      searchEngine: defaultEngine,
      searchEngines: engines,
      homepage: all['homepage'] ?? 'shikhar://home',
      javascriptEnabled: all['javascript_enabled'] != 'false',
      blockPopups: all['block_popups'] != 'false',
      restoreTabs: all['restore_tabs'] == 'true',
      doNotTrack: all['do_not_track'] != 'false',
      aiEnabled: (aiPrefs['enabled'] as int? ?? 1) == 1,
      aiProvider: (aiPrefs['provider'] as String?) ?? 'gemini',
      aiModel: (aiPrefs['model'] as String?) ?? 'gemini-1.5-flash',
      aiConsent: (aiPrefs['consent_status'] as int? ?? 0) == 1,
      hasApiKey: apiKey != null && apiKey.isNotEmpty,
      homeThemePreset: all['home_theme_preset'] ?? 'default',
      customWallpaperPath: (wallpaper != null && wallpaper.isNotEmpty) ? wallpaper : null,
      isLoading: false,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final str = mode == ThemeMode.light ? 'light' : (mode == ThemeMode.dark ? 'dark' : 'system');
    await _service.setSetting('theme_mode', str);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setHomeThemePreset(String preset) async {
    await _service.setSetting('home_theme_preset', preset);
    if (preset == 'light') {
      await setThemeMode(ThemeMode.light);
    } else if (state.themeMode == ThemeMode.light && preset != 'light') {
      await setThemeMode(ThemeMode.dark);
    }
    state = state.copyWith(homeThemePreset: preset);
  }

  Future<void> setCustomWallpaper(String? filePath) async {
    if (filePath != null && filePath.isNotEmpty) {
      await _service.setSetting('custom_wallpaper_path', filePath);
      await _service.setSetting('home_theme_preset', 'custom');
      state = state.copyWith(
        customWallpaperPath: filePath,
        homeThemePreset: 'custom',
      );
    } else {
      await _service.setSetting('custom_wallpaper_path', '');
      await _service.setSetting('home_theme_preset', 'default');
      state = state.copyWith(
        customWallpaperPath: null,
        homeThemePreset: 'default',
      );
    }
  }

  Future<void> setDefaultSearchEngine(String id) async {
    await _service.setDefaultSearchEngine(id);
    final engine = state.searchEngines.firstWhere((e) => e.id == id);
    state = state.copyWith(searchEngine: engine);
  }

  Future<void> setHomepage(String url) async {
    await _service.setSetting('homepage', url);
    state = state.copyWith(homepage: url);
  }

  Future<void> setAiApiKey(String key) async {
    await _service.saveAiApiKey(key);
    state = state.copyWith(hasApiKey: key.isNotEmpty);
  }

  Future<void> setAiEnabled(bool enabled) async {
    await _service.updateAiPreferences(enabled: enabled);
    state = state.copyWith(aiEnabled: enabled);
  }

  Future<void> setAiModel(String model) async {
    await _service.updateAiPreferences(model: model);
    state = state.copyWith(aiModel: model);
  }

  Future<void> setAiConsent(bool consent) async {
    await _service.updateAiPreferences(consentStatus: consent);
    state = state.copyWith(aiConsent: consent);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
