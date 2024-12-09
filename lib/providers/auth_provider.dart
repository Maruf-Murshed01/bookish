import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userType = ''; // 'buyer' or 'seller'

  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;

  Future<bool> login(String username, String password) async {
    if (username == 'admin' && password == 'admin') {
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userType = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }
}
