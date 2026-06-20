import 'package:flutter/material.dart';

/// Global application colors designed for a premium, clean, and modern
/// e-commerce look-and-feel.
class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4F46E5);      // Indigo 600
  static const Color primaryDark = Color(0xFF3730A3);  // Indigo 800
  static const Color primaryLight = Color(0xFFEEF2FF); // Indigo 50
  
  // Accent & Action Colors
  static const Color accent = Color(0xFF10B981);       // Emerald 500 (Clean, trustworthy)
  static const Color accentLight = Color(0xFFECFDF5);  // Emerald 50
  static const Color rating = Color(0xFFF59E0B);       // Amber 500 (Star ratings)
  static const Color ratingLight = Color(0xFFFEF3C7);  // Amber 50
  static const Color wishlist = Color(0xFFEF4444);     // Red 500 (Active state)
  static const Color wishlistInactive = Color(0xFF94A3B8); // Slate 400

  // Backgrounds & Surfaces
  static const Color bgMain = Color(0xFFF8FAFC);       // Slate 50 (Very clean off-white)
  static const Color bgCard = Color(0xFFFFFFFF);       // Pure White
  static const Color bgSearch = Color(0xFFF1F5F9);     // Slate 100

  // Typography & Neutrals
  static const Color textPrimary = Color(0xFF0F172A);  // Slate 900 (High contrast readability)
  static const Color textSecondary = Color(0xFF64748B);// Slate 500 (Sub-labels, metadata)
  static const Color textMuted = Color(0xFF94A3B8);    // Slate 400 (Hints, disabled states)
  static const Color textWhite = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFE2E8F0);  // Slate 200 (Clean subtle borders)
  static const Color shadowColor = Color(0x0A0F172A);  // Slate 900 with ~4% opacity for soft shadows

  // Gradients for promo banners or primary highlights
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF6366F1)], // Indigo 600 to Indigo 500
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient tagGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)], // Purple to Pink
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
