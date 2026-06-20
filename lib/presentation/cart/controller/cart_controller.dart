import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home_screen/model/product_model.dart';

/// Represents a product in the shopping cart with its current quantity.
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

/// ChangeNotifier controller to manage shopping cart operations via Provider with local storage persistence.
class CartController extends ChangeNotifier {
  // Storage mapping Product ID (int) -> CartItem
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

  // Retrieve all cart items
  List<CartItem> get items => _cartItems.values.toList();

  // Get total unique item types
  int get uniqueItemCount => _cartItems.length;

  // Get total aggregate quantity of items in cart
  int get itemCount {
    int total = 0;
    _cartItems.forEach((_, item) => total += item.quantity);
    return total;
  }

  // Calculate items subtotal
  double get subtotal {
    double total = 0.0;
    _cartItems.forEach((_, item) => total += item.totalProductPrice);
    return total;
  }

  // Shipping charges mockup (e.g. flat rate of $10, free above $200)
  double get deliveryCharge {
    if (_cartItems.isEmpty) return 0.0;
    return subtotal > 200.0 ? 0.0 : 10.00;
  }

  // Calculate total checkout amount
  double get totalAmount => subtotal + deliveryCharge;

  /// Adds a product to the cart or increments its count if already added
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

  /// Removes an item from the cart completely
  void removeFromCart(int? productId) {
    if (productId == null) return;
    if (_cartItems.containsKey(productId)) {
      _cartItems.remove(productId);
      _saveToPrefs();
      notifyListeners();
    }
  }

  /// Updates quantity of an item. If quantity <= 0, removes the item
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

  /// Clears all cart items
  void clearCart() {
    _cartItems.clear();
    _saveToPrefs();
    notifyListeners();
  }
}
