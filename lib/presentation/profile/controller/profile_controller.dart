import 'package:flutter/material.dart';

/// Controller to manage profile details and state.
class ProfileController extends ChangeNotifier {
  String _userName = 'Demo User';
  String _userEmail = 'demouser@swiftcart.com';
  final String _membership = 'Gold Member';
  final int _activeOrdersCount = 3;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get membership => _membership;
  int get activeOrdersCount => _activeOrdersCount;

  /// Updates the user profile name and email
  void updateProfile(String name, String email) {
    if (name.trim().isNotEmpty) {
      _userName = name.trim();
    }
    if (email.trim().isNotEmpty) {
      _userEmail = email.trim();
    }
    notifyListeners();
  }
}
