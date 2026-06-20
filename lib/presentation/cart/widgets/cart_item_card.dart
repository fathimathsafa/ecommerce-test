import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: AppColors.bgSearch,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title & Remove button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTextStyles.productTitle.copyWith(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.wishlist, size: 20),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price and Quantity Adjuster Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.productPrice.copyWith(fontSize: 15),
                    ),

                    // Quantity controls
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgSearch,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 14, color: AppColors.textPrimary),
                            onPressed: () => onQuantityChanged(item.quantity - 1),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                          Text(
                            item.quantity.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 14, color: AppColors.textPrimary),
                            onPressed: () => onQuantityChanged(item.quantity + 1),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
