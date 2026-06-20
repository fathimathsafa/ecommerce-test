import 'package:flutter/material.dart';
import '../../../data/models/product.dart';
import '../../wishlist/controller/wishlist_controller.dart';

/// Controller class managing the state of the home screen / product listing.
/// Extends [ChangeNotifier] to trigger UI updates reactively.
class HomeController extends ChangeNotifier {
  // Store all products
  final List<Product> _allProducts = [];
  
  // Store currently visible products (after search/category filtering)
  List<Product> _filteredProducts = [];
  
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Product> get products => _filteredProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Retrieve unique categories dynamically based on products plus "All"
  List<String> get categories {
    final Set<String> uniqueCats = {'All'};
    for (var product in _allProducts) {
      uniqueCats.add(product.category);
    }
    return uniqueCats.toList();
  }

  // Constructor
  HomeController() {
    _loadInitialProducts();
  }

  /// Simulates loading data from an API or database
  Future<void> _loadInitialProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1000));

    _allProducts.clear();
    _allProducts.addAll(Product.getDummyProducts());
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  /// Public reload/refresh method for RefreshIndicator
  Future<void> refreshProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network pull-to-refresh delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Reload mock data
    _allProducts.clear();
    _allProducts.addAll(Product.getDummyProducts());
    
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  /// Sets the active category filter
  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Updates the active search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Toggles the wishlist status of a product by ID
  void toggleWishlist(String id) {
    WishlistController.instance.toggleWishlist(id);
  }

  /// Core logic to filter products based on active category and search queries
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' || 
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      
      final matchesSearch = _searchQuery.isEmpty || 
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList();
  }
}
