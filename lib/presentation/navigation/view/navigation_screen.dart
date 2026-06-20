import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../home_screen/view/home_screen.dart';
import '../../wishlist/view/wishlist_screen.dart';
import '../controller/navigation_controller.dart';

class NavigationScreen extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    const WishlistScreen(),
    const ProfilePlaceholderScreen(),
  ];

  NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NavigationController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: controller.selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex,
              onTap: controller.selectTab,
              backgroundColor: AppColors.bgCard,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_rounded),
                  activeIcon: Icon(Icons.favorite_rounded),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Simple placeholder screen for Profile tab
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.person_rounded, size: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Demo User',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'demouser@ewire.com',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                title: const Text('Order History', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
              const Divider(color: AppColors.borderLight),
              ListTile(
                leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                title: const Text('Shipping Addresses', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
              const Divider(color: AppColors.borderLight),
              ListTile(
                leading: const Icon(Icons.payment_rounded, color: AppColors.primary),
                title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
