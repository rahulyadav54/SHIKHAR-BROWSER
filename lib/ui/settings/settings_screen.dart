import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/branding/brand_constants.dart';
import '../../core/branding/shikhar_logo.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../state/history_notifier.dart';
import '../../state/settings_notifier.dart';
import '../../state/ai_assistant_notifier.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/theme_customizer_sheet.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _homepageController = TextEditingController();
  bool _apiKeyObscured = true;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _homepageController.text = settings.homepage;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _homepageController.dispose();
    super.dispose();
  }

  void _saveApiKey() {
    final key = _apiKeyController.text.trim();
    if (key.isNotEmpty) {
      ref.read(settingsProvider.notifier).setAiApiKey(key);
      _apiKeyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI API key saved securely!')),
      );
    }
  }

  void _showPolicyDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section: General
          _buildSectionHeader('GENERAL'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Default Search Engine'),
                  subtitle: Text(settings.searchEngine.name),
                  trailing: DropdownButton<String>(
                    value: settings.searchEngine.id,
                    underline: const SizedBox(),
                    items: settings.searchEngines.map((e) {
                      return DropdownMenuItem(value: e.id, child: Text(e.name));
                    }).toList(),
                    onChanged: (id) {
                      if (id != null) {
                        ref.read(settingsProvider.notifier).setDefaultSearchEngine(id);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Homepage URL'),
                  subtitle: Text(settings.homepage),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Edit Homepage'),
                          content: TextField(
                            controller: _homepageController,
                            decoration: const InputDecoration(hintText: 'shikhar://home or custom URL'),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(settingsProvider.notifier).setHomepage(_homepageController.text.trim());
                                Navigator.pop(ctx);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: Appearance
          _buildSectionHeader('APPEARANCE'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_medium_rounded),
                  title: const Text('Theme Mode'),
                  subtitle: Text(settings.themeMode.name.toUpperCase()),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System Default')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light Mode')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark Mode')),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(settingsProvider.notifier).setThemeMode(mode);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Homepage Theme & Wallpaper'),
                  subtitle: Text(
                    settings.homeThemePreset == 'custom'
                        ? 'Custom PC Wallpaper'
                        : ThemeCustomizerSheet.presets
                            .firstWhere((p) => p.id == settings.homeThemePreset,
                                orElse: () => ThemeCustomizerSheet.presets.first)
                            .name,
                  ),
                  trailing: TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => const ThemeCustomizerSheet(),
                      );
                    },
                    icon: const Icon(Icons.tune_rounded, size: 16),
                    label: const Text('Customize'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Upload Wallpaper from PC'),
                  subtitle: Text(
                    settings.customWallpaperPath != null
                        ? File(settings.customWallpaperPath!).uri.pathSegments.last
                        : 'Choose an image from your computer',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp'],
                          );
                          if (result != null && result.files.isNotEmpty) {
                            final path = result.files.single.path;
                            if (path != null) {
                              await ref.read(settingsProvider.notifier).setCustomWallpaper(path);
                            }
                          }
                        },
                        icon: const Icon(Icons.folder_open_rounded, size: 16),
                        label: Text(settings.customWallpaperPath != null ? 'Change' : 'Browse'),
                      ),
                      if (settings.customWallpaperPath != null) ...[
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            ref.read(settingsProvider.notifier).setCustomWallpaper(null);
                          },
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                          tooltip: 'Remove custom wallpaper',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: Privacy & Security
          _buildSectionHeader('PRIVACY & SECURITY'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.shield_outlined),
                  title: const Text('Send "Do Not Track" Request'),
                  subtitle: const Text('Request websites not to track your browsing habits'),
                  value: settings.doNotTrack,
                  onChanged: (val) {
                    ref.read(settingsProvider.notifier).loadSettings();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                  title: const Text('Clear Browsing Data', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('History, cached files, and local session traces'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Clear Browsing Data?'),
                        content: const Text('This will delete all saved browsing history permanently from this device.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                            onPressed: () {
                              ref.read(historyProvider.notifier).clearAll();
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Browsing history cleared.')),
                              );
                            },
                            child: const Text('Clear Now'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: SHIKHAR AI Assistant
          _buildSectionHeader('SHIKHAR AI ASSISTANT'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.auto_awesome, color: ShikharColors.primary),
                  title: const Text('Enable SHIKHAR AI'),
                  subtitle: const Text('Integrated intelligent page summarizer and research assistant'),
                  value: settings.aiEnabled,
                  onChanged: (val) {
                    ref.read(settingsProvider.notifier).setAiEnabled(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.verified_user_outlined),
                  title: const Text('Webpage Analysis Consent'),
                  subtitle: const Text('Permit AI assistant to read current webpage text upon request'),
                  value: settings.aiConsent,
                  onChanged: (val) {
                    ref.read(settingsProvider.notifier).setAiConsent(val);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.model_training),
                  title: const Text('AI Model'),
                  subtitle: Text(settings.aiModel),
                  trailing: DropdownButton<String>(
                    value: settings.aiModel,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'gemini-1.5-flash', child: Text('Gemini 1.5 Flash (Fast)')),
                      DropdownMenuItem(value: 'gemini-1.5-pro', child: Text('Gemini 1.5 Pro (Deep)')),
                    ],
                    onChanged: (model) {
                      if (model != null) {
                        ref.read(settingsProvider.notifier).setAiModel(model);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.key, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            settings.hasApiKey ? 'API Key Configured (Encrypted)' : 'Set AI API Key',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _apiKeyController,
                              obscureText: _apiKeyObscured,
                              decoration: InputDecoration(
                                hintText: 'Enter API Key securely...',
                                isDense: true,
                                suffixIcon: IconButton(
                                  icon: Icon(_apiKeyObscured ? Icons.visibility : Icons.visibility_off, size: 18),
                                  onPressed: () => setState(() => _apiKeyObscured = !_apiKeyObscured),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveApiKey,
                            style: ElevatedButton.styleFrom(backgroundColor: ShikharColors.primary, foregroundColor: Colors.white),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Clear AI Conversation History'),
                  onTap: () {
                    ref.read(aiAssistantProvider.notifier).clearHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('AI conversation history cleared.')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section: About SHIKHAR
          _buildSectionHeader('ABOUT SHIKHAR'),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const ShikharLogo(size: 48),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            BrandConstants.appName,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            BrandConstants.tagline,
                            style: const TextStyle(fontSize: 12, color: ShikharColors.accent, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Version ${BrandConstants.appVersion} (${BrandConstants.buildNumber})',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.explore_outlined),
                  title: const Text('View Welcome Tour & Features'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPolicyDialog('Privacy Policy', BrandConstants.privacyPolicyText),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Use'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPolicyDialog('Terms of Use', BrandConstants.termsOfUseText),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: ShikharColors.accent,
        ),
      ),
    );
  }
}
