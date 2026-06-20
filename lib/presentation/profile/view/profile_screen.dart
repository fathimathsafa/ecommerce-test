import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/controller/cart_controller.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../../navigation/controller/navigation_controller.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_widgets.dart';

/// The Profile Screen displays member information, active statistics, and support settings.
/// Refactored to StatelessWidget utilizing ProfileController.
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
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of SwiftCart?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
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

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<ProfileController>();
    final cartController = context.watch<CartController>();
    final wishlistController = context.watch<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text(
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
            // Profile Card Header (extracted)
            ProfileHeaderCard(
              userName: profileController.userName,
              userEmail: profileController.userEmail,
              membership: profileController.membership,
            ),
            const SizedBox(height: 24),

            // Statistics Row (extracted)
            ProfileStatsRow(
              activeOrders: profileController.activeOrdersCount.toString(),
              savedItems: wishlistController.wishlistCount.toString(),
              itemsInCart: cartController.itemCount.toString(),
              onWishlistTap: () {
                context.read<NavigationController>().selectTab(1); // Go to wishlist tab
              },
              onCartTap: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            const SizedBox(height: 24),

            // Settings/Menus Section (extracted)
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
