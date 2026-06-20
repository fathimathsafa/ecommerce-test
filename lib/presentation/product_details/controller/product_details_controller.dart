import 'package:flutter/material.dart';

/// Local controller class managing active UI selections on the Product Details screen.
class ProductDetailsController extends ChangeNotifier {
  // Pre-configured options
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> colors = [
    const Color(0xFF0F172A), // Slate 900
    const Color(0xFF6366F1), // Indigo 500
    const Color(0xFFEF4444), // Red 500
    const Color(0xFF10B981), // Emerald 500
  ];

  String _selectedSize = 'M';
  int _selectedColorIndex = 1; // Indigo 500

  // Getters
  String get selectedSize => _selectedSize;
  int get selectedColorIndex => _selectedColorIndex;
  Color get selectedColor => colors[_selectedColorIndex];

  // Actions
  void setSize(String size) {
    if (_selectedSize == size) return;
    _selectedSize = size;
    notifyListeners();
  }

  void setColorIndex(int index) {
    if (_selectedColorIndex == index) return;
    _selectedColorIndex = index;
    notifyListeners();
  }
}
