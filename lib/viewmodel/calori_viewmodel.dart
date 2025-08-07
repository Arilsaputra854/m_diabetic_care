import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KaloriViewModel extends ChangeNotifier {
 int _totalCalories = 0;
  int _targetCalories = 2000;
  bool _isLoaded = false;

  int get totalCalories => _totalCalories;
  int get targetCalories => _targetCalories;
  bool get isLoaded => _isLoaded;

  // Setter dan save ke SharedPreferences
  void setKalori(int total, int target) async {
    _totalCalories = total;
    _targetCalories = target;
    debugPrint('[KaloriViewModel] setKalori: total=$_totalCalories, target=$_targetCalories');
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('today_calories', _totalCalories);
    await prefs.setInt('target_calories', _targetCalories);
    debugPrint('[KaloriViewModel] _saveToPrefs: saved total=$_totalCalories, target=$_targetCalories');
  }

 Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _totalCalories = prefs.getInt('today_calories') ?? 0;
    _targetCalories = prefs.getInt('target_calories') ?? 2000;
    _isLoaded = true;
    debugPrint('[KaloriViewModel] loadFromPrefs: loaded total=$_totalCalories, target=$_targetCalories');
    notifyListeners();
  }

  Future<void> resetKalori() async {
    _totalCalories = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('today_calories', _totalCalories);
    debugPrint('[KaloriViewModel] resetKalori: total reset to $_totalCalories');
  }
}
