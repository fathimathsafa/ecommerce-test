import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home_screen/model/product_model.dart';

/// ChangeNotifier controller to manage the wishlist state via Provider with local storage persistence.
class WishlistController extends ChangeNotifier {
  // Storage for wishlisted product IDs
  final Set<int> _wishlistedIds = {};

  WishlistController() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('wishlist_ids') ?? [];
      _wishlistedIds.clear();
      _wishlistedIds.addAll(savedIds.map((e) => int.parse(e)));
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load wishlist: $e");
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wishlist_ids', _wishlistedIds.map((e) => e.toString()).toList());
    } catch (e) {
      debugPrint("Failed to save wishlist: $e");
    }
  }

  // Check if a product is wishlisted
  bool isWishlisted(int? productId) {
    if (productId == null) return false;
    return _wishlistedIds.contains(productId);
  }

  // Add a product explicitly to the wishlist if not present
  void addToWishlist(int? productId) {
    if (productId == null) return;
    if (!_wishlistedIds.contains(productId)) {
      _wishlistedIds.add(productId);
      _saveToPrefs();
      notifyListeners();
    }
  }

  // Toggle wishlist state
  void toggleWishlist(int? productId) {
    if (productId == null) return;
    if (_wishlistedIds.contains(productId)) {
      _wishlistedIds.remove(productId);
    } else {
      _wishlistedIds.add(productId);
    }
    _saveToPrefs();
    notifyListeners();
  }

  // Get list of active wishlisted products from any source list
  List<Product> getWishlistedProducts(List<Product> source) {
    return source.where((product) => product.id != null && _wishlistedIds.contains(product.id)).toList();
  }

  // Get total wishlist count
  int get wishlistCount => _wishlistedIds.length;
}
