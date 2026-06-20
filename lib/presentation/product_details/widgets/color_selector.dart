import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedColorIndex;
  final ValueChanged<int> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Color',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(colors.length, (index) {
            final isSelected = index == selectedColorIndex;
            final color = colors[index];

            return GestureDetector(
              onTap: () => onColorSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 14.0),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? color.withValues(alpha: 0.4) : AppColors.shadowColor,
                      blurRadius: isSelected ? 8 : 4,
                      spreadRadius: isSelected ? 2 : 0,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
