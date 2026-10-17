import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderProvider>(context);
    final orders = orderProv.orders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.brandYellow,
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.brandYellowLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_outlined, size: 60, color: AppColors.brandYellowDark),
                  ),
                  const SizedBox(height: 16),
                  const Text('No orders yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Your past groceries and deliveries will appear here', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isOngoing = order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isOngoing ? AppColors.brandGreen : AppColors.border,
                      width: isOngoing ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID, Date & Status Chip
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${order.id}',
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            _buildStatusBadge(order.status),
                          ],
                        ),
                        const Divider(height: 20),

                        // Items preview
                        Text(
                          order.items.map((i) => '${i.quantity}x ${i.product.name}').join(', '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.3),
                        ),
                        const SizedBox(height: 12),

                        // Total Price and Track Action
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${order.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                            Row(
                              children: [
                                if (isOngoing)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderTrackingScreen(order: order),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.navigation_outlined, size: 16),
                                    label: const Text('Live Track'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brandGreen,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                  )
                                else
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      final cart = Provider.of<CartProvider>(context, listen: false);
                                      for (var item in order.items) {
                                        cart.addItem(item.product);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Items re-added to cart!')),
                                      );
                                    },
                                    icon: const Icon(Icons.replay_rounded, size: 16),
                                    label: const Text('Reorder'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bg;
    Color fg;

    switch (status) {
      case OrderStatus.placed:
        bg = AppColors.badgeBlueLight;
        fg = AppColors.badgeBlue;
        break;
      case OrderStatus.packing:
        bg = AppColors.badgeOrangeLight;
        fg = AppColors.badgeOrange;
        break;
      case OrderStatus.outForDelivery:
        bg = AppColors.brandYellowLight;
        fg = AppColors.brandYellowDark;
        break;
      case OrderStatus.delivered:
        bg = AppColors.brandGreenLight;
        fg = AppColors.brandGreenDark;
        break;
      case OrderStatus.cancelled:
        bg = AppColors.badgeRedLight;
        fg = AppColors.badgeRed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
