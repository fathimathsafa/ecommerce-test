import 'dart:async';
import 'package:ewire/data/model/product_model.dart';
import 'package:flutter/material.dart';
import '../../../data/services/api_service.dart';

class HomeController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  final List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  int _currentPromoIndex = 0;
  final PageController _pageController = PageController();
  Timer? _promoTimer;

  // Getters
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPromoIndex => _currentPromoIndex;
  PageController get pageController => _pageController;

  /// Retrieve top 3 highest discount products for promo banner
  List<Product> get promoProducts {
    if (_allProducts.isEmpty) return [];
    final sorted = List<Product>.from(_allProducts)
      ..sort((a, b) => (b.discountPercentage ?? 0.0).compareTo(a.discountPercentage ?? 0.0));
    return sorted.take(3).toList();
  }

  /// Update current active promo index and notify listeners for dynamic appbar updates
  void updatePromoIndex(int index) {
    if (_currentPromoIndex == index) return;
    _currentPromoIndex = index;
    notifyListeners();
  }

  /// Retrieve unique category list dynamically from loaded products
  List<String> get categories {
    final Set<String> uniqueCats = {'All'};
    for (var product in _allProducts) {
      if (product.category != null) {
        final catName = categoryValues.reverse[product.category];
        if (catName != null && catName.isNotEmpty) {
          // Capitalize first letter (e.g. "beauty" -> "Beauty")
          uniqueCats.add(catName[0].toUpperCase() + catName.substring(1));
        }
      }
    }
    return uniqueCats.toList();
  }

  // Constructor
  HomeController() {
    loadProducts();
    _startPromoTimer();
  }

  /// Starts periodic timer to scroll promo banner
  void _startPromoTimer() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final promoCount = promoProducts.length;
        if (promoCount > 0) {
          final nextPage = (_currentPromoIndex + 1) % promoCount;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Fetches products listing from API service
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final model = await _apiService.fetchProducts();
      _allProducts.clear();
      if (model.products != null) {
        _allProducts.addAll(model.products!);
      }
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reloads products (pull-to-refresh)
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  /// Sets active category filter
  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Updates active search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Core logic to filter products based on active category and search queries
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Get category string name
      final catName = product.category != null ? categoryValues.reverse[product.category] : null;
      final displayCat = catName != null ? (catName[0].toUpperCase() + catName.substring(1)) : '';

      final matchesCategory = _selectedCategory == 'All' || 
          displayCat.toLowerCase() == _selectedCategory.toLowerCase();
      
      final matchesSearch = _searchQuery.isEmpty || 
          (product.title != null && product.title!.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          (product.description != null && product.description!.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          (product.tags != null && product.tags!.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase())));

      return matchesCategory && matchesSearch;
    }).toList();
  }
}
