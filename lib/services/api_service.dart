import 'dart:convert';
import 'dart:async'; // Untuk Timeout
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
  static const Duration timeoutDuration = Duration(seconds: 15);

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

    debugPrint('🚀 POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
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

    debugPrint('🚀 POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
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

    debugPrint('🚀 POST $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
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

    debugPrint('🚀 POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
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

    debugPrint('🚀 POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

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

    debugPrint('🚀 POST $url');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

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

  /// 🍱 GET FOOD (List)
  static Future<List<Map<String, dynamic>>> fetchFoodList() async {
    final url = Uri.parse('$baseUrl/food');
    debugPrint('🚀 GET $url');

    try {
      final response = await http.get(url).timeout(timeoutDuration);
      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint('Gagal mengambil data makanan: ${response.reasonPhrase}');
        throw Exception('Gagal mengambil data makanan');
      }
    } catch (e) {
      debugPrint('❌ Error fetchFoodList: $e');
      rethrow;
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

    debugPrint('🚀 POST $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
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
    debugPrint('🚀 GET $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

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

  /// 📚 GET Educational Videos
  static Future<List<EducationalContent>> fetchEducationalVideos(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/educational-contents');
    debugPrint('🚀 GET $url (Type: Video)');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

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
    debugPrint('🚀 GET $url (Type: Poster)');
    debugPrint('Headers: Authorization: Bearer $token');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

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
    debugPrint('🚀 GET $url (Type: Berita)');
    debugPrint('Headers: Authorization: Bearer $token');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

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
    final url = Uri.parse('$baseUrl/foods');
    debugPrint('🚀 GET $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FoodModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data makanan');
      }
    } catch (e) {
      debugPrint('❌ Error fetchFoods: $e');
      rethrow;
    }
  }

  /// 📌 UPDATE BMI
  static Future<bool> updateUserBmi({
    required String token,
    required double bmi,
  }) async {
    final url = Uri.parse('$baseUrl/user/profile');
    final body = {'bmi': bmi.toStringAsFixed(1)};

    debugPrint('🚀 PUT $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Error update BMI: $e');
      return false;
    }
  }

  /// 📌 GET Meal Inputs
  static Future<List<MealInputModel>> fetchMealInputs(String token) async {
    final url = Uri.parse('$baseUrl/meal-inputs');
    debugPrint('🚀 GET $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => MealInputModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil meal inputs');
      }
    } catch (e) {
      debugPrint('❌ Error fetchMealInputs: $e');
      rethrow;
    }
  }

  /// 💊 POST Medication Reminder
  static Future<Obat?> submitMedicationReminder({
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

    debugPrint('🚀 POST $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Obat.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error submitMedicationReminder: $e');
      return null;
    }
  }

  /// 💊 GET Medication Reminders
  static Future<List<Obat>> getMedicationReminders(String token) async {
    final url = Uri.parse('$baseUrl/medication-reminders');
    debugPrint('🚀 GET $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((json) => Obat.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error getMedicationReminders: $e');
      return [];
    }
  }

  /// 💊 PUT Medication Reminder
  static Future<Obat> updateMedicationReminder(String token, Obat obat) async {
    final url = Uri.parse('$baseUrl/medication-reminders/${obat.id}');
    final body = {
      'medication_name': obat.nama,
      'dosage': obat.dosage,
      'time': obat.jadwal,
      'type': obat.tipe,
      'notes': obat.keterangan,
    };

    debugPrint('🚀 PUT $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Obat.fromJson(data['data']); // Sesuaikan dgn struktur JSON API
      } else {
        throw Exception('Gagal mengedit obat: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error updateMedicationReminder: $e');
      rethrow;
    }
  }

  /// 💊 DELETE Medication Reminder
  static Future<void> deleteMedicationReminder(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('$baseUrl/medication-reminders/$id');

    debugPrint('🚀 DELETE $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus obat');
      }
    } catch (e) {
      debugPrint('❌ Error deleteMedicationReminder: $e');
      rethrow;
    }
  }

  /// 🏃‍♂️ GET Exercise Reminders
  static Future<List<ExerciseReminder>> getExerciseReminders(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/exercise-reminders');
    debugPrint('🚀 GET $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => ExerciseReminder.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data latihan');
      }
    } catch (e) {
      debugPrint('❌ Error getExerciseReminders: $e');
      rethrow;
    }
  }

  /// 🏃‍♂️ POST Exercise Reminder
  static Future<ExerciseReminder> createExerciseReminder(
    String token,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/exercise-reminders');
    debugPrint('🚀 POST $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final data = json['data']; // ambil objek "data"
        return ExerciseReminder.fromJson(data); // parsing hanya "data"
      } else {
        throw Exception('Gagal membuat latihan: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error createExerciseReminder: $e');
      rethrow;
    }
  }

  /// 🏃‍♂️ DELETE Exercise Reminder
  static Future<void> deleteExerciseReminder(String token, int id) async {
    final url = Uri.parse('$baseUrl/exercise-reminders/$id');
    debugPrint('🚀 DELETE $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      ).timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus latihan');
      }
    } catch (e) {
      debugPrint('❌ Error deleteExerciseReminder: $e');
      rethrow;
    }
  }

  /// 🏃‍♂️ UPDATE Exercise Reminder
  static Future<void> updateExerciseReminder(
    String token,
    int id,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/exercise-reminders/$id');
    debugPrint('🚀 PUT $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(body)}');

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Gagal memperbarui latihan');
      }
    } catch (e) {
      debugPrint('❌ Error updateExerciseReminder: $e');
      rethrow;
    }
  }

  /// 👤 GET User Profile
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    final url = Uri.parse('$baseUrl/user/profile');
    debugPrint('🚀 GET $url');
    debugPrint('Headers: Authorization: Bearer $token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      debugPrint(
          '✅ Response User Profile [${response.statusCode}]: ${response.body}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil data profil');
      }
    } catch (e) {
      debugPrint('❌ Error getUserProfile: $e');
      rethrow;
    }
  }

  /// 👤 PUT User Profile
  static Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('${baseUrl}/user/profile');

    debugPrint('🚀 PUT $url');
    debugPrint('Headers: Authorization: Bearer $token');
    debugPrint('Body: ${jsonEncode(data)}');

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          )
          .timeout(timeoutDuration);

      debugPrint('✅ Response [${response.statusCode}]: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Error updateUserProfile: $e');
      return false;
    }
  }
}

// Helper Function
String formatDateWithOffset(DateTime dateTime) {
  final duration = dateTime.timeZoneOffset;
  final hours = duration.inHours.abs().toString().padLeft(2, '0');
  final minutes = (duration.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = duration.isNegative ? '-' : '+';
  final offset = '$sign$hours:$minutes';

  // Format: 2023-10-27T10:00:00+07:00
  return dateTime.toIso8601String().split('.').first + offset;
}