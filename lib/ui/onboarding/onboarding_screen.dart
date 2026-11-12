import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/branding/shikhar_logo.dart';
import '../../core/theme/shikhar_colors.dart';
import '../../state/settings_notifier.dart';
import '../browser/browser_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shikhar_has_seen_onboarding', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => const BrowserScreen(),
        transitionsBuilder: (context, anim, secondaryAnimation, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: isDark ? ShikharColors.darkBackground : ShikharColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < 3)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  // Page 1: Welcome & Speed
                  _buildPage(
                    visual: const ShikharLogo(
                      size: 130,
                      useImage: true,
                      showText: false,
                    ),
                    tagline: 'YOUR WORLD. YOUR WEB.',
                    title: 'Welcome to SHIKHAR',
                    description:
                        'A high-performance, original web browser built on native Chromium engines for Android and Windows. Crisp, clean, and blazingly fast.',
                    isDark: isDark,
                  ),

                  // Page 2: Local-First Privacy
                  _buildPage(
                    visual: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.shield_rounded, size: 60, color: Colors.white),
                    ),
                    tagline: 'PRIVACY BY ARCHITECTURE',
                    title: 'Local-First & Independent',
                    description:
                        'Your bookmarks, history, and downloads stay strictly on your device in secure SQLite storage. Zero mandatory accounts, zero remote telemetry.',
                    isDark: isDark,
                  ),

                  // Page 3: SHIKHAR AI Assistant
                  _buildPage(
                    visual: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: ShikharColors.brandGradient,
                        boxShadow: [
                          BoxShadow(
                            color: ShikharColors.accent.withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, size: 56, color: Colors.white),
                    ),
                    tagline: 'SMART BROWSING',
                    title: 'Built-in SHIKHAR AI',
                    description:
                        'Instant page summarization, simplified technical explanations, and contextual answers with explicit user consent and privacy controls.',
                    isDark: isDark,
                  ),

                  // Page 4: Personalization
                  _buildPersonalizationPage(
                    isDark: isDark,
                    settings: settings,
                  ),
                ],
              ),
            ),

            // Bottom Navigation & Progress Dots
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicators
                  Row(
                    children: List.generate(4, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 8),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? ShikharColors.primary
                              : (isDark ? Colors.white24 : Colors.black12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Action Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ShikharColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == 3 ? 'Get Started' : 'Next',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required Widget visual,
    required String tagline,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          visual,
          const SizedBox(height: 36),
          Text(
            tagline,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.0,
              color: ShikharColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? ShikharColors.textPrimaryDark : ShikharColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark ? ShikharColors.textSecondaryDark : ShikharColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizationPage({
    required bool isDark,
    required SettingsState settings,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const Icon(Icons.tune_rounded, size: 54, color: ShikharColors.primary),
          const SizedBox(height: 16),
          const Text(
            'QUICK CUSTOMIZATION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: ShikharColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make It Truly Yours',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? ShikharColors.textPrimaryDark : ShikharColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 24),

          // Search Engine Selector
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Preferred Search Engine',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: settings.searchEngines.map((engine) {
              final isSelected = settings.searchEngine.id == engine.id;
              return ChoiceChip(
                label: Text(engine.name),
                selected: isSelected,
                selectedColor: ShikharColors.primary.withValues(alpha: 0.15),
                onSelected: (val) {
                  if (val) {
                    ref.read(settingsProvider.notifier).setDefaultSearchEngine(engine.id);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Theme Selector
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Interface Theme',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildThemeOption(
                title: 'System',
                icon: Icons.brightness_auto,
                isSelected: settings.themeMode == ThemeMode.system,
                onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.system),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildThemeOption(
                title: 'Light',
                icon: Icons.light_mode,
                isSelected: settings.themeMode == ThemeMode.light,
                onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildThemeOption(
                title: 'Dark',
                icon: Icons.dark_mode,
                isSelected: settings.themeMode == ThemeMode.dark,
                onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? ShikharColors.primary.withValues(alpha: 0.12)
                : (isDark ? ShikharColors.darkSurface : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? ShikharColors.primary : (isDark ? ShikharColors.darkBorder : ShikharColors.lightBorder),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? ShikharColors.primary : (isDark ? Colors.white70 : Colors.black54)),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? ShikharColors.primary : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
