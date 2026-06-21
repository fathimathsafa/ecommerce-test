import 'package:flutter/material.dart';

class ProductDetailsController extends ChangeNotifier {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  PageController get imagePageController => _imagePageController;
  int get currentImageIndex => _currentImageIndex;

  void updateImageIndex(int index) {
    if (_currentImageIndex == index) return;
    _currentImageIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }
}
