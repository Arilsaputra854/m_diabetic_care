import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService.loginUser(
      emailOrPhone: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', result.accessToken);
      await prefs.setString('user', jsonEncode(result.user.toJson()));

      debugPrint('✅ Login success. Token: ${result.accessToken}');
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user');
    debugPrint('🧹 Token and user cleared');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }

    return null;
  }
}
