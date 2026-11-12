import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shikhar_browser/core/branding/shikhar_logo.dart';
import 'package:shikhar_browser/ui/home/shikhar_home_page.dart';

void main() {
  testWidgets('SHIKHAR Logo renders brand title and mountain emblem', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShikharLogo(
            size: 64,
            showText: true,
          ),
        ),
      ),
    );

    expect(find.text('SHIKHAR'), findsOneWidget);
    expect(find.text('BROWSER'), findsOneWidget);
    expect(find.byType(ShikharLogo), findsOneWidget);
  });

  testWidgets('ShikharHomePage displays search bar and quick shortcuts', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ShikharHomePage(),
          ),
        ),
      ),
    );

    expect(find.text('YOUR WORLD. YOUR WEB.'), findsOneWidget);
    expect(find.text('Search the web or type a URL...'), findsOneWidget);
    expect(find.text('QUICK ACCESS'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Wikipedia'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
  });
}
