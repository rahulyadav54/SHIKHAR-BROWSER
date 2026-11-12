import 'package:flutter/material.dart';

class ShikharColors {
  ShikharColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF2457A7);
  static const Color secondary = Color(0xFF173B72);
  static const Color accent = Color(0xFF5B8DEF);

  // Background & Surface
  static const Color lightBackground = Color(0xFFF5F7FB);
  static const Color darkBackground = Color(0xFF101827);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF162032);

  // Borders & Dividers
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color darkBorder = Color(0xFF334155);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Security & Indicators
  static const Color secureGreen = Color(0xFF10B981);
  static const Color insecureRed = Color(0xFFEF4444);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color privatePurple = Color(0xFF8B5CF6);
  static const Color privateDarkBg = Color(0xFF13111C);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient privateGradient = LinearGradient(
    colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

