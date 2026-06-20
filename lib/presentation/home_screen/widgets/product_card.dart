import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product.dart';
import '../../wishlist/controller/wishlist_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onWishlistTap;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onWishlistTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            AspectRatio(
              aspectRatio: 1.1,
              child: Stack(
                children: [
                  // Image with loading & error fallbacks
                  Positioned.fill(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.bgSearch,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback container when offline or link is broken
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: AppColors.textMuted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Discount Badge
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.wishlist,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.discountPercentage}% OFF',
                          style: AppTextStyles.chipLabelSelected.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Wishlist Icon Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ClipOval(
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        child: ListenableBuilder(
                          listenable: WishlistController.instance,
                          builder: (context, _) {
                            final isWishlisted = WishlistController.instance.isWishlisted(product.id);
                            return InkWell(
                              onTap: onWishlistTap,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  isWishlisted 
                                      ? Icons.favorite_rounded 
                                      : Icons.favorite_border_rounded,
                                  color: isWishlisted 
                                      ? AppColors.wishlist 
                                      : AppColors.wishlistInactive,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Rating Badge Overlay
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.rating,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: AppTextStyles.ratingText.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.reviewCount})',
                            style: AppTextStyles.ratingCountText.copyWith(
                              color: Colors.white70,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags Row (SingleChildScrollView with Row to prevent vertical overflow)
                    if (product.tags.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: product.tags.map((tag) {
                            return Container(
                              margin: const EdgeInsets.only(right: 4.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.chipLabel.copyWith(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],

                    // Product Name (Expanded to take remaining height safely)
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTextStyles.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Price Section & Buy Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.originalPrice != null && 
                                product.originalPrice! > product.price) ...[
                              Text(
                                '\$${product.originalPrice!.toStringAsFixed(2)}',
                                style: AppTextStyles.productOriginalPrice,
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.productPrice,
                            ),
                          ],
                        ),
                        // Add Button
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
