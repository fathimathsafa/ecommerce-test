import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Global text styles to maintain typographic scale and aesthetic consistency.
class AppTextStyles {
  // Headings
  static TextStyle get displayHeader => TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get sectionHeader => TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle get subSectionHeader => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body & Product text
  static TextStyle get bodyPrimary => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get bodySecondary => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get bodyMuted => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
    height: 1.3,
  );

  // Product specific styles
  static TextStyle get productTitle => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.1,
  );

  static TextStyle get productPrice => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: -0.2,
  );

  static TextStyle get productOriginalPrice => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );

  // Small labels / Badges / Chips
  static TextStyle get chipLabel => TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.2,
  );

  static TextStyle get chipLabelSelected => TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  static TextStyle get ratingText => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get ratingCountText => TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button text
  static TextStyle get buttonLarge => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
}
