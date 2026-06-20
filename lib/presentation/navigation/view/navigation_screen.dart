import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../home_screen/view/home_screen.dart';
import '../../wishlist/view/wishlist_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../controller/navigation_controller.dart';

class NavigationScreen extends StatelessWidget {
  final List<Widget> _screens = [
    const HomeScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = context.watch<NavigationController>();

    return Scaffold(
      body: IndexedStack(
        index: navigationController.selectedIndex,
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
          currentIndex: navigationController.selectedIndex,
          onTap: navigationController.selectTab,
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
  }
}

/// Simple placeholder screen for Profile tab

