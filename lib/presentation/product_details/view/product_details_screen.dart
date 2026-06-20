import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../cart/controller/cart_controller.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../../home_screen/model/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistController = context.watch<WishlistController>();
    final cartController = context.read<CartController>();

    final isFavorite = wishlistController.isWishlisted(widget.product.id);
    final reviewCount = widget.product.reviews?.length ?? 0;
    
    final catName = widget.product.category != null 
        ? categoryValues.reverse[widget.product.category] ?? '' 
        : '';
    final stockStatus = widget.product.availabilityStatus != null 
        ? availabilityStatusValues.reverse[widget.product.availabilityStatus] ?? '' 
        : '';
    final returnPolicy = widget.product.returnPolicy != null 
        ? returnPolicyValues.reverse[widget.product.returnPolicy] ?? '' 
        : '';

    final double currentPrice = widget.product.price ?? 0.0;
    final double discount = widget.product.discountPercentage ?? 0.0;
    final bool hasDiscount = discount > 0;
    
    final double originalPrice = hasDiscount 
        ? currentPrice / (1 - (discount / 100)) 
        : currentPrice;

    final images = widget.product.images ?? [];
    final displayImages = images.isNotEmpty ? images : [widget.product.thumbnail ?? ''];

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          // Scrolling Details Layout
          CustomScrollView(
            slivers: [
              // Product Image Gallery carousel
              SliverAppBar(
                expandedHeight: 360.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
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
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? AppColors.wishlist : AppColors.wishlistInactive,
                      ),
                      onPressed: () => wishlistController.toggleWishlist(widget.product.id),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // PageView gallery
                      Positioned.fill(
                        child: Hero(
                          tag: 'product_image_${widget.product.id}',
                          child: PageView.builder(
                            controller: _imagePageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemCount: displayImages.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                displayImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.bgSearch,
                                  child: const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.textMuted),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      // Dots Indicator
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
                                width: _currentImageIndex == index ? 14.0 : 6.0,
                                height: 6.0,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == index 
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
                      // Category, Stock Status & Brand
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
                          
                          // Availability Status
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

                      // Brand Label
                      if (widget.product.brand != null && widget.product.brand!.isNotEmpty)
                        Text(
                          widget.product.brand!,
                          style: AppTextStyles.bodySecondary.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),

                      // Product Title
                      const SizedBox(height: 4),
                      Text(
                        widget.product.title ?? '',
                        style: AppTextStyles.displayHeader.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 12),

                      // Rating & Price
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
                                    style: const TextStyle(
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
                                const Icon(Icons.star_rounded, color: AppColors.rating, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  (widget.product.rating ?? 0.0).toStringAsFixed(1),
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
                      const Divider(height: 36, color: AppColors.borderLight),

                      // Description
                      const Text(
                        'About Product',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description ?? '',
                        style: AppTextStyles.bodySecondary.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 24),


                      // Specifications Grid Section
                      _buildSpecificationsSection(returnPolicy),
                      
                      const Divider(height: 48, color: AppColors.borderLight),

                      // Reviews Segment
                      _buildReviewsSection(widget.product.reviews ?? []),

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
                        cartController.addToCart(widget.product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.title} added to cart!'),
                            action: SnackBarAction(
                              label: 'View Cart',
                              onPressed: () {
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
                        cartController.addToCart(widget.product);
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

  /// Builds the structured Grid showing specifications
  Widget _buildSpecificationsSection(String returnPolicy) {
    final dimensions = widget.product.dimensions;
    final dimString = dimensions != null
        ? '${dimensions.width ?? 0}w x ${dimensions.height ?? 0}h x ${dimensions.depth ?? 0}d cm'
        : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
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
            _buildSpecItem(Icons.qr_code_rounded, 'SKU', widget.product.sku ?? 'N/A'),
            _buildSpecItem(Icons.fitness_center_rounded, 'Weight', widget.product.weight != null ? '${widget.product.weight}g' : 'N/A'),
            _buildSpecItem(Icons.aspect_ratio_rounded, 'Dimensions', dimString),
            _buildSpecItem(Icons.verified_user_outlined, 'Warranty', widget.product.warrantyInformation ?? 'N/A'),
            _buildSpecItem(Icons.assignment_return_outlined, 'Returns', returnPolicy.isNotEmpty ? returnPolicy : 'No Return Policy'),
            _buildSpecItem(Icons.local_shipping_outlined, 'Shipping', widget.product.shippingInformation ?? 'N/A'),
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
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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

  /// Builds customer reviews feed
  Widget _buildReviewsSection(List<Review> reviews) {
    if (reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Customer Reviews',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 12),
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
        const Text(
          'Customer Reviews',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        // Render each review comment card
        Column(
          children: reviews.map((review) {
            final date = review.date;
            final dateString = date != null
                ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                : 'N/A';

            // Get user initials for avatar representation
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
                          style: const TextStyle(
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
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateString,
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
                    style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
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
