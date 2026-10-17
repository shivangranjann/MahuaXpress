import 'cart_item_model.dart';
import 'user_address_model.dart';

enum OrderStatus {
  placed,
  packing,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final DateTime createdAt;
  final List<CartItemModel> items;
  OrderStatus status;
  final UserAddressModel deliveryAddress;
  final double itemTotal;
  final double deliveryFee;
  final double handlingFee;
  final double tipAmount;
  final double totalAmount;
  final String deliveryOtp;
  final String riderName;
  final String riderPhone;
  final String riderVehicle;
  final String paymentMethod;
  int estimatedMinutes;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.items,
    this.status = OrderStatus.placed,
    required this.deliveryAddress,
    required this.itemTotal,
    required this.deliveryFee,
    this.handlingFee = 4.0,
    this.tipAmount = 0.0,
    required this.totalAmount,
    this.deliveryOtp = '4829',
    this.riderName = 'Ramesh Kumar',
    this.riderPhone = '+91 98765 43210',
    this.riderVehicle = 'Electric Hero Nyx • DL 04 EV 9821',
    this.paymentMethod = 'UPI (Instant)',
    this.estimatedMinutes = 9,
  });

  String get statusDisplay {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.packing:
        return 'Packing at Dark Store';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get statusSubtitle {
    switch (status) {
      case OrderStatus.placed:
        return 'Store has received your order & is preparing items';
      case OrderStatus.packing:
        return 'Store executive is picking fresh items for you';
      case OrderStatus.outForDelivery:
        return 'Rider is on the way to your doorstep';
      case OrderStatus.delivered:
        return 'Order delivered successfully. Enjoy your groceries!';
      case OrderStatus.cancelled:
        return 'Order was cancelled';
    }
  }

  double get progressPercentage {
    switch (status) {
      case OrderStatus.placed:
        return 0.25;
      case OrderStatus.packing:
        return 0.55;
      case OrderStatus.outForDelivery:
        return 0.85;
      case OrderStatus.delivered:
        return 1.0;
      case OrderStatus.cancelled:
        return 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'status': status.name,
      'deliveryAddress': deliveryAddress.toJson(),
      'itemTotal': itemTotal,
      'deliveryFee': deliveryFee,
      'handlingFee': handlingFee,
      'tipAmount': tipAmount,
      'totalAmount': totalAmount,
      'deliveryOtp': deliveryOtp,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'riderVehicle': riderVehicle,
      'paymentMethod': paymentMethod,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List)
          .map((i) => CartItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.placed,
      ),
      deliveryAddress: UserAddressModel.fromJson(
          json['deliveryAddress'] as Map<String, dynamic>),
      itemTotal: (json['itemTotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      handlingFee: (json['handlingFee'] as num?)?.toDouble() ?? 4.0,
      tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryOtp: json['deliveryOtp'] as String? ?? '4829',
      riderName: json['riderName'] as String? ?? 'Ramesh Kumar',
      riderPhone: json['riderPhone'] as String? ?? '+91 98765 43210',
      riderVehicle: json['riderVehicle'] as String? ?? 'Electric Hero Nyx • DL 04 EV 9821',
      paymentMethod: json['paymentMethod'] as String? ?? 'UPI (Instant)',
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 9,
    );
  }
}
