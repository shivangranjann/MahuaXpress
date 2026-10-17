import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/mock_data.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/user_address_model.dart';

class AppProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  List<UserAddressModel> _addresses = [];
  UserAddressModel? _selectedAddress;
  String _selectedCategoryId = '';
  String _selectedSubCategory = 'All';
  String _searchQuery = '';
  bool _isAdminMode = false;

  static const String _productsKey = 'mahua_products_v1';
  static const String _addressesKey = 'mahua_addresses_v1';

  AppProvider() {
    initData();
  }

  List<ProductModel> get products => [..._products];
  List<CategoryModel> get categories => [..._categories];
  List<UserAddressModel> get addresses => [..._addresses];
  UserAddressModel? get selectedAddress => _selectedAddress;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedSubCategory => _selectedSubCategory;
  String get searchQuery => _searchQuery;
  bool get isAdminMode => _isAdminMode;

  void toggleAdminMode() {
    _isAdminMode = !_isAdminMode;
    notifyListeners();
  }

  void setAdminMode(bool val) {
    _isAdminMode = val;
    notifyListeners();
  }

  Future<void> initData() async {
    _categories = List.from(MockData.categories);
    if (_categories.isNotEmpty) {
      _selectedCategoryId = _categories.first.id;
    }

    await _loadAddresses();
    await _loadProducts();
  }

  // --- Address Management ---
  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_addressesKey);
      if (data != null && data.isNotEmpty) {
        final List list = json.decode(data);
        _addresses = list.map((e) => UserAddressModel.fromJson(e)).toList();
      } else {
        _addresses = List.from(MockData.initialAddresses);
      }
      if (_addresses.isNotEmpty) {
        _selectedAddress = _addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => _addresses.first,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading addresses: $e');
      _addresses = List.from(MockData.initialAddresses);
      _selectedAddress = _addresses.first;
      notifyListeners();
    }
  }

  void selectAddress(UserAddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> addAddress(UserAddressModel address) async {
    _addresses.add(address);
    if (_selectedAddress == null || address.isDefault) {
      _selectedAddress = address;
    }
    await _saveAddresses();
    notifyListeners();
  }

  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _addresses.map((a) => a.toJson()).toList();
      await prefs.setString(_addressesKey, json.encode(list));
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  // --- Product Management ---
  Future<void> _loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_productsKey);
      if (data != null && data.isNotEmpty) {
        final List list = json.decode(data);
        _products = list.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        _products = List.from(MockData.initialProducts);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading products: $e');
      _products = List.from(MockData.initialProducts);
      notifyListeners();
    }
  }

  Future<void> _saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _products.map((p) => p.toJson()).toList();
      await prefs.setString(_productsKey, json.encode(list));
    } catch (e) {
      debugPrint('Error saving products: $e');
    }
  }

  List<ProductModel> get bestsellers {
    return _products.where((p) => p.isBestseller && p.inStock).toList();
  }

  List<ProductModel> getProductsForCategory(String categoryName, {String? subCategory}) {
    return _products.where((p) {
      final matchesCategory = p.category.toLowerCase() == categoryName.toLowerCase();
      if (!matchesCategory) return false;
      if (subCategory == null || subCategory == 'All') return true;
      return p.subCategory.toLowerCase() == subCategory.toLowerCase();
    }).toList();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.trim().isEmpty) return [];
    final lower = query.toLowerCase().trim();
    return _products.where((p) {
      return p.name.toLowerCase().contains(lower) ||
          p.category.toLowerCase().contains(lower) ||
          p.subCategory.toLowerCase().contains(lower) ||
          p.description.toLowerCase().contains(lower);
    }).toList();
  }

  void selectCategory(String categoryId, {String subCategory = 'All'}) {
    _selectedCategoryId = categoryId;
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void selectSubCategory(String subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // --- Admin Methods ---
  Future<void> toggleProductStock(String productId) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final current = _products[index];
      _products[index] = current.copyWith(inStock: !current.inStock);
      await _saveProducts();
      notifyListeners();
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    } else {
      _products.insert(0, product);
    }
    await _saveProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    await _saveProducts();
    notifyListeners();
  }

  Future<void> resetToDefaultProducts() async {
    _products = List.from(MockData.initialProducts);
    await _saveProducts();
    notifyListeners();
  }
}
