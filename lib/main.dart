import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'presentation/cart/view/cart_screen.dart';
import 'presentation/splash_screen/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ewire E-commerce',
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
      ),
      home: const SplashScreen(),
      routes: {
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
