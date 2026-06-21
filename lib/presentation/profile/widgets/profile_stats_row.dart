import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProfileStatsRow extends StatelessWidget {
  final String activeOrders;
  final String savedItems;
  final String itemsInCart;
  final VoidCallback onWishlistTap;
  final VoidCallback onCartTap;

  const ProfileStatsRow({
    super.key,
    required this.activeOrders,
    required this.savedItems,
    required this.itemsInCart,
    required this.onWishlistTap,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          title: 'Active Orders',
          value: activeOrders,
          icon: Icons.local_shipping_outlined,
          color: Colors.amber,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _StatCard(
          title: 'Saved Items',
          value: savedItems,
          icon: Icons.favorite_border_rounded,
          color: AppColors.wishlist,
          onTap: onWishlistTap,
        ),
        const SizedBox(width: 12),
        _StatCard(
          title: 'In Cart',
          value: itemsInCart,
          icon: Icons.shopping_cart_outlined,
          color: AppColors.primary,
          onTap: onCartTap,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
