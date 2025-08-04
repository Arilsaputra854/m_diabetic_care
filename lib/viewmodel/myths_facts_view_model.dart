import 'dart:math';
import 'package:flutter/material.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MythsFactsViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _allFacts = [];
  Map<String, dynamic>? _currentQuestion;
  String? _userAnswer;
  bool _isLoading = true;
  bool _isError = false;

  Map<String, dynamic>? get currentQuestion => _currentQuestion;
  String? get userAnswer => _userAnswer;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  bool get isCorrect => _userAnswer == 'Mitos'; // default benar = Mitos

  Future<void> fetchData() async {
    _isLoading = true;
    _isError = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      _allFacts = await ApiService.fetchMythsAndFacts(token);
      _pickRandom();
    } catch (e) {
      _isError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void _pickRandom() {
    if (_allFacts.isNotEmpty) {
      final random = Random();
      _currentQuestion = _allFacts[random.nextInt(_allFacts.length)];
      _userAnswer = null;
    }
  }

  void selectAnswer(String answer) {
    if (_userAnswer == null) {
      _userAnswer = answer;
      notifyListeners();
    }
  }

  void nextQuestion() {
    _pickRandom();
    notifyListeners();
  }
}
