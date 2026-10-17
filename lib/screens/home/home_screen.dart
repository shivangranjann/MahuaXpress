import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/blinkit_header.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/floating_cart_bar.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final bestsellers = app.bestsellers;
    final dairyItems = app.getProductsForCategory('Dairy, Bread & Eggs');
    final veggieItems = app.getProductsForCategory('Vegetables & Fruits');
    final munchieItems = app.getProductsForCategory('Munchies & Chips');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Sticky Blinkit Signature Header
              const SliverToBoxAdapter(
                child: BlinkitHeader(),
              ),

              // Promotional Banner Carousel
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: BannerCarousel(),
                ),
              ),

              // Categories Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Explore by Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onNavigateTab?.call(1);
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Horizontal Scroll List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 105,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: app.categories.length,
                    itemBuilder: (context, index) {
                      final cat = app.categories[index];
                      return CategoryChip(
                        category: cat,
                        onTap: () {
                          app.selectCategory(cat.id);
                          onNavigateTab?.call(1);
                        },
                      );
                    },
                  ),
                ),
              ),

              // Bestsellers Carousel
              if (bestsellers.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Bestsellers at Lowest Prices',
                    subtitle: 'Grab daily grocery essentials with maximum discount',
                    onSeeAll: () => onNavigateTab?.call(1),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: bestsellers.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: bestsellers[index]);
                      },
                    ),
                  ),
                ),
              ],

              // Dairy & Breakfast Section
              if (dairyItems.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Dairy, Bread & Eggs',
                    subtitle: 'Delivered chilled and fresh from verified dark stores',
                    onSeeAll: () {
                      final dairy = app.categories.firstWhere((c) => c.name.contains('Dairy'));
                      app.selectCategory(dairy.id);
                      onNavigateTab?.call(1);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: dairyItems.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: dairyItems[index]);
                      },
                    ),
                  ),
                ),
              ],

              // Fresh Fruits & Vegetables
              if (veggieItems.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Fresh Fruits & Vegetables',
                    subtitle: 'Farm fresh harvest sorted and packed hygienically',
                    onSeeAll: () {
                      final veg = app.categories.firstWhere((c) => c.name.contains('Vegetables'));
                      app.selectCategory(veg.id);
                      onNavigateTab?.call(1);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: veggieItems.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: veggieItems[index]);
                      },
                    ),
                  ),
                ),
              ],

              // Munchies & Chips Section
              if (munchieItems.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    title: 'Munchies & Late Night Craving',
                    subtitle: 'Chips, namkeen, wafers and instant bite packs',
                    onSeeAll: () {
                      final m = app.categories.firstWhere((c) => c.name.contains('Munchies'));
                      app.selectCategory(m.id);
                      onNavigateTab?.call(1);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: munchieItems.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: munchieItems[index]);
                      },
                    ),
                  ),
                ),
              ],

              // Bottom Brand Trust Footer
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(left: 14, right: 14, top: 24, bottom: 100),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'India\'s Last Minute App ⚡',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'MahuaXpress delivers fresh groceries, snacks, cold drinks, and essentials to your doorstep in 10 minutes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeatureBadge('⚡ 9 Mins', 'Express Delivery'),
                          _buildFeatureBadge('🛡️ 100%', 'Authentic Items'),
                          _buildFeatureBadge('🏷️ Big Savings', 'Best Discounts'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Cart Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingCartBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: const Text(
              'See All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.brandGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.brandGreen,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
