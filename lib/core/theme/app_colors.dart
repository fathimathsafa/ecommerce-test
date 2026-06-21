import 'package:flutter/material.dart';
import 'theme_controller.dart';

/// Global application colors designed for a premium, clean, and modern
/// e-commerce look-and-feel. Dynamic dark mode is supported.
class AppColors {
  static bool get isDark => ThemeController.isDark;

  // Brand Colors
  static Color get primary => isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);      // Indigo 400 vs 600
  static Color get primaryDark => isDark ? const Color(0xFF4F46E5) : const Color(0xFF3730A3);
  static Color get primaryLight => isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF);
  
  // Accent & Action Colors
  static Color get accent => isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);       // Emerald 400 vs 500
  static Color get accentLight => isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5);
  static Color get rating => const Color(0xFFF59E0B);       // Amber 500
  static Color get ratingLight => isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);
  static Color get wishlist => isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);     // Red 400 vs 500
  static Color get wishlistInactive => isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);

  // Backgrounds & Surfaces
  static Color get bgMain => isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);       // Slate 900 vs 50
  static Color get bgCard => isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);       // Slate 800 vs Pure White
  static Color get bgSearch => isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);     // Slate 700 vs Slate 100

  // Typography & Neutrals
  static Color get textPrimary => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);  // Slate 50 vs 900
  static Color get textSecondary => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);// Slate 400 vs 500
  static Color get textMuted => isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);    // Slate 500 vs 400
  static Color get textWhite => const Color(0xFFFFFFFF);

  // Borders & Dividers
  static Color get borderLight => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);  // Slate 700 vs 200
  static Color get shadowColor => isDark ? const Color(0x3B000000) : const Color(0x0A0F172A);

  // Gradients for promo banners or primary highlights
  static Gradient get primaryGradient => LinearGradient(
    colors: isDark 
        ? [const Color(0xFF818CF8), const Color(0xFF4F46E5)] 
        : [const Color(0xFF4F46E5), const Color(0xFF6366F1)], // Indigo 600 to Indigo 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient get tagGradient => const LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)], // Purple to Pink
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
