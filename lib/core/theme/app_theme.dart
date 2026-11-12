import 'package:flutter/material.dart';
import 'shikhar_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ShikharColors.primary,
        onPrimary: Colors.white,
        secondary: ShikharColors.secondary,
        onSecondary: Colors.white,
        tertiary: ShikharColors.accent,
        surface: ShikharColors.lightSurface,
        onSurface: ShikharColors.textPrimaryLight,
        outline: ShikharColors.lightBorder,
      ),
      scaffoldBackgroundColor: ShikharColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: ShikharColors.lightSurface,
        foregroundColor: ShikharColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: ShikharColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: ShikharColors.lightBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ShikharColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShikharColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShikharColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShikharColors.primary, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ShikharColors.accent,
        onPrimary: Colors.white,
        secondary: ShikharColors.secondary,
        onSecondary: Colors.white,
        tertiary: ShikharColors.accent,
        surface: ShikharColors.darkSurface,
        onSurface: ShikharColors.textPrimaryDark,
        outline: ShikharColors.darkBorder,
      ),
      scaffoldBackgroundColor: ShikharColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: ShikharColors.darkSurface,
        foregroundColor: ShikharColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: ShikharColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: ShikharColors.darkBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ShikharColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ShikharColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShikharColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShikharColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ShikharColors.accent, width: 1.5),
        ),
      ),
    );
  }
}
