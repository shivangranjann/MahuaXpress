import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/live_map_widget.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProv, child) {
        // Fetch refreshed order instance from provider
        final liveOrder = orderProv.getOrderById(order.id) ?? order;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.brandYellow,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${liveOrder.id}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                Text(
                  liveOrder.statusDisplay,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brandGreenDark),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('24x7 Customer Support is active for your order')),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top ETA Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                      color: AppColors.brandGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    liveOrder.status == OrderStatus.delivered
                                        ? 'DELIVERED'
                                        : 'ARRIVING IN ${liveOrder.estimatedMinutes} MINS',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.brandGreenDark,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                liveOrder.statusSubtitle,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.brandYellowLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.brandYellowDark),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'DELIVERY OTP',
                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textMuted),
                                ),
                                Text(
                                  liveOrder.deliveryOtp,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: liveOrder.progressPercentage,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandGreen),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Live Interactive Map Widget
                LiveMapWidget(order: liveOrder),
                const SizedBox(height: 14),

                // Delivery Partner Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.brandYellow,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                          ],
                        ),
                        child: const Icon(Icons.sports_motorsports_rounded, size: 28, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              liveOrder.riderName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              liveOrder.riderVehicle,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.star, size: 12, color: AppColors.starGold),
                                SizedBox(width: 2),
                                Text(
                                  '4.9 (1,420 deliveries)',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Calling rider at ${liveOrder.riderPhone}...')),
                          );
                        },
                        icon: const Icon(Icons.phone_in_talk_rounded, size: 20, color: AppColors.brandGreen),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.brandGreenLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Order Tracking Stepper
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Status Timeline',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      _buildTimelineStep(
                        title: 'Order Placed & Confirmed',
                        subtitle: 'Received at Dark Store',
                        isCompleted: true,
                        isActive: liveOrder.status == OrderStatus.placed,
                      ),
                      _buildTimelineStep(
                        title: 'Packing Fresh Essentials',
                        subtitle: 'Item quality verified and packed',
                        isCompleted: liveOrder.status == OrderStatus.packing ||
                            liveOrder.status == OrderStatus.outForDelivery ||
                            liveOrder.status == OrderStatus.delivered,
                        isActive: liveOrder.status == OrderStatus.packing,
                      ),
                      _buildTimelineStep(
                        title: 'Out for Delivery',
                        subtitle: 'Rider on electric vehicle heading to your door',
                        isCompleted: liveOrder.status == OrderStatus.outForDelivery ||
                            liveOrder.status == OrderStatus.delivered,
                        isActive: liveOrder.status == OrderStatus.outForDelivery,
                      ),
                      _buildTimelineStep(
                        title: 'Delivered at Doorstep',
                        subtitle: 'Enjoy your fresh groceries!',
                        isCompleted: liveOrder.status == OrderStatus.delivered,
                        isActive: liveOrder.status == OrderStatus.delivered,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Order Items Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Items in this order',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '${liveOrder.items.length} items',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      ...liveOrder.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Text(
                                '${item.quantity}x',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.brandGreen),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '₹${item.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Bill Paid', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text(
                            '₹${liveOrder.totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.brandGreenDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Admin Testing Control (Simulate status change directly from tracking!)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandYellowLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.brandYellowDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tune_rounded, size: 16, color: AppColors.textPrimary),
                          SizedBox(width: 6),
                          Text(
                            'Quick Status Simulator (Admin / Testing)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildStatusButton(context, orderProv, liveOrder.id, 'Packing', OrderStatus.packing),
                          _buildStatusButton(context, orderProv, liveOrder.id, 'Out for Delivery', OrderStatus.outForDelivery),
                          _buildStatusButton(context, orderProv, liveOrder.id, 'Delivered', OrderStatus.delivered),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(BuildContext context, OrderProvider prov, String orderId, String label, OrderStatus status) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      backgroundColor: Colors.white,
      onPressed: () {
        prov.updateOrderStatus(orderId, status);
      },
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.brandGreen : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.brandYellowDark : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                height: 32,
                width: 2,
                color: isCompleted ? AppColors.brandGreen : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
