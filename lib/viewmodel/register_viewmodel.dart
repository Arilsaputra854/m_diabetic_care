import 'package:flutter/foundation.dart';
import 'package:m_diabetic_care/services/api_service.dart';

class RegisterViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String birthDate,
    required String gender,
    required String phone,
    required int weight,
    required int height,
    required bool familyDMHistory,
  }) async {
    isLoading = false;
    notifyListeners();

    final success = await ApiService.registerUser(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      birthDate: birthDate,
      gender: gender,
      phone: phone,
      weight: weight,
      height: height,
      familyDMHistory: familyDMHistory,
    );

    isLoading = false;
    notifyListeners();

    return success;
  }
}
