import 'package:ewire/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../cart/controller/cart_controller.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../controller/product_details_controller.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailsController(),
      child: Builder(
        builder: (context) {
          context.watch<ThemeController>(); 
          final wishlistController = context.watch<WishlistController>();
          final cartController = context.read<CartController>();
          final detailsController = context.watch<ProductDetailsController>();

          final isFavorite = wishlistController.isWishlisted(product.id);
          final reviewCount = product.reviews?.length ?? 0;
          
          final catName = product.category != null 
              ? categoryValues.reverse[product.category] ?? '' 
              : '';
          final stockStatus = product.availabilityStatus != null 
              ? availabilityStatusValues.reverse[product.availabilityStatus] ?? '' 
              : '';
          final returnPolicy = product.returnPolicy != null 
              ? returnPolicyValues.reverse[product.returnPolicy] ?? '' 
              : '';

          final double currentPrice = product.price ?? 0.0;
          final double discount = product.discountPercentage ?? 0.0;
          final bool hasDiscount = discount > 0;
          
          final double originalPrice = hasDiscount 
              ? currentPrice / (1 - (discount / 100)) 
              : currentPrice;

          final images = product.images ?? [];
          final displayImages = images.isNotEmpty ? images : [product.thumbnail ?? ''];

          return Scaffold(
            backgroundColor: AppColors.bgMain,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 360.0,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      leading: Container(
                        margin: const EdgeInsets.only(left: 16, top: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(right: 16, top: 8),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFavorite ? AppColors.wishlist : AppColors.wishlistInactive,
                            ),
                            onPressed: () => wishlistController.toggleWishlist(product.id),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            Positioned.fill(
                              child: Hero(
                                tag: 'product_image_${product.id}',
                                child: PageView.builder(
                                  controller: detailsController.imagePageController,
                                  onPageChanged: detailsController.updateImageIndex,
                                  itemCount: displayImages.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      displayImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: AppColors.bgSearch,
                                        child: Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.textMuted),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            if (displayImages.length > 1)
                              Positioned(
                                bottom: 24,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    displayImages.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                      width: detailsController.currentImageIndex == index ? 14.0 : 6.0,
                                      height: 6.0,
                                      decoration: BoxDecoration(
                                        color: detailsController.currentImageIndex == index 
                                            ? AppColors.primary 
                                            : Colors.white.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(3.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (catName.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      catName.toUpperCase(),
                                      style: AppTextStyles.chipLabel.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                
                                if (stockStatus.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: stockStatus.toLowerCase().contains('low') 
                                          ? AppColors.ratingLight 
                                          : AppColors.accentLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      stockStatus.toUpperCase(),
                                      style: AppTextStyles.chipLabel.copyWith(
                                        color: stockStatus.toLowerCase().contains('low') 
                                            ? AppColors.rating 
                                            : AppColors.accent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            if (product.brand != null && product.brand!.isNotEmpty)
                              Text(
                                product.brand!,
                                style: AppTextStyles.bodySecondary.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  letterSpacing: 1.0,
                                ),
                              ),

                            const SizedBox(height: 4),
                            Text(
                              product.title ?? '',
                              style: AppTextStyles.displayHeader.copyWith(fontSize: 22),
                            ),
                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 16,
                                runSpacing: 12,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${currentPrice.toStringAsFixed(2)}',
                                        style: AppTextStyles.productPrice.copyWith(fontSize: 24),
                                      ),
                                      if (hasDiscount) ...[
                                        const SizedBox(width: 10),
                                        Text(
                                          '\$${originalPrice.toStringAsFixed(2)}',
                                          style: AppTextStyles.productOriginalPrice.copyWith(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${discount.round()}% OFF',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.wishlist,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star_rounded, color: AppColors.rating, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        (product.rating ?? 0.0).toStringAsFixed(1),
                                        style: AppTextStyles.ratingText,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '($reviewCount Reviews)',
                                        style: AppTextStyles.ratingCountText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 36, color: AppColors.borderLight),

                            Text(
                              'About Product',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description ?? '',
                              style: AppTextStyles.bodySecondary.copyWith(height: 1.5),
                            ),
                            const SizedBox(height: 24),

                            _buildSpecificationsSection(returnPolicy),
                            
                            Divider(height: 48, color: AppColors.borderLight),

                            _buildReviewsSection(product.reviews ?? []),

                            const SizedBox(height: 100), // Spacing for bottom floating bar
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              cartController.addToCart(product);
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
                            icon: Icon(Icons.add_shopping_cart_rounded, color: AppColors.primary),
                            label: Text(
                              'Add to Cart',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(color: AppColors.primary, width: 1.5),
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
        },
      ),
    );
  }

  Widget _buildSpecificationsSection(String returnPolicy) {
    final dimensions = product.dimensions;
    final dimString = dimensions != null
        ? '${dimensions.width ?? 0}w x ${dimensions.height ?? 0}h x ${dimensions.depth ?? 0}d cm'
        : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Specifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildSpecItem(Icons.qr_code_rounded, 'SKU', product.sku ?? 'N/A'),
            _buildSpecItem(Icons.fitness_center_rounded, 'Weight', product.weight != null ? '${product.weight}g' : 'N/A'),
            _buildSpecItem(Icons.aspect_ratio_rounded, 'Dimensions', dimString),
            _buildSpecItem(Icons.verified_user_outlined, 'Warranty', product.warrantyInformation ?? 'N/A'),
            _buildSpecItem(Icons.assignment_return_outlined, 'Returns', returnPolicy.isNotEmpty ? returnPolicy : 'No Return Policy'),
            _buildSpecItem(Icons.local_shipping_outlined, 'Shipping', product.shippingInformation ?? 'N/A'),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgMain,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(List<Review> reviews) {
    if (reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            'No reviews yet for this product.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        Column(
          children: reviews.map((review) {
            final date = review.date;
            final dateString = date != null
                ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                : 'N/A';

            final name = review.reviewerName ?? 'Anonymous';
            final initials = name.isNotEmpty
                ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                : 'A';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgMain,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateString,
                              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      // Rating stars
                      Row(
                        children: List.generate(5, (index) {
                          final rating = review.rating ?? 0;
                          return Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: index < rating ? AppColors.rating : AppColors.textMuted.withValues(alpha: 0.3),
                          );
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                     review.comment ?? '',
                    style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
