import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/user_address_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  OrderModel? _activeOrder;
  Timer? _simulationTimer;
  static const String _ordersKey = 'mahua_orders_v1';

  List<OrderModel> get orders => [..._orders];
  OrderModel? get activeOrder => _activeOrder;

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_ordersKey);
      if (data != null && data.isNotEmpty) {
        final List list = json.decode(data);
        _orders = list.map((e) => OrderModel.fromJson(e)).toList();
        
        // Find most recent incomplete order as active
        final ongoing = _orders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled);
        if (ongoing.isNotEmpty) {
          _activeOrder = ongoing.first;
        } else if (_orders.isNotEmpty) {
          _activeOrder = _orders.first;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  Future<OrderModel> placeOrder({
    required List<CartItemModel> items,
    required UserAddressModel address,
    required double itemTotal,
    required double deliveryFee,
    required double handlingFee,
    required double tipAmount,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final randomId = 'ORD-${1000 + Random().nextInt(9000)}';
    final randomOtp = '${1000 + Random().nextInt(9000)}';

    final newOrder = OrderModel(
      id: randomId,
      createdAt: DateTime.now(),
      items: List.from(items),
      status: OrderStatus.placed,
      deliveryAddress: address,
      itemTotal: itemTotal,
      deliveryFee: deliveryFee,
      handlingFee: handlingFee,
      tipAmount: tipAmount,
      totalAmount: totalAmount,
      deliveryOtp: randomOtp,
      paymentMethod: paymentMethod,
      estimatedMinutes: 9,
    );

    _orders.insert(0, newOrder);
    _activeOrder = newOrder;
    await _saveOrders();
    notifyListeners();

    _startSimulatedProgression(newOrder.id);
    return newOrder;
  }

  void _startSimulatedProgression(String orderId) {
    _simulationTimer?.cancel();

    // Auto-advance statuses to demonstrate live 10-minute Blinkit quick delivery!
    // 15 seconds -> Packing
    // 35 seconds -> Out for Delivery
    // 70 seconds -> Delivered
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final order = getOrderById(orderId);
      if (order == null) {
        timer.cancel();
        return;
      }

      final elapsed = DateTime.now().difference(order.createdAt).inSeconds;

      if (elapsed >= 70 && order.status != OrderStatus.delivered) {
        updateOrderStatus(orderId, OrderStatus.delivered);
        timer.cancel();
      } else if (elapsed >= 35 && order.status == OrderStatus.packing) {
        updateOrderStatus(orderId, OrderStatus.outForDelivery);
      } else if (elapsed >= 12 && order.status == OrderStatus.placed) {
        updateOrderStatus(orderId, OrderStatus.packing);
      }

      // Decrement simulated minutes
      if (order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled) {
        final remaining = max(1, 9 - (elapsed ~/ 8));
        if (remaining != order.estimatedMinutes) {
          order.estimatedMinutes = remaining;
          notifyListeners();
        }
      }
    });
  }

  OrderModel? getOrderById(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) return _orders[index];
    return null;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      if (newStatus == OrderStatus.delivered) {
        _orders[index].estimatedMinutes = 0;
      }
      if (_activeOrder?.id == orderId) {
        _activeOrder = _orders[index];
      }
      await _saveOrders();
      notifyListeners();
    }
  }

  void setActiveOrder(OrderModel order) {
    _activeOrder = order;
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _orders.map((o) => o.toJson()).toList();
      await prefs.setString(_ordersKey, json.encode(list));
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
