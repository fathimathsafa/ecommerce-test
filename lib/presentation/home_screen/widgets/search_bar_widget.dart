import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.hintText = 'Search products, tags, categories...',
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTextStyles.bodyPrimary,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMuted.copyWith(fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            Container(
              height: 36,
              width: 1,
              color: AppColors.borderLight,
            ),
            IconButton(
              onPressed: onFilterTap,
              icon: const Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              splashRadius: 24,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
