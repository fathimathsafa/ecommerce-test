import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ewire/data/model/product_model.dart';

class WishlistController extends ChangeNotifier {
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

  bool isWishlisted(int? productId) {
    if (productId == null) return false;
    return _wishlistedIds.contains(productId);
  }

  void addToWishlist(int? productId) {
    if (productId == null) return;
    if (!_wishlistedIds.contains(productId)) {
      _wishlistedIds.add(productId);
      _saveToPrefs();
      notifyListeners();
    }
  }

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

  List<Product> getWishlistedProducts(List<Product> source) {
    return source.where((product) => product.id != null && _wishlistedIds.contains(product.id)).toList();
  }

  int get wishlistCount => _wishlistedIds.length;
}
