import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';
import '../providers/app_provider.dart';
import '../providers/order_provider.dart';
import 'category/category_screen.dart';
import 'home/home_screen.dart';
import 'order/order_history_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderProvider>(context);
    final app = Provider.of<AppProvider>(context);

    final activeOrdersCount = orderProv.orders
        .where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
        .length;

    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const CategoryScreen(),
      const OrderHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.brandGreen,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_rounded),
              activeIcon: Icon(Icons.flash_on_rounded, color: AppColors.brandGreen),
              label: 'Delivery',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              activeIcon: Icon(Icons.grid_view_rounded, color: AppColors.brandGreen),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: activeOrdersCount > 0,
                label: Text('$activeOrdersCount'),
                backgroundColor: AppColors.brandGreen,
                child: const Icon(Icons.receipt_long_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: activeOrdersCount > 0,
                label: Text('$activeOrdersCount'),
                backgroundColor: AppColors.brandGreen,
                child: const Icon(Icons.receipt_long_rounded, color: AppColors.brandGreen),
              ),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.person_outline_rounded),
                  if (app.isAdminMode)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 7,
                        width: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.brandYellowDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.person_rounded, color: AppColors.brandGreen),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
