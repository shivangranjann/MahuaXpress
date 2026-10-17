import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';

class LiveMapWidget extends StatefulWidget {
  final OrderModel order;

  const LiveMapWidget({super.key, required this.order});

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rider progress based on status
    double riderProgress = 0.15;
    if (widget.order.status == OrderStatus.packing) {
      riderProgress = 0.35;
    } else if (widget.order.status == OrderStatus.outForDelivery) {
      riderProgress = 0.75;
    } else if (widget.order.status == OrderStatus.delivered) {
      riderProgress = 1.0;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE5ECE9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            // Custom Road & Map Layout
            CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _MapCanvasPainter(progress: riderProgress),
            ),

            // Store Pin (Left)
            Positioned(
              left: 20,
              top: 50,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: AppColors.brandYellow,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Dark Store',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // Delivery House Pin (Right)
            Positioned(
              right: 20,
              bottom: 40,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.brandGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandGreen.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Your Home',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // Animated Moving Rider Marker
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final startX = 40.0;
                    final startY = 70.0;
                    final endX = constraints.maxWidth - 50.0;
                    final endY = 120.0;

                    // Quadratic Bezier interpolation for curved route
                    final t = riderProgress;
                    final controlX = constraints.maxWidth * 0.45;
                    final controlY = 20.0;

                    final currentX = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
                    final currentY = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;

                    return Positioned(
                      left: currentX - 18,
                      top: currentY - 18,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulse Circle
                          if (widget.order.status != OrderStatus.delivered)
                            Container(
                              height: 36 + (_pulseController.value * 12),
                              width: 36 + (_pulseController.value * 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.brandGreen.withValues(alpha: 0.25 * (1 - _pulseController.value)),
                              ),
                            ),
                          // Rider Bike Icon
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: AppColors.brandYellow,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.delivery_dining_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Speed & Distance Banner Top Right
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.brandGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.order.status == OrderStatus.delivered
                          ? 'Arrived'
                          : '${widget.order.estimatedMinutes} mins away (0.8 km)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final double progress;

  _MapCanvasPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Background Grid / Simulated Blocks
    final blockPaint = Paint()
      ..color = const Color(0xFFDCE4E0)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(15, 15, size.width * 0.25, 40), const Radius.circular(6)), blockPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.55, 10, size.width * 0.35, 50), const Radius.circular(6)), blockPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 110, size.width * 0.3, 50), const Radius.circular(6)), blockPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.45, 120, size.width * 0.45, 45), const Radius.circular(6)), blockPaint);

    // Route Path
    final startX = 40.0;
    final startY = 70.0;
    final endX = size.width - 50.0;
    final endY = 120.0;
    final controlX = size.width * 0.45;
    final controlY = 20.0;

    final path = Path()
      ..moveTo(startX, startY)
      ..quadraticBezierTo(controlX, controlY, endX, endY);

    // Background road (Gray)
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, roadPaint);

    // Active progress road (Green dashed)
    final progressPaint = Paint()
      ..color = AppColors.brandGreen
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Approximate dashed or colored progress path
    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
