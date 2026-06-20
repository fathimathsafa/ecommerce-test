import 'package:flutter/material.dart';
import '../../../data/models/product.dart';

/// Global singleton controller to manage the wishlist state across screens.
class WishlistController extends ChangeNotifier {
  // Private constructor
  WishlistController._internal() {
    // Pre-populate with a default favorite for demonstration
    _wishlistedIds.add('p2'); 
  }

  // Singleton instance
  static final WishlistController instance = WishlistController._internal();

  // Storage for wishlisted product IDs
  final Set<String> _wishlistedIds = {};

  // Check if a product is wishlisted
  bool isWishlisted(String productId) {
    return _wishlistedIds.contains(productId);
  }

  // Toggle wishlist state
  void toggleWishlist(String productId) {
    if (_wishlistedIds.contains(productId)) {
      _wishlistedIds.remove(productId);
    } else {
      _wishlistedIds.add(productId);
    }
    notifyListeners();
  }

  // Get list of active wishlisted products from any source list
  List<Product> getWishlistedProducts(List<Product> source) {
    return source.where((product) => _wishlistedIds.contains(product.id)).toList();
  }
}
