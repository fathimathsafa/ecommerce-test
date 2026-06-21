import 'dart:convert';
import 'package:ewire/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalProductPrice => (product.price ?? 0.0) * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product']),
        quantity: json['quantity'] ?? 1,
      );
}

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};

  CartController() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCart = prefs.getStringList('cart_items') ?? [];
      _cartItems.clear();
      for (var itemStr in savedCart) {
        final Map<String, dynamic> itemJson = jsonDecode(itemStr);
        final item = CartItem.fromJson(itemJson);
        final id = item.product.id;
        if (id != null) {
          _cartItems[id] = item;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load cart: $e");
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> cartList = _cartItems.values.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList('cart_items', cartList);
    } catch (e) {
      debugPrint("Failed to save cart: $e");
    }
  }

  List<CartItem> get items => _cartItems.values.toList();


  int get uniqueItemCount => _cartItems.length;

  int get itemCount {
    int total = 0;
    _cartItems.forEach((_, item) => total += item.quantity);
    return total;
  }

  double get subtotal {
    double total = 0.0;
    _cartItems.forEach((_, item) => total += item.totalProductPrice);
    return total;
  }

  double get deliveryCharge {
    if (_cartItems.isEmpty) return 0.0;
    return subtotal > 200.0 ? 0.0 : 10.00;
  }

  double get totalAmount => subtotal + deliveryCharge;

  void addToCart(Product product) {
    final id = product.id;
    if (id == null) return;

    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity += 1;
    } else {
      _cartItems[id] = CartItem(product: product);
    }
    _saveToPrefs();
    notifyListeners();
  }

  void removeFromCart(int? productId) {
    if (productId == null) return;
    if (_cartItems.containsKey(productId)) {
      _cartItems.remove(productId);
      _saveToPrefs();
      notifyListeners();
    }
  }

  void updateQuantity(int? productId, int newQty) {
    if (productId == null || !_cartItems.containsKey(productId)) return;

    if (newQty <= 0) {
      _cartItems.remove(productId);
    } else {
      _cartItems[productId]!.quantity = newQty;
    }
    _saveToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveToPrefs();
    notifyListeners();
  }
}
