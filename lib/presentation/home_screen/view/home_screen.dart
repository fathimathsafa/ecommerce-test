import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/view/cart_screen.dart';
import '../../product_details/view/product_details_screen.dart';
import '../controller/home_controller.dart';
import '../widgets/category_selector.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';

/// The primary E-commerce Home / Product Listing Screen.
/// Built as a [StatelessWidget] for purity, routing state management to [HomeController].
class HomeScreen extends StatelessWidget {
  final HomeController _controller = HomeController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: _buildAppBar(context),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return RefreshIndicator(
            onRefresh: _controller.refreshProducts,
            color: AppColors.primary,
            backgroundColor: AppColors.bgCard,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header text & Search section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Find Your Best Fit',
                          style: AppTextStyles.displayHeader,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Explore premium collections curated just for you.',
                          style: AppTextStyles.bodySecondary,
                        ),
                        const SizedBox(height: 16),
                        SearchBarWidget(
                          onChanged: _controller.updateSearchQuery,
                          onFilterTap: () {
                            // Bottom sheet filter or dialog action
                            _showFilterBottomSheet(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Promo Banners Section
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: PromoBanner(),
                  ),
                ),

                // Categories Header & Chip selector
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Categories',
                                style: AppTextStyles.sectionHeader,
                              ),
                              TextButton(
                                onPressed: () => _controller.selectCategory('All'),
                                child: Text(
                                  'See All',
                                  style: AppTextStyles.chipLabel.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        CategorySelector(
                          categories: _controller.categories,
                          selectedCategory: _controller.selectedCategory,
                          onCategorySelected: _controller.selectCategory,
                        ),
                      ],
                    ),
                  ),
                ),

                // Product grid title / items count
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Products',
                          style: AppTextStyles.subSectionHeader,
                        ),
                        if (!_controller.isLoading)
                          Text(
                            '${_controller.products.length} items found',
                            style: AppTextStyles.bodyMuted,
                          ),
                      ],
                    ),
                  ),
                ),

                // Loading, Empty, or Product Grid Layout
                _buildProductSection(),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// App Bar builder for a cleaner root build method
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final cartController = CartController.instance;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.grid_view_rounded, color: AppColors.textPrimary),
        onPressed: () {},
      ),
      actions: [
        ListenableBuilder(
          listenable: cartController,
          builder: (context, _) {
            final count = cartController.itemCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                ),
                if (count > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=60',
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  /// Grid viewport logic based on state (Loading, Empty, Data)
  Widget _buildProductSection() {
    if (_controller.isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.58,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildShimmerCard(),
            childCount: 4,
          ),
        ),
      );
    }

    if (_controller.products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Products Found',
                style: AppTextStyles.subSectionHeader,
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching for something else or clear the selected filters.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _controller.selectCategory('All');
                  _controller.updateSearchQuery('');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Reset Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = _controller.products[index];
            return ProductCard(
              product: product,
              onWishlistTap: () => _controller.toggleWishlist(product.id),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product: product),
                  ),
                );
              },
            );
          },
          childCount: _controller.products.length,
        ),
      ),
    );
  }

  /// Shimmer loading placeholder for the grid
  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgSearch.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.bgSearch.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.bgSearch,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.bgSearch,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.bgSearch,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Show standard filters sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Filter Options', style: AppTextStyles.sectionHeader),
              const SizedBox(height: 16),
              const Text('Sort By', style: AppTextStyles.subSectionHeader),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('Relevance', true),
                  _buildFilterChip('Price: Low to High', false),
                  _buildFilterChip('Price: High to Low', false),
                  _buildFilterChip('Customer Rating', false),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: AppColors.bgMain,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
        ),
      ),
    );
  }
}
