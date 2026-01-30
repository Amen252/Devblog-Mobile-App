import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      if (result['success']) {
        _user = result['user'];
      } else {
        throw Exception(result['message']);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password, {required String gender}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.register(name, email, password, gender: gender);
      if (result['success']) {
        _user = result['user'];
      } else {
        throw Exception(result['message']);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(String name, String email, String gender) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await _apiService.updateProfile(name, email, gender);
      _user = updatedUser;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final me = await _apiService.getMe();
      if (me != null) {
        _user = me;
      }
    } catch (_) {
      // Ignore error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
