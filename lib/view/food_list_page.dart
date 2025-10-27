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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFoodDialog(context),
        child: const Icon(Icons.add),
      ),

      appBar: AppBar(title: Text('Pilih Makanan (${widget.mealType})')),
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
                  return const Center(
                    child: Text('Tidak ada makanan tersedia.'),
                  );
                }

                return ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ListTile(
                        // FIX: Tambahkan '??' untuk memberi nilai default jika 'name' null
                        title: Text(food.name ?? 'Nama Makanan T/A'),
                        
                        // FIX (Proaktif): Beri nilai default 0 jika calories/carbs null
                        subtitle: Text(
                          '${food.calories?.toInt() ?? 0} kcal • ${food.carbs ?? 0}g Karbohidrat',
                        ),
                        
                        trailing: const Icon(Icons.add),
                        onTap: () async {
                          // ... (Sisa kode onTap Anda tidak perlu diubah)
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('access_token');

                          if (token == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Token tidak ditemukan'),
                              ),
                            );
                            return;
                          }
                          final mealType = mapMealType(widget.mealType);

                          final success = await ApiService.submitMealInput(
                            token: token,
                            mealType: mealType,
                            food: food,
                          );

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  // FIX: Pastikan food.name tidak null saat ditampilkan
                                  '${food.name ?? 'Makanan'} berhasil ditambahkan ke ${widget.mealType}',
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal menambahkan ${food.name ?? 'makanan'}',
                                ),
                              ),
                            );
                          }
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

  void _showAddFoodDialog(BuildContext context) {
    final nameController = TextEditingController();
    final carbsController = TextEditingController();
    final sugarController = TextEditingController();
    final caloriesController = TextEditingController();
    final brandController = TextEditingController();
    final proteinController = TextEditingController();
    final fatController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Makanan'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildInput('Nama', nameController),
                _buildInput('Karbohidrat', carbsController, isNumber: true),
                _buildInput('Gula', sugarController, isNumber: true),
                _buildInput('Kalori', caloriesController, isNumber: true),
                _buildInput('Merek', brandController),
                _buildInput('Protein', proteinController, isNumber: true),
                _buildInput('Lemak', fatController, isNumber: true),
                _buildInput('Kategori', categoryController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('access_token');

                if (token == null) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token tidak ditemukan')),
                  );
                  return;
                }

                final success = await ApiService.createFood(
                  token: token,
                  name: nameController.text,
                  carbs: double.tryParse(carbsController.text) ?? 0,
                  sugar: double.tryParse(sugarController.text) ?? 0,
                  calories: int.tryParse(caloriesController.text) ?? 0,
                  brand: brandController.text,
                  protein: double.tryParse(proteinController.text) ?? 0,
                  fat: double.tryParse(fatController.text) ?? 0,
                  category: categoryController.text,
                );

                Navigator.pop(ctx);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Makanan berhasil ditambahkan'),
                    ),
                  );
                  setState(() {
                    _foodsFuture = _loadFoods(); // refresh
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menambahkan makanan')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

String mapMealType(String indoType) {
  switch (indoType.toLowerCase()) {
    case 'sarapan':
      return 'breakfast';
    case 'camilan pagi':
    case 'cemilan pagi':
      return 'morning_snack';
    case 'makan siang':
      return 'lunch';
    case 'camilan sore':
    case 'cemilan sore':
      return 'afternoon_snack';
    case 'makan malam':
      return 'dinner';
    default:
      return 'other'; // fallback
  }
}
