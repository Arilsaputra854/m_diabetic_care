import 'package:flutter/material.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiViewModel extends ChangeNotifier {
  double? bmi;
  bool isLoading = false;

  Future<bool> updateBmi(double height, double weight) async {
    if (height <= 0 || weight <= 0) return false;

    isLoading = true;
    notifyListeners();

    final calculated = weight / ((height / 100) * (height / 100));
    bmi = calculated;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    final success = await ApiService.updateUserBmi(token: token, bmi: bmi!);

    isLoading = false;
    notifyListeners();
    return success;
  }
}
