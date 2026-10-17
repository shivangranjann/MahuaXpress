import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItemModel> _items = {};
  double _tipAmount = 0.0;
  static const String _storageKey = 'mahua_cart_items_v1';

  Map<String, CartItemModel> get items => {..._items};

  int get totalItemCount {
    int count = 0;
    _items.forEach((key, item) {
      count += item.quantity;
    });
    return count;
  }

  double get tipAmount => _tipAmount;

  set tipAmount(double val) {
    _tipAmount = val;
    notifyListeners();
  }

  double get itemTotalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.totalPrice;
    });
    return total;
  }

  double get totalMrpAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.totalMrp;
    });
    return total;
  }

  double get totalSavingsAmount {
    double savings = 0.0;
    _items.forEach((key, item) {
      savings += item.totalSavings;
    });
    return savings;
  }

  double get deliveryFee {
    if (itemTotalAmount == 0) return 0.0;
    return itemTotalAmount >= 199.0 ? 0.0 : 15.0;
  }

  double get handlingFee {
    if (itemTotalAmount == 0) return 0.0;
    return 4.0;
  }

  double get grandTotal {
    if (itemTotalAmount == 0) return 0.0;
    return itemTotalAmount + deliveryFee + handlingFee + _tipAmount;
  }

  int getQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  void addItem(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItemModel(product: product, quantity: 1);
    }
    _saveToStorage();
    notifyListeners();
  }

  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    _saveToStorage();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveToStorage();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _tipAmount = 0.0;
    _saveToStorage();
    notifyListeners();
  }

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null && data.isNotEmpty) {
        final decoded = json.decode(data) as Map<String, dynamic>;
        _items.clear();
        decoded.forEach((key, value) {
          _items[key] = CartItemModel.fromJson(value as Map<String, dynamic>);
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = <String, dynamic>{};
      _items.forEach((key, item) {
        map[key] = item.toJson();
      });
      await prefs.setString(_storageKey, json.encode(map));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }
}
