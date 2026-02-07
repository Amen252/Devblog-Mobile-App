import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// AuthProvider waa maskaxda Authentication-ka app-ka
// Isaga ayaa maamula gelitaan, isdiiwaangelin, logout, iyo xogta user-ka
class AuthProvider with ChangeNotifier {

  // ApiService ayaa la hadlaya backend-ka
  final ApiService _apiService = ApiService();

  // User-ka hadda ku jira app-ka (haddii uusan jirin = null)
  User? _user;

  // Waxaa loo adeegsadaa in UI-ga loo sheego in wax soconayaan
  bool _isLoading = false;

  // UI-ga halka uu ka akhrisanayo user-ka
  User? get user => _user;

  // UI-ga halka uu ka ogaanayo loading
  bool get isLoading => _isLoading;

  // Hubin fudud: user ma jiraa mise maya
  bool get isAuthenticated => _user != null;

  //LOGIN
  // Shaqadan waxaa loo adeegsadaa gelitaanka user-ka
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // UI-ga u sheeg in loading bilaabmay

    try {
      final result = await _apiService.login(email, password);

      if (result['success']) {
        // Haddii login-ku guuleysto, kaydi user-ka
        _user = result['user'];
      } else {
        throw Exception(result['message']);
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // UI-ga u sheeg in loading dhamaaday
    }
  }

  //  REGISTER 
  // Shaqadan waxay diiwaangelisaa user cusub
  Future<void> register(
    String name,
    String email,
    String password, {
    required String gender,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.register(
        name,
        email,
        password,
        gender: gender,
      );

      if (result['success']) {
        // Marka isdiiwaangelintu dhamaato, user-ka geli app-ka
        _user = result['user'];
      } else {
        throw Exception(result['message']);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  UPDATE PROFILE 
  // Shaqadan waxay cusboonaysiisaa xogta user-ka
  Future<void> updateProfile(String name, String email, String gender) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser =
          await _apiService.updateProfile(name, email, gender);

      // Xogta cusub ku beddel tan hore
      _user = updatedUser;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  LOGOUT 
  // Shaqadan waxay ka saartaa user-ka app-ka
  Future<void> logout() async {
    await _apiService.logout();
    _user = null;

    // UI-ga isla markiiba dib ugu celi login screen
    notifyListeners();
  }

  //  AUTO LOGIN
  // Shaqadan waxay hubisaa in user hore u galay
  // Marka app-ka la furo
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final me = await _apiService.getMe();

      // Haddii token-ku shaqeynayo, user-ka si toos ah u gal
      if (me != null) {
        _user = me;
      }
    } catch (_) {
      // Haddii wax qaldamaan, iska dhaaf
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
