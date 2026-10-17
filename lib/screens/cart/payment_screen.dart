import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../order/order_tracking_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;

  void _processPayment() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final app = Provider.of<AppProvider>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);

    if (app.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or add a delivery address')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate secure payment processing
    await Future.delayed(const Duration(milliseconds: 1400));

    final newOrder = await orderProv.placeOrder(
      items: cart.items.values.toList(),
      address: app.selectedAddress!,
      itemTotal: cart.itemTotalAmount,
      deliveryFee: cart.deliveryFee,
      handlingFee: cart.handlingFee,
      tipAmount: cart.tipAmount,
      totalAmount: cart.grandTotal,
      paymentMethod: _selectedMethod,
    );

    cart.clearCart();

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Navigate to live tracking screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTrackingScreen(order: newOrder),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
        title: const Text(
          'Select Payment Method',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Amount Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount to Pay',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          Text(
                            '10-Min Fast Delivery',
                            style: TextStyle(fontSize: 11, color: AppColors.brandGreen, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Text(
                        '₹${cart.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Payment Options
                const Text(
                  'Recommended Options',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),

                _buildPaymentTile(
                  id: 'UPI',
                  title: 'UPI (Google Pay, PhonePe, Paytm)',
                  subtitle: 'Instant refund & zero transaction fees',
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.brandGreen,
                ),
                const SizedBox(height: 10),

                _buildPaymentTile(
                  id: 'Cards',
                  title: 'Credit / Debit Cards',
                  subtitle: 'Visa, MasterCard, RuPay, Maestro',
                  icon: Icons.credit_card_rounded,
                  iconColor: AppColors.badgeBlue,
                ),
                const SizedBox(height: 10),

                _buildPaymentTile(
                  id: 'NetBanking',
                  title: 'Net Banking',
                  subtitle: 'All major Indian banks supported',
                  icon: Icons.account_balance_rounded,
                  iconColor: AppColors.badgeOrange,
                ),
                const SizedBox(height: 10),

                _buildPaymentTile(
                  id: 'COD',
                  title: 'Cash on Delivery (COD)',
                  subtitle: 'Pay via Cash or UPI at your doorstep',
                  icon: Icons.payments_outlined,
                  iconColor: AppColors.brandYellowDark,
                ),
                const SizedBox(height: 24),

                // Security Assurance Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreenLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security_rounded, color: AppColors.brandGreen, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '100% Safe & Encrypted Payments with RBI compliant gateways',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brandGreenDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Pay Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Confirming Order...', style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      )
                    : Text(
                        'Pay ₹${cart.grandTotal.toStringAsFixed(0)} & Place Order',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedMethod == id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = id;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandGreenLight.withValues(alpha: 0.4) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.brandGreen : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.brandGreenDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.brandGreen : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandGreen,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
