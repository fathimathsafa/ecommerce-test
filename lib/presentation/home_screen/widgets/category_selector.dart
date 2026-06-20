import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.toLowerCase() == selectedCategory.toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          )
                        ],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: isSelected
                        ? AppTextStyles.chipLabelSelected
                        : AppTextStyles.chipLabel.copyWith(
                            color: AppColors.textSecondary,
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
