import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// AuthProvider: Waxay mas'uul ka tahay maamulidda xogta isticmaalaha (User State)
// iyo hubinta inuu qofku galay app-ka iyo in kale.
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user; // Xogta qofka hadda isticmaalaya app-ka
  bool _isLoading = false; // Maqaamka rarka (Loading status)

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Shaqada Login-ka: Waxay la xiriirtaa API-ga si loo xaqiijiyo user-ka.
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Waxay u sheegtaa UI-ga inuu is beddelo (Loading start)

    try {
      final result = await _apiService.login(email, password);
      if (result['success']) {
        _user = result['user']; // Haddii uu guuleysto, xogta isticmaalaha baa la kaydiyaa
      } else {
        throw Exception(result['message']);
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // UI-ga ayaa la cusubaysiiyaa (Loading end)
    }
  }

  // Shaqada Is-diiwaangelinta: Waxay abuurtaa isticmaale cusub backend-ka.
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

  // Shaqadan waxay cusubaysaa xogta u gaarka ah isticmaalaha.
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

  // Shaqada Ka-bixista (Logout): Waxay tirtirtaa xogta isticmaalaha.
  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners(); // UI-ga ayaa isla markiiba dib u noqonaya Login screen
  }

  // Shaqadan waxay isku daydaa inay qofka gashiso app-ka si toos ah (Auto-login)
  // iyadoo la helayo token-ka hore u kaydsanaa.
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final me = await _apiService.getMe();
      if (me != null) {
        _user = me;
      }
    } catch (_) {
      // Wixii khalad ah halkan waa lagu iska indha tiri karaa.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

