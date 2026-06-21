import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'presentation/cart/controller/cart_controller.dart';
import 'presentation/cart/view/cart_screen.dart';
import 'presentation/home_screen/controller/home_controller.dart';
import 'presentation/navigation/controller/navigation_controller.dart';
import 'presentation/splash_screen/view/splash_screen.dart';
import 'presentation/wishlist/controller/wishlist_controller.dart';
import 'presentation/profile/controller/profile_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
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
    final themeController = context.watch<ThemeController>();
    
    // Update central brightness state dynamically
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    themeController.updateSystemBrightness(systemBrightness);

    return MaterialApp(
      title: 'Swift Cart',
      debugShowCheckedModeBanner: false,
      themeMode: themeController.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
