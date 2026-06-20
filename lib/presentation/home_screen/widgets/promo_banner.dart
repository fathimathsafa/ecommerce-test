import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../product_details/view/product_details_screen.dart';
import '../controller/home_controller.dart';
import '../model/product_model.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _localPage = 0;

  final List<LinearGradient> _gradients = const [
    LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFEC4899), Color(0xFFD946EF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final homeController = context.read<HomeController>();
        final promoProducts = homeController.promoProducts;
        if (promoProducts.isNotEmpty) {
          final nextPage = (_localPage + 1) % promoProducts.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final promoProducts = homeController.promoProducts;

    if (promoProducts.isEmpty) {
      return Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _localPage = index;
              });
              homeController.updatePromoIndex(index);
            },
            itemCount: promoProducts.length,
            itemBuilder: (context, index) {
              final product = promoProducts[index];
              final gradient = _gradients[index % _gradients.length];
              final catName = product.category != null
                  ? categoryValues.reverse[product.category] ?? ''
                  : '';
              final capitalizedCat = catName.isNotEmpty
                  ? catName[0].toUpperCase() + catName.substring(1)
                  : 'HOT DEAL';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product: product),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 12.0,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Decorative design accents in the background (geometric circles)
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: -40,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      // Banner Content
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      capitalizedCat.toUpperCase(),
                                      style: AppTextStyles.chipLabelSelected.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.title ?? '',
                                    style: AppTextStyles.sectionHeader.copyWith(
                                      color: AppColors.textWhite,
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(product.discountPercentage ?? 0).round()}% OFF! Grab it now.',
                                    style: AppTextStyles.bodyPrimary.copyWith(
                                      color: AppColors.textWhite.withValues(alpha: 0.85),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgCard,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'Shop now • \$${(product.price ?? 0.0).toStringAsFixed(2)}',
                                      style: AppTextStyles.chipLabel.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.thumbnail ?? '',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promoProducts.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 6.0,
              width: _localPage == index ? 18.0 : 6.0,
              decoration: BoxDecoration(
                color: _localPage == index
                    ? AppColors.primary
                    : AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
