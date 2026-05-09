import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthService with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _currentUser;
  String? _errorMessage;
  String? _pendingEmail;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  String? get pendingEmail => _pendingEmail;

  Future<void> login(String email, String password) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();
      
      final response = await _apiService.login(email, password);
      _isLoggedIn = true;
      _currentUser = response['user']?['name'] ?? email;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();
      
      final response = await _apiService.register(email, password, name);
      _isLoggedIn = true;
      _currentUser = response['user']?['name'] ?? name;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> sendOTPEmail(String email) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      _pendingEmail = email;
      notifyListeners();
      
      // Call API to send OTP email
      // This would typically call an endpoint like /api/v1/auth/otp/send
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _pendingEmail = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();
      
      // Call API to verify OTP
      // This would typically call an endpoint like /api/v1/auth/otp/verify
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _isLoggedIn = true;
      _currentUser = email;
      _pendingEmail = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
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