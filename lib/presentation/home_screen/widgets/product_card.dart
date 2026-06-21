import 'package:ewire/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../product_details/view/product_details_screen.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../../cart/controller/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onWishlistTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = context.watch<WishlistController>();
    final isWishlisted = wishlistController.isWishlisted(product.id);

    final double currentPrice = product.price ?? 0.0;
    final double discount = product.discountPercentage ?? 0.0;
    final bool hasDiscount = discount > 0;
    
    final double originalPrice = hasDiscount 
        ? currentPrice / (1 - (discount / 100)) 
        : currentPrice;

    final reviewCount = product.reviews?.length ?? 0;
    final tags = product.tags ?? [];

    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.thumbnail ?? (product.images != null && product.images!.isNotEmpty ? product.images!.first : ''),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.bgSearch,
                          child: Center(
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
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
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

                  if (hasDiscount)
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
                          '${discount.round()}% OFF',
                          style: AppTextStyles.chipLabelSelected.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: ClipOval(
                      child: Material(
                        color: AppColors.bgCard.withValues(alpha: 0.9),
                        child: InkWell(
                          onTap: onWishlistTap ?? () {
                            context.read<WishlistController>().toggleWishlist(product.id);
                          },
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
                        ),
                      ),
                    ),
                  ),

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
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.rating,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            (product.rating ?? 0.0).toStringAsFixed(1),
                            style: AppTextStyles.ratingText.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '($reviewCount)',
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tags.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: tags.map((tag) {
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

                    Expanded(
                      child: Text(
                        product.title ?? '',
                        style: AppTextStyles.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hasDiscount) ...[
                              Text(
                                '\$${originalPrice.toStringAsFixed(2)}',
                                style: AppTextStyles.productOriginalPrice,
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              '\$${currentPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.productPrice,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CartController>().addToCart(product);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart!'),
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
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
