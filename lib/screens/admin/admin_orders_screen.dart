import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final orderProv = Provider.of<OrderProvider>(context);

    final filteredOrders = orderProv.orders.where((o) {
      if (_filter == 'Active') {
        return o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled;
      } else if (_filter == 'Delivered') {
        return o.status == OrderStatus.delivered;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: const Text(
          'Manage Store Orders',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: ['All', 'Active', 'Delivered'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    selectedColor: AppColors.brandYellowLight,
                    onSelected: (val) {
                      setState(() {
                        _filter = f;
                      });
                    },
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Real-time sync alert
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: AppColors.brandGreenLight,
            child: const Row(
              children: [
                Icon(Icons.sync_rounded, color: AppColors.brandGreen, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Real-time Store Sync: Changing status here updates customer order tracking instantly.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brandGreenDark),
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Text('No orders found in this filter', style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order ID and Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${order.id}',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      DateFormat('dd MMM, hh:mm a').format(order.createdAt),
                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                _buildStatusBadge(order.status),
                              ],
                            ),
                            const Divider(height: 18),

                            // Address
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    order.deliveryAddress.fullDisplay,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Items
                            Text(
                              order.items.map((i) => '${i.quantity}x ${i.product.name}').join(', '),
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),

                            // Total Bill & OTP
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Bill: ₹${order.totalAmount.toStringAsFixed(0)} (${order.paymentMethod})',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'OTP: ${order.deliveryOtp}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 18),

                            // Status Dispatch Controller
                            const Text(
                              'Update Status:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _buildStatusAction(
                                  context,
                                  orderProv,
                                  order,
                                  'Mark Packing',
                                  OrderStatus.packing,
                                  isActive: order.status == OrderStatus.packing,
                                ),
                                _buildStatusAction(
                                  context,
                                  orderProv,
                                  order,
                                  'Out for Delivery',
                                  OrderStatus.outForDelivery,
                                  isActive: order.status == OrderStatus.outForDelivery,
                                ),
                                _buildStatusAction(
                                  context,
                                  orderProv,
                                  order,
                                  'Delivered',
                                  OrderStatus.delivered,
                                  isActive: order.status == OrderStatus.delivered,
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

  Widget _buildStatusAction(
    BuildContext context,
    OrderProvider prov,
    OrderModel order,
    String label,
    OrderStatus targetStatus, {
    required bool isActive,
  }) {
    return ElevatedButton(
      onPressed: () {
        prov.updateOrderStatus(order.id, targetStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order #${order.id} status updated to ${targetStatus.name.toUpperCase()}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppColors.brandGreen : Colors.grey.shade100,
        foregroundColor: isActive ? Colors.white : AppColors.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bg = AppColors.brandGreenLight;
    Color fg = AppColors.brandGreenDark;

    if (status == OrderStatus.placed) {
      bg = AppColors.badgeBlueLight;
      fg = AppColors.badgeBlue;
    } else if (status == OrderStatus.packing) {
      bg = AppColors.badgeOrangeLight;
      fg = AppColors.badgeOrange;
    } else if (status == OrderStatus.outForDelivery) {
      bg = AppColors.brandYellowLight;
      fg = AppColors.brandYellowDark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}
