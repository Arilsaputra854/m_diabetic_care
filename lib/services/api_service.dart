import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://api-m-diabetic-staging.up.railway.app/api';

  // GET /food
  static Future<List<Map<String, dynamic>>> fetchFoodList() async {
    final url = Uri.parse('$baseUrl/food');
    debugPrint('GET $url');

    final response = await http.get(url);
    debugPrint('Response [${response.statusCode}]: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      debugPrint('Gagal mengambil data makanan: ${response.reasonPhrase}');
      throw Exception('Gagal mengambil data makanan');
    }
  }

  // POST /food
  static Future<bool> createFood({
    required String name,
    required int calories,
    required int carbs,
    required int sugar,
  }) async {
    final url = Uri.parse('$baseUrl/food');
    final body = {
      'name': name,
      'calories': calories,
      'carbohydrates': carbs,
      'sugar': sugar,
    };

    debugPrint('POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    debugPrint('Response [${response.statusCode}]: ${response.body}');
    return response.statusCode == 201;
  }

  // POST /auth/register
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String birthDate,
    required String gender, // "male" or "female"
    required String phone,
    required int weight,
    required int height,
    required bool familyDMHistory,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final body = {
      'fullname': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'birth_date': birthDate,
      'gender': gender, // pastikan sudah "male" / "female"
      'phone': phone,
      'weight': weight,
      'height': height,
      'familyDMHistory': familyDMHistory,
    };

    debugPrint('POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error saat register: $e');
      return false;
    }
  }
  static Future<bool> loginUser({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/auth/login');
  final body = {
    'login': email,
    'password': password,
  };

  debugPrint('POST $url');
  debugPrint('Body: ${jsonEncode(body)}');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    debugPrint('Response [${response.statusCode}]: ${response.body}');

    if (response.statusCode == 200) {
      // Simpan token jika perlu
      final data = jsonDecode(response.body);
      final token = data['token']; // atau 'access_token'
      debugPrint('Login berhasil. Token: $token');

      // simpan token ke SharedPreferences jika dibutuhkan nanti
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint('Error login: $e');
    return false;
  }
}

}
