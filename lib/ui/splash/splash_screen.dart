import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../core/branding/shikhar_logo.dart';
import '../../core/theme/shikhar_colors.dart';
import '../browser/browser_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasNavigated = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  Timer? _safetyTimeoutTimer;

  String _getVideoAssetPath() {
    final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    return isDesktop
        ? 'assets/videos/shikhar_desktop_intro.mp4'
        : 'assets/videos/shikhar_mobile_intro.mp4';
  }

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.asset(_getVideoAssetPath());
      _videoController = controller;

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      // Audio enabled by default at full volume
      await controller.setVolume(1.0);
      await controller.setLooping(false);

      controller.addListener(_videoListener);

      setState(() {
        _isVideoInitialized = true;
      });

      await controller.play();

      // Automatically transitions only when the full video finishes
      final duration = controller.value.duration;
      final safetyDuration = duration.inMilliseconds > 0
          ? duration + const Duration(milliseconds: 600)
          : const Duration(seconds: 8);

      _safetyTimeoutTimer = Timer(safetyDuration, () {
        if (mounted && !_hasNavigated) {
          _proceedToNext();
        }
      });
    } catch (_) {
      // Fallback for headless tests or platforms without video codecs
      if (mounted) {
        _safetyTimeoutTimer = Timer(const Duration(milliseconds: 2500), () {
          if (mounted && !_hasNavigated) {
            _proceedToNext();
          }
        });
      }
    }
  }

  void _videoListener() {
    final controller = _videoController;
    if (controller == null || !mounted || _hasNavigated) return;

    final value = controller.value;
    if (value.isInitialized && value.duration > Duration.zero) {
      if (value.position >= value.duration) {
        _proceedToNext();
      }
    }
  }

  Future<void> _proceedToNext() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    _safetyTimeoutTimer?.cancel();

    // Immediately stop audio & video playback
    if (_videoController != null) {
      try {
        await _videoController!.setVolume(0.0);
        await _videoController!.pause();
      } catch (_) {}
    }

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('shikhar_has_seen_onboarding') ?? false;

    if (!mounted) return;

    final Widget targetScreen = hasSeenOnboarding ? const BrowserScreen() : const OnboardingScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, anim, secondaryAnimation, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _safetyTimeoutTimer?.cancel();
    _animController.dispose();
    if (_videoController != null) {
      _videoController!.removeListener(_videoListener);
      _videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // True Edge-to-Edge Full-Screen Video (No skipping allowed)
            if (_isVideoInitialized && _videoController != null)
              _buildFullScreenVideo(_videoController!)
            else
              _buildFallbackLogo(),

            // Company Credit Overlay
            _buildOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenVideo(VideoPlayerController controller) {
    final size = controller.value.size;
    final width = size.width > 0 ? size.width : 1080.0;
    final height = size.height > 0 ? size.height : 1920.0;

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        child: SizedBox(
          width: width,
          height: height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.1),
          radius: 1.25,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF101827),
            Color(0xFF070B12),
          ],
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShikharLogo(size: 100, useImage: true, showText: false),
              SizedBox(height: 24),
              Text(
                'SHIKHAR',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.5,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: ShikharColors.accent, blurRadius: 18),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'YOUR WORLD. YOUR WEB.',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.5,
                  color: Color(0xFF93C5FD),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            const Spacer(),

            // Company Credit Badge
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ShikharColors.accent.withValues(alpha: 0.45),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ShikharColors.accent.withValues(alpha: 0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.code_rounded, size: 14, color: ShikharColors.accent),
                    const SizedBox(width: 8),
                    Text(
                      'DEVELOPED BY ZAYA CODE HUB',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
