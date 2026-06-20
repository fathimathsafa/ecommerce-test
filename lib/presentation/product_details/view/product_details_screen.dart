import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product.dart';
import '../../cart/controller/cart_controller.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../controller/product_details_controller.dart';
import '../widgets/color_selector.dart';
import '../widgets/size_selector.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final ProductDetailsController _detailsController = ProductDetailsController();

  ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistController = WishlistController.instance;
    final cartController = CartController.instance;

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          // Scrolling Details Layout
          CustomScrollView(
            slivers: [
              // Product Hero Image section
              SliverAppBar(
                expandedHeight: 340.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.only(left: 16, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: ListenableBuilder(
                      listenable: wishlistController,
                      builder: (context, _) {
                        final isFavorite = wishlistController.isWishlisted(product.id);
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? AppColors.wishlist : AppColors.wishlistInactive,
                          ),
                          onPressed: () => wishlistController.toggleWishlist(product.id),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_image_${product.id}',
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.bgSearch,
                        child: const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                ),
              ),

              // Product Info Block
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags and Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: AppTextStyles.chipLabel.copyWith(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Rating Badge
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.rating, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toString(),
                                style: AppTextStyles.ratingText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.reviewCount} Reviews)',
                                style: AppTextStyles.ratingCountText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Product Title
                      Text(
                        product.name,
                        style: AppTextStyles.displayHeader.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 12),

                      // Prices
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.productPrice.copyWith(fontSize: 24),
                          ),
                          if (product.originalPrice != null && product.originalPrice! > product.price) ...[
                            const SizedBox(width: 10),
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: AppTextStyles.productOriginalPrice.copyWith(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${product.discountPercentage}% OFF',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.wishlist,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 32, color: AppColors.borderLight),

                      // Description
                      const Text(
                        'About Product',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: AppTextStyles.bodySecondary.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Selection Section (Size & Color)
                      ListenableBuilder(
                        listenable: _detailsController,
                        builder: (context, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizeSelector(
                                sizes: _detailsController.sizes,
                                selectedSize: _detailsController.selectedSize,
                                onSizeSelected: _detailsController.setSize,
                              ),
                              const SizedBox(height: 24),
                              ColorSelector(
                                colors: _detailsController.colors,
                                selectedColorIndex: _detailsController.selectedColorIndex,
                                onColorSelected: _detailsController.setColorIndex,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 100), // Spacing for bottom floating bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Pinned Bottom Checkout Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        cartController.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            action: SnackBarAction(
                              label: 'View Cart',
                              textColor: Colors.white,
                              onPressed: () {
                                // Close SnackBar and trigger route
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                // Navigate to cart
                                Navigator.pushNamed(context, '/cart');
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.primary),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.addToCart(product);
                        Navigator.pushNamed(context, '/cart');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
