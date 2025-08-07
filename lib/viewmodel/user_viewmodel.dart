import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final profileData = await ApiService.getUserProfile(token);
      _user = UserModel.fromJson(profileData);

      await prefs.setString('user', jsonEncode(profileData));

      notifyListeners();
    } catch (e) {
      debugPrint('Gagal mengambil data profil dari server: $e');
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final decoded = jsonDecode(userJson);
      _user = UserModel.fromJson(decoded);
      notifyListeners();
    }
  }
}
