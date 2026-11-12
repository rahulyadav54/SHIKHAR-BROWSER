import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../state/settings_notifier.dart';

class ThemePresetItem {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final LinearGradient gradient;
  final bool isLight;

  const ThemePresetItem({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.gradient,
    this.isLight = false,
  });
}

class ThemeCustomizerSheet extends ConsumerWidget {
  const ThemeCustomizerSheet({super.key});

  static const List<ThemePresetItem> presets = [
    ThemePresetItem(
      id: 'default',
      name: 'Deep Navy (Classic)',
      primaryColor: Color(0xFF070D1D),
      secondaryColor: Color(0xFF101B35),
      accentColor: Color(0xFF26D9FF),
      gradient: LinearGradient(
        colors: [Color(0xFF070D1D), Color(0xFF101B35)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ThemePresetItem(
      id: 'light',
      name: 'Pristine Light',
      primaryColor: Color(0xFFF8FAFC),
      secondaryColor: Color(0xFFFFFFFF),
      accentColor: Color(0xFF0284C7),
      gradient: LinearGradient(
        colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      isLight: true,
    ),
    ThemePresetItem(
      id: 'dawn',
      name: 'Himalayan Dawn',
      primaryColor: Color(0xFF1A0B2E),
      secondaryColor: Color(0xFF3B1042),
      accentColor: Color(0xFFF59E0B),
      gradient: LinearGradient(
        colors: [Color(0xFF1A0B2E), Color(0xFF4A154B), Color(0xFFB45309)],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
      ),
    ),
    ThemePresetItem(
      id: 'cyberpunk',
      name: 'Cyberpunk Neon',
      primaryColor: Color(0xFF050814),
      secondaryColor: Color(0xFF0F172A),
      accentColor: Color(0xFF26D9FF),
      gradient: LinearGradient(
        colors: [Color(0xFF050814), Color(0xFF1E1B4B), Color(0xFF4C1D95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ThemePresetItem(
      id: 'cosmos',
      name: 'Deep Cosmos',
      primaryColor: Color(0xFF090514),
      secondaryColor: Color(0xFF1E1035),
      accentColor: Color(0xFFA855F7),
      gradient: LinearGradient(
        colors: [Color(0xFF090514), Color(0xFF2E1065), Color(0xFF0F172A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ThemePresetItem(
      id: 'forest',
      name: 'Emerald Forest',
      primaryColor: Color(0xFF021B1A),
      secondaryColor: Color(0xFF064E3B),
      accentColor: Color(0xFF10B981),
      gradient: LinearGradient(
        colors: [Color(0xFF021B1A), Color(0xFF064E3B), Color(0xFF022C22)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  static BoxDecoration getBackgroundDecoration({
    required String preset,
    String? customWallpaperPath,
    bool isDark = true,
  }) {
    if (preset == 'custom' && customWallpaperPath != null && customWallpaperPath.isNotEmpty) {
      final file = File(customWallpaperPath);
      if (file.existsSync()) {
        return BoxDecoration(
          image: DecorationImage(
            image: FileImage(file),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.38),
              BlendMode.darken,
            ),
          ),
        );
      }
    }

    final match = presets.firstWhere((p) => p.id == preset, orElse: () => presets.first);

    if (match.id == 'light') {
      return const BoxDecoration(
        color: Color(0xFFF8FAFC),
      );
    }

    return BoxDecoration(
      gradient: match.gradient,
    );
  }

  Future<void> _pickWallpaperFromPC(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null && path.isNotEmpty) {
          await ref.read(settingsProvider.notifier).setCustomWallpaper(path);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Custom wallpaper applied successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not load image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentPreset = settings.homeThemePreset;
    final customPath = settings.customWallpaperPath;
    final isCustomActive = currentPreset == 'custom' && customPath != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0E172C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF168BFF).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF26D9FF).withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.palette_rounded, color: Color(0xFF26D9FF), size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customize Theme & Wallpaper',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Choose a preset theme or upload an image from your PC',
                          style: TextStyle(fontSize: 11, color: Color(0xFFA7B5CC)),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Color(0xFFA7B5CC)),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section 1: Default Themes
            const Text(
              'DEFAULT THEMES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFF26D9FF),
              ),
            ),
            const SizedBox(height: 12),

            // Presets Grid
            SizedBox(
              height: 104,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: presets.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (ctx, idx) {
                  final p = presets[idx];
                  final isSelected = currentPreset == p.id;

                  return InkWell(
                    onTap: () {
                      ref.read(settingsProvider.notifier).setHomeThemePreset(p.id);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: p.gradient,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF26D9FF) : Colors.white.withValues(alpha: 0.12),
                          width: isSelected ? 2.5 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF168BFF).withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: p.accentColor,
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF26D9FF), size: 16),
                            ],
                          ),
                          Text(
                            p.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: p.isLight ? const Color(0xFF0F172A) : Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: Upload From PC
            const Text(
              'CUSTOM WALLPAPER FROM PC',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFF26D9FF),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF101B35).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCustomActive
                      ? const Color(0xFF26D9FF)
                      : Colors.white.withValues(alpha: 0.1),
                  width: isCustomActive ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF168BFF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: isCustomActive && File(customPath).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              File(customPath),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.add_photo_alternate_rounded, color: Color(0xFF26D9FF), size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCustomActive ? 'Active Custom Wallpaper' : 'Upload Image from Computer',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isCustomActive
                              ? File(customPath).uri.pathSegments.last
                              : 'Supports PNG, JPG, WEBP formats',
                          style: const TextStyle(fontSize: 11, color: Color(0xFFA7B5CC)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Upload Button
                  ElevatedButton.icon(
                    onPressed: () => _pickWallpaperFromPC(context, ref),
                    icon: const Icon(Icons.folder_open_rounded, size: 16),
                    label: Text(isCustomActive ? 'Change' : 'Upload from PC'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF168BFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Clear custom wallpaper button
                  if (isCustomActive) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () {
                        ref.read(settingsProvider.notifier).setCustomWallpaper(null);
                      },
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                      tooltip: 'Reset to default theme',
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
