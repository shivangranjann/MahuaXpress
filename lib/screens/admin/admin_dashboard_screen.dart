import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/order_provider.dart';
import 'admin_add_edit_product_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_products_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final orderProv = Provider.of<OrderProvider>(context);

    // Calculate metrics
    final totalOrders = orderProv.orders.length;
    final activeOrders = orderProv.orders
        .where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
        .length;
    final totalRevenue = orderProv.orders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
    final totalProducts = app.products.length;
    final lowStockCount = app.products.where((p) => p.stockQuantity < 20 || !p.inStock).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings_rounded, color: AppColors.brandYellow, size: 22),
            SizedBox(width: 8),
            Text(
              'Store Admin Console',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
            tooltip: 'Return to Customer Mode',
            onPressed: () {
              app.setAdminMode(false);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Status Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.brandYellow,
                    child: Icon(Icons.storefront_rounded, color: Colors.black),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mahua Dark Store #01 (Patna Hub)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        Text(
                          'Live sync connected with customer app',
                          style: TextStyle(color: AppColors.brandYellow, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Key Metrics Grid
            const Text(
              'Real-Time Store Metrics',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Revenue',
                    value: '₹${totalRevenue.toStringAsFixed(0)}',
                    icon: Icons.currency_rupee_rounded,
                    color: AppColors.brandGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Active Orders',
                    value: '$activeOrders',
                    icon: Icons.electric_bike_rounded,
                    color: AppColors.badgeOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Orders',
                    value: '$totalOrders',
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.badgeBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Products in Store',
                    value: '$totalProducts',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.brandYellowDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Management Navigation Cards
            const Text(
              'Store Operations',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            _buildActionCard(
              title: 'Live Orders & Dispatch',
              subtitle: 'Change order status (Placed -> Packing -> Out for Delivery -> Delivered)',
              badge: activeOrders > 0 ? '$activeOrders Active' : '0 Pending',
              badgeColor: activeOrders > 0 ? AppColors.brandGreen : Colors.grey,
              icon: Icons.local_shipping_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminOrdersScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _buildActionCard(
              title: 'Product Catalog & Inventory',
              subtitle: 'Add new items, update prices, toggle in/out of stock',
              badge: '$totalProducts items',
              badgeColor: AppColors.badgeBlue,
              icon: Icons.category_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminProductsScreen()),
                );
              },
            ),
            const SizedBox(height: 10),

            _buildActionCard(
              title: 'Add New Product to App',
              subtitle: 'Publish a new grocery product to customer storefront instantly',
              badge: '+ Add',
              badgeColor: AppColors.brandYellowDark,
              icon: Icons.add_circle_outline_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminAddEditProductScreen()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Stock Alerts
            if (lowStockCount > 0) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.badgeOrangeLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.badgeOrange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.badgeOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$lowStockCount products have low inventory or are out of stock',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          const Text(
                            'Review product inventory to maintain 9-min fulfillment rate',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Reset demo data button
            OutlinedButton.icon(
              onPressed: () async {
                await app.resetToDefaultProducts();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Catalog reset to default 30+ grocery products')),
                  );
                }
              },
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: const Text('Reset Catalog to Factory Defaults'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
