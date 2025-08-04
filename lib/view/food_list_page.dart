import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_diabetic_care/model/food.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';

class FoodListPage extends StatefulWidget {
  final String mealType;
  const FoodListPage({super.key, required this.mealType});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  late Future<List<FoodModel>> _foodsFuture;
  double? _targetMealCalories;

  final Map<String, double> mealDistribution = {
    'sarapan': 0.2,
    'camilan pagi': 0.1,
    'makan siang': 0.3,
    'camilan sore': 0.1,
    'makan malam': 0.25,
  };

  @override
  void initState() {
    super.initState();
    _foodsFuture = _loadFoods();
    _calculateTargetMealCalories();
  }

  Future<void> _calculateTargetMealCalories() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) return;

    final user = UserModel.fromJson(jsonDecode(userJson));
    double? bmi = user.bmi;

    int totalCalories;
    if (bmi == null) {
      totalCalories = 2000;
    } else if (bmi < 18.5) {
      totalCalories = 2100;
    } else if (bmi <= 22.9) {
      totalCalories = 2500;
    } else {
      totalCalories = 1500;
    }

    final key = widget.mealType.toLowerCase();
    final ratio = mealDistribution[key] ?? 0.2;
    final result = totalCalories * ratio;

    setState(() {
      _targetMealCalories = result;
    });
  }

  Future<List<FoodModel>> _loadFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    return await ApiService.fetchFoods(token);
  }

  @override
  Widget build(BuildContext context) {
    final kcal = _targetMealCalories?.toStringAsFixed(0) ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Makanan (${widget.mealType})'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_targetMealCalories != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Target kalori untuk ${widget.mealType}: $kcal kkal',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<FoodModel>>(
              future: _foodsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final foods = snapshot.data ?? [];

                if (foods.isEmpty) {
                  return const Center(child: Text('Tidak ada makanan tersedia.'));
                }

                return ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(food.name),
                        subtitle: Text('${food.calories.toInt()} kcal • ${food.carbs}g Karbohidrat'),
                        trailing: const Icon(Icons.add),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Dipilih: ${food.name}')),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
