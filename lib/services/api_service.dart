import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:m_diabetic_care/model/educational_content.dart';
import 'package:m_diabetic_care/model/food.dart';
import 'package:m_diabetic_care/model/meal.dart';
import 'package:m_diabetic_care/model/obat.dart';
import 'package:m_diabetic_care/model/olahraga.dart';
import 'package:m_diabetic_care/services/responses/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://148.230.97.120/diabetic/api';

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

  /// 🔐 Submit Food
  static Future<bool> submitMealInput({
    required String token,
    required String mealType,
    required FoodModel food,
  }) async {
    final url = Uri.parse('$baseUrl/meal-inputs');
    final now = formatDateWithOffset(DateTime.now());

    final body = {
      "meal_type": mealType.toLowerCase(),
      "time": now,
      "food_id": food.id,
      "manual_name": food.name,
      "carbs": food.carbs,
      "sugar": food.sugar,
      "calories": food.calories,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('POST /meal-inputs -> ${response.statusCode}');
      debugPrint(response.body);

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('❌ Error submitMealInput: $e');
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
    required String token,
    required String name,
    required double carbs,
    required double sugar,
    required int calories,
    required String brand,
    required double protein,
    required double fat,
    required String category,
  }) async {
    final url = Uri.parse('$baseUrl/foods');
    final body = {
      'name': name,
      'carbs': carbs,
      'sugar': sugar,
      'calories': calories,
      'brand': brand,
      'protein': protein,
      'fat': fat,
      'category': category,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('❌ Error create food: $e');
      return false;
    }
  }

  /// 📚 GET Myths & Facts (with Auth Header)
  static Future<List<Map<String, dynamic>>> fetchMythsAndFacts(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/fact-myths');
    debugPrint('Token $token');
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

  /// 📌 GET Foods
  static Future<List<FoodModel>> fetchFoods(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/foods'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FoodModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data makanan');
    }
  }

  /// 📌 UPDATE BMI
  static Future<bool> updateUserBmi({
    required String token,
    required double bmi,
  }) async {
    final url = Uri.parse('$baseUrl/user/profile');
    final body = {'bmi': bmi.toStringAsFixed(1)};

    debugPrint('PUT $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Error update BMI: $e');
      return false;
    }
  }

  static Future<List<MealInputModel>> fetchMealInputs(String token) async {
    final url = Uri.parse('$baseUrl/meal-inputs');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MealInputModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil meal inputs');
    }
  }

  static Future<bool> submitMedicationReminder({
    required String token,
    required String medicationName,
    required String dosage,
    required String time,
    required String type,
    required String notes,
  }) async {
    final url = Uri.parse('$baseUrl/medication-reminders');

    final body = {
      "medication_name": medicationName,
      "dosage": dosage,
      "time": time,
      "type": type,
      "notes": notes,
    };

    debugPrint('POST /medication-reminders');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('❌ Error submitMedicationReminder: $e');
      return false;
    }
  }

  static Future<List<ExerciseReminder>> getExerciseReminders(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercise-reminders'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ExerciseReminder.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data latihan');
    }
  }

  static Future<ExerciseReminder> createExerciseReminder(
  String token,
  Map<String, dynamic> body,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/exercise-reminders'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 201) {
    final json = jsonDecode(response.body);
    final data = json['data']; // ambil objek "data"
    return ExerciseReminder.fromJson(data); // parsing hanya "data"
  } else {
    throw Exception('Gagal membuat latihan: ${response.body}');
  }
}


  // DELETE
  static Future<void> deleteExerciseReminder(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/exercise-reminders/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus latihan');
    }
  }

  // UPDATE
  static Future<void> updateExerciseReminder(
    String token,
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/exercise-reminders/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui latihan');
    }
  }

  static Future<void> updateMedicationReminder(String token, Obat obat) async {
    final response = await http.put(
      Uri.parse('$baseUrl/medication-reminders/${obat.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'medication_name': obat.nama,
        'dosage': obat.dosage,
        'time': obat.jadwal,
        'type': obat.tipe,
        'notes': obat.keterangan,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengedit obat');
    }
  }

  static Future<void> deleteMedicationReminder(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.delete(
      Uri.parse('$baseUrl/medication-reminders/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus obat');
    }
  }

  static Future<List<Obat>> getMedicationReminders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/medication-reminders'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Ubah List<Map<String, dynamic>> menjadi List<Obat>
      return (data as List).map((json) => Obat.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data profil');
    }
  }

  static Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.put(
      Uri.parse('${baseUrl}/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }
}

String formatDateWithOffset(DateTime dateTime) {
  final duration = dateTime.timeZoneOffset;
  final hours = duration.inHours.abs().toString().padLeft(2, '0');
  final minutes = (duration.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = duration.isNegative ? '-' : '+';
  final offset = '$sign$hours:$minutes';

  return dateTime.toIso8601String().split('.').first + offset;
}
