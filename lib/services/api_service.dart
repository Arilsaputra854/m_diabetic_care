import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:m_diabetic_care/model/educational_content.dart';
import 'package:m_diabetic_care/services/responses/login_response.dart';

class ApiService {
  static const String baseUrl =
      'https://api-m-diabetic-staging.up.railway.app/api';

  /// 🔐 REGISTER
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String birthDate,
    required String gender, // "male" / "female"
    required String phone,
    required int weight,
    required int height,
    required bool familyDMHistory,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final body = {
      "fullname": name,
      "email": email,
      "phone_number": phone,
      "password": password,
      "password_confirmation": confirmPassword,
      "birth_date": birthDate,
      "gender": gender,
      "family_history": familyDMHistory ? "yes" : "no", // sesuai backend
      "weight": weight,
      "height": height,
      "role": "user",
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
      debugPrint('❌ Error saat register: $e');
      return false;
    }
  }

  /// 🔐 SEND OTP - Forgot Password
  static Future<bool> sendOtpForgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/send-otp');
    final body = {'email': email};

    debugPrint('POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Error send OTP: $e');
      return false;
    }
  }

  /// 🔐 RESET PASSWORD
  static Future<bool> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/reset');
    final body = {
      "password": password,
      "password_confirmation": passwordConfirmation,
      "reset_token": resetToken,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Error saat reset password: $e');
      return false;
    }
  }

  /// 🔐 VERIFY OTP
  static Future<Map<String, dynamic>?> verifyOtpForgotPassword({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password/verify-otp');
    final body = {'email': email, 'otp': otp};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // contains reset_token
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error verify OTP: $e');
      return null;
    }
  }

  /// 🔐 LOGIN
  static Future<LoginResponse?> loginUser({
    required String emailOrPhone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final body = {'email': emailOrPhone.toLowerCase(), 'password': password};

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
        final Map<String, dynamic> data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error login: $e');
      return null;
    }
  }

  /// 🍱 GET FOOD
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

  /// 🍱 POST FOOD
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

  /// 📚 GET Myths & Facts (with Auth Header)
  static Future<List<Map<String, dynamic>>> fetchMythsAndFacts(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/fact-myths');
    debugPrint('GET $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> data = body['data'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Gagal mengambil data fakta & mitos');
      }
    } catch (e) {
      debugPrint('❌ Error fetchMythsAndFacts: $e');
      rethrow;
    }
  }

  static Future<List<EducationalContent>> fetchEducationalVideos(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/educational-contents');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => EducationalContent.fromJson(item))
            .where((item) => item.type.toLowerCase() == 'video')
            .toList();
      } else {
        throw Exception('Failed to load educational content');
      }
    } catch (e) {
      debugPrint('❌ Error fetch videos: $e');
      rethrow;
    }
  }

  /// 📌 GET Posters (type = 'poster')
  static Future<List<EducationalContent>> fetchEducationalPosters(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/educational-contents');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => EducationalContent.fromJson(item))
            .where((item) => item.type.toLowerCase() == 'poster')
            .toList();
      } else {
        throw Exception('Failed to load poster content');
      }
    } catch (e) {
      debugPrint('❌ Error fetch posters: $e');
      rethrow;
    }
  }

  /// 📌 GET News (type = 'berita')
  static Future<List<EducationalContent>> fetchEducationalNews(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/educational-contents');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => EducationalContent.fromJson(item))
            .where((item) => item.type.toLowerCase() == 'berita')
            .toList();
      } else {
        throw Exception('Failed to load news content');
      }
    } catch (e) {
      debugPrint('❌ Error fetch news: $e');
      rethrow;
    }
  }
}
