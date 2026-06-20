import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Global text styles to maintain typographic scale and aesthetic consistency.
class AppTextStyles {
  // Headings
  static const TextStyle displayHeader = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle subSectionHeader = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body & Product text
  static const TextStyle bodyPrimary = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
    height: 1.3,
  );

  // Product specific styles
  static const TextStyle productTitle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.1,
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: -0.2,
  );

  static const TextStyle productOriginalPrice = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );

  // Small labels / Badges / Chips
  static const TextStyle chipLabel = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.2,
  );

  static const TextStyle chipLabelSelected = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  static const TextStyle ratingText = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle ratingCountText = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
}
