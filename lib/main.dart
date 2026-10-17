import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/home/search_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final cartProvider = CartProvider();
  await cartProvider.loadFromStorage();

  runApp(MahuaXpressApp(cartProvider: cartProvider));
}

class MahuaXpressApp extends StatelessWidget {
  final CartProvider? cartProvider;

  const MahuaXpressApp({super.key, this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        cartProvider != null
            ? ChangeNotifierProvider.value(value: cartProvider!)
            : ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'MahuaXpress - 10 Min Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/search': (context) => const SearchScreen(),
          '/cart': (context) => const CartScreen(),
          '/admin': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
