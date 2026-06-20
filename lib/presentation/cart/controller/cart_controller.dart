import 'package:flutter/material.dart';
import '../../../data/models/product.dart';

/// Represents a product in the shopping cart with its current quantity.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalProductPrice => product.price * quantity;
}

/// Global singleton controller to manage shopping cart operations and prices.
class CartController extends ChangeNotifier {
  // Private constructor
  CartController._internal() {
    // Populate with some mock items for visual richness initially
    final mockProducts = Product.getDummyProducts();
    _cartItems[mockProducts[0].id] = CartItem(product: mockProducts[0], quantity: 1);
    _cartItems[mockProducts[2].id] = CartItem(product: mockProducts[2], quantity: 2);
  }

  // Singleton instance
  static final CartController instance = CartController._internal();

  // Storage mapping Product ID -> CartItem
  final Map<String, CartItem> _cartItems = {};

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
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity += 1;
    } else {
      _cartItems[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  /// Removes an item from the cart completely
  void removeFromCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.remove(productId);
      notifyListeners();
    }
  }

  /// Updates quantity of an item. If quantity <= 0, removes the item
  void updateQuantity(String productId, int newQty) {
    if (!_cartItems.containsKey(productId)) return;

    if (newQty <= 0) {
      _cartItems.remove(productId);
    } else {
      _cartItems[productId]!.quantity = newQty;
    }
    notifyListeners();
  }

  /// Clears all cart items
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
