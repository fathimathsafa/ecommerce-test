import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'presentation/cart/controller/cart_controller.dart';
import 'presentation/cart/view/cart_screen.dart';
import 'presentation/home_screen/controller/home_controller.dart';
import 'presentation/navigation/controller/navigation_controller.dart';
import 'presentation/splash_screen/view/splash_screen.dart';
import 'presentation/wishlist/controller/wishlist_controller.dart';
import 'presentation/profile/controller/profile_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftCart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.bgMain,
        ),
        scaffoldBackgroundColor: AppColors.bgMain,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          elevation: 4.0,
          actionTextColor: AppColors.accent,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
