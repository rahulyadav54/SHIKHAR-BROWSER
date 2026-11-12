import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shikhar_browser/ui/onboarding/onboarding_screen.dart';
import 'package:shikhar_browser/ui/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders brand title and tagline cursor', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    expect(find.text('SHIKHAR'), findsOneWidget);
    expect(find.text('DEVELOPED BY ZAYA CODE HUB'), findsOneWidget);

    // Let the splash screen timer complete naturally without skipping
    await tester.pump(const Duration(milliseconds: 2700));
    await tester.pumpAndSettle();
  });

  testWidgets('OnboardingScreen displays walkthrough cards and navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to SHIKHAR'), findsOneWidget);
    expect(find.text('YOUR WORLD. YOUR WEB.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Tap next to go to page 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Local-First & Independent'), findsOneWidget);
    expect(find.text('PRIVACY BY ARCHITECTURE'), findsOneWidget);
  });
}
