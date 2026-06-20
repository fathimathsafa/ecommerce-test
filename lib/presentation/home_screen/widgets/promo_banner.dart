import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _bannerData = [
    {
      'title': 'Summer Tech Sale',
      'subtitle': 'Up to 50% OFF on Audio Gear',
      'tag': 'LIMIT TIME',
      'gradient': const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'actionText': 'Shop Audio',
      'icon': Icons.headphones_rounded,
    },
    {
      'title': 'New FlexSole Run',
      'subtitle': 'Perform at your absolute best',
      'tag': 'NEW RELEASE',
      'gradient': const LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFD946EF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'actionText': 'Explore Shoes',
      'icon': Icons.directions_run_rounded,
    },
    {
      'title': 'Elegant Accessories',
      'subtitle': 'Curated minimalist watch collections',
      'tag': 'PREMIUM',
      'gradient': const LinearGradient(
        colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'actionText': 'View Premium',
      'icon': Icons.watch_rounded,
    }
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _bannerData.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
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
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _bannerData.length,
            itemBuilder: (context, index) {
              final banner = _bannerData[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  gradient: banner['gradient'],
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
                                    banner['tag'],
                                    style: AppTextStyles.chipLabelSelected.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  banner['title'],
                                  style: AppTextStyles.sectionHeader.copyWith(
                                    color: AppColors.textWhite,
                                    fontSize: 20,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner['subtitle'],
                                  style: AppTextStyles.bodyPrimary.copyWith(
                                    color: AppColors.textWhite.withValues(alpha: 0.85),
                                    fontSize: 13,
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
                                    banner['actionText'],
                                    style: AppTextStyles.chipLabel.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Icon(
                                banner['icon'],
                                size: 80,
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
            _bannerData.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 6.0,
              width: _currentPage == index ? 18.0 : 6.0,
              decoration: BoxDecoration(
                color: _currentPage == index 
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
