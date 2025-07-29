import 'package:flutter/foundation.dart';
import 'package:m_diabetic_care/services/api_service.dart';

class LoginViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await ApiService.loginUser(email: email, password: password);

    _isLoading = false;
    notifyListeners();

    return success;
  }
}
