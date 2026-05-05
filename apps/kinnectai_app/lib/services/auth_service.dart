import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    // Implement login logic with backend API
    // Use HTTP to call /api/v1/auth/login
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    // Implement register logic
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}