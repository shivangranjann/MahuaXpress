import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/app_provider.dart';
import 'admin_add_edit_product_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _searchFilter = '';
  String _categoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    // Filter products
    final products = app.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchFilter.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchFilter.toLowerCase());
      if (!matchesSearch) return false;
      if (_categoryFilter == 'All') return true;
      return p.category == _categoryFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: const Text(
          'Manage Products',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminAddEditProductScreen()),
          );
        },
        backgroundColor: AppColors.brandGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchFilter = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products by name or category...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Category Filter Pills
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('All', _categoryFilter == 'All'),
                      ...app.categories.map((c) => _buildFilterChip(c.name, _categoryFilter == c.name)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${products.length} products',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                Text(
                  '${app.products.where((p) => !p.inStock).length} Out of Stock',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.badgeRed),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 80),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 60,
                          width: 60,
                          color: AppColors.background,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${product.category} • ${product.unit}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.brandGreenDark),
                                ),
                                const SizedBox(width: 6),
                                if (product.mrp > product.price)
                                  Text(
                                    '₹${product.mrp.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: AppColors.textMuted),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  'Qty: ${product.stockQuantity}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: product.stockQuantity < 10 ? Colors.red : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // In-Stock Switch & Actions
                      Column(
                        children: [
                          Switch(
                            value: product.inStock,
                            activeThumbColor: AppColors.brandGreen,
                            onChanged: (val) {
                              app.toggleProductStock(product.id);
                            },
                          ),
                          Text(
                            product.inStock ? 'In Stock' : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: product.inStock ? AppColors.brandGreen : Colors.red,
                            ),
                          ),
                        ],
                      ),

                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onSelected: (val) {
                          if (val == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminAddEditProductScreen(editingProduct: product),
                              ),
                            );
                          } else if (val == 'delete') {
                            _confirmDelete(context, app, product);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Edit Product'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete Product', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppProvider app, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to remove "${product.name}" from the store catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              app.deleteProduct(product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product removed from catalog')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.brandYellowLight,
        onSelected: (val) {
          setState(() {
            _categoryFilter = label;
          });
        },
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? Colors.black : AppColors.textSecondary,
        ),
      ),
    );
  }
}
