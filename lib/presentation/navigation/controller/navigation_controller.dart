import 'package:flutter/material.dart';

/// Singleton controller managing the active bottom navigation tab index.
class NavigationController extends ChangeNotifier {
  NavigationController._internal();

  static final NavigationController instance = NavigationController._internal();

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
