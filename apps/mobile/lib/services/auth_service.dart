import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthService with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoggedIn = false;
  String? _currentUser;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    try {
      _errorMessage = null;
      notifyListeners();
      
      final response = await _apiService.login(email, password);
      _isLoggedIn = true;
      _currentUser = response['user']?['name'] ?? email;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _errorMessage = null;
      notifyListeners();
      
      final response = await _apiService.register(email, password, name);
      _isLoggedIn = true;
      _currentUser = response['user']?['name'] ?? name;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void logout() {
    _apiService.clearToken();
    _isLoggedIn = false;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}