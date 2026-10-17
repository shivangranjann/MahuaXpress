import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../widgets/floating_cart_bar.dart';
import '../../widgets/product_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final categories = app.categories;

    final selectedCat = categories.firstWhere(
      (c) => c.id == app.selectedCategoryId,
      orElse: () => categories.first,
    );

    final products = app.getProductsForCategory(
      selectedCat.name,
      subCategory: app.selectedSubCategory,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.brandYellow,
        title: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Left Vertical Category Rail (Split View)
              Container(
                width: 86,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat.id == selectedCat.id;

                    return InkWell(
                      onTap: () {
                        app.selectCategory(cat.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.brandGreenLight.withValues(alpha: 0.5) : Colors.white,
                          border: Border(
                            left: BorderSide(
                              color: isSelected ? AppColors.brandGreen : Colors.transparent,
                              width: 3.5,
                            ),
                            bottom: BorderSide(color: Colors.grey.shade100, width: 0.8),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: cat.backgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  cat.iconEmoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? AppColors.brandGreenDark : AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),

              // Right Product Area
              Expanded(
                child: Column(
                  children: [
                    // Top Sub-category filter pills
                    Container(
                      height: 46,
                      color: Colors.white,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        children: [
                          _buildSubCategoryChip('All', app.selectedSubCategory == 'All', () {
                            app.selectSubCategory('All');
                          }),
                          ...selectedCat.subCategories.map((sub) {
                            return _buildSubCategoryChip(
                              sub,
                              app.selectedSubCategory == sub,
                              () {
                                app.selectSubCategory(sub);
                              },
                            );
                          }),
                        ],
                      ),
                    ),

                    const Divider(height: 1, thickness: 1, color: AppColors.border),

                    // Products Grid
                    Expanded(
                      child: products.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No products in this subcategory',
                                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 90),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.60,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: products[index],
                                  width: double.infinity,
                                );
                              },
                            ),
                    ),
                  ],
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

  Widget _buildSubCategoryChip(String title, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brandGreen : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.brandGreen : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
