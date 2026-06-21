import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../cart/controller/cart_controller.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../../navigation/controller/navigation_controller.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of Swift Cart?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wishlist,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Choose Theme',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeOptionButton(
                icon: Icons.light_mode_rounded,
                label: 'Light',
                isSelected: themeController.themeMode == ThemeMode.light,
                onTap: () {
                  themeController.setThemeMode(ThemeMode.light);
                  Navigator.pop(dialogContext);
                },
              ),
              ThemeOptionButton(
                icon: Icons.dark_mode_rounded,
                label: 'Dark',
                isSelected: themeController.themeMode == ThemeMode.dark,
                onTap: () {
                  themeController.setThemeMode(ThemeMode.dark);
                  Navigator.pop(dialogContext);
                },
              ),
              ThemeOptionButton(
                icon: Icons.brightness_auto_rounded,
                label: 'System',
                isSelected: themeController.themeMode == ThemeMode.system,
                onTap: () {
                  themeController.setThemeMode(ThemeMode.system);
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    final cartController = context.watch<CartController>();
    final wishlistController = context.watch<WishlistController>();
    final themeController = context.watch<ThemeController>();

    IconData themeIcon;
    String themeSubtitle;
    if (themeController.themeMode == ThemeMode.dark) {
      themeIcon = Icons.dark_mode_rounded;
      themeSubtitle = 'Dark Mode active';
    } else if (themeController.themeMode == ThemeMode.light) {
      themeIcon = Icons.light_mode_rounded;
      themeSubtitle = 'Light Mode active';
    } else {
      themeIcon = Icons.brightness_auto_rounded;
      themeSubtitle = 'Follows system preferences';
    }

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            ProfileHeaderCard(
              userName: profileController.userName,
              userEmail: profileController.userEmail,
              membership: profileController.membership,
            ),
            const SizedBox(height: 24),

            ProfileStatsRow(
              activeOrders: profileController.activeOrdersCount.toString(),
              savedItems: wishlistController.wishlistCount.toString(),
              itemsInCart: cartController.itemCount.toString(),
              onWishlistTap: () {
                context.read<NavigationController>().selectTab(1);
              },
              onCartTap: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            const SizedBox(height: 24),

            ProfileMenuCard(
              title: 'Personal Info',
              items: [
                ProfileMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                  title: 'Order History',
                  subtitle: 'Track your packages, returns & invoices',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.location_on_outlined,
                  color: Colors.deepOrangeAccent,
                  title: 'Shipping Addresses',
                  subtitle: 'Manage your primary delivery locations',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.payment_rounded,
                  color: Colors.blueAccent,
                  title: 'Payment Methods',
                  subtitle: 'Saved debit cards, credit cards & wallets',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            ProfileMenuCard(
              title: 'Support & Settings',
              items: [
                ProfileMenuItem(
                  icon: Icons.help_outline_rounded,
                  color: Colors.teal,
                  title: 'Help & Support Center',
                  subtitle: 'Get customer support or browse FAQs',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.shield_outlined,
                  color: Colors.brown,
                  title: 'Privacy Policy & Terms',
                  subtitle: 'Review legal terms & account policies',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: themeIcon,
                  color: Colors.purple,
                  title: 'App Theme',
                  subtitle: themeSubtitle,
                  onTap: () => _showThemeSelectionDialog(context, themeController),
                ),
                ProfileMenuItem(
                  icon: Icons.logout_rounded,
                  color: AppColors.wishlist,
                  title: 'Log Out',
                  subtitle: 'Securely exit your active shopping session',
                  textColor: AppColors.wishlist,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

