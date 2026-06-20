import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Size',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: sizes.map((size) {
            final isSelected = size == selectedSize;
            return GestureDetector(
              onTap: () => onSizeSelected(size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 12.0),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
