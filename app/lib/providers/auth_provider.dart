import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// AuthProvider: Fasalkan wuxuu maamulaa dhammaan hannaanka aqoonsiga (Authentication).
// Wuxuu hubiyaa inuu qofku galay app-ka iyo xogta uu leeyahay.
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Xogta qofka (User) hadda isticmaalaya app-ka
  User? _user; 
  
  // Maqaamka rarka (Loading) si UI-ga loogu muujiyo 'CircularProgressIndicator'
  bool _isLoading = false; 

  // Meesha laga aqrinayo xogta isticmaalaha
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  // Hubinta haddii uu user-ku 'authenticated' yahay iyo haddii kale
  bool get isAuthenticated => _user != null;

  // login: Shaqada lagu galayo app-ka (Login logic)
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

  // register: Shaqada is-diiwaangelinta user cusub (Sign Up)
  Future<void> register(String name, String email, String password, {required String gender}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.register(name, email, password, gender: gender);
      if (result['success']) {
        _user = result['user']; // Marka is-diiwaangelintu dhamaato, si toos ah app-ka u gal
      } else {
        throw Exception(result['message']);
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // UI-ga u sheeg inuu isbeddelay
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

  // tryAutoLogin: Shaqadan waxay isku daydaa inay user-ka hore u soo gasho (Auto-login).
  // Waxay ka akhrisaa token-ka SharedPreferences marka app-ka la bilaabo.
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final me = await _apiService.getMe(); // Xogta user-ka ka soo weydii backend-ka
      if (me != null) {
        _user = me; // Haddii uu token-ku shaqeynayo, dhig user-ka halkan
      }
    } catch (_) {
      // Halkan waxaa la qabanayaa wixii khaladaad ah ee ka yimaada xiriirka
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

