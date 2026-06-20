import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Renders the user avatar, name, email and membership status badge.
class ProfileHeaderCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String membership;

  const ProfileHeaderCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    membership,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the row containing the Orders, Wishlist, and Cart stat cards.
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
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 10,
                offset: Offset(0, 4),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
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

/// Renders a container with soft shadows, containing a grouped list of menu options.
class ProfileMenuCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const ProfileMenuCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: List.generate(items.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const Divider(height: 1, color: AppColors.borderLight);
              }
              return items[index ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}

/// Renders individual list tiles for navigation menu options.
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Color? textColor;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
