import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/meal.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:m_diabetic_care/view/food_list_page.dart';
import 'package:m_diabetic_care/viewmodel/calori_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakanPage extends StatefulWidget {
  const MakanPage({super.key});

  @override
  State<MakanPage> createState() => _MakanPageState();
}

class _MakanPageState extends State<MakanPage> {
  double? bmi;
  int? targetCalories;
  String? bmiCategory;
  Map<String, List<MealInputModel>> mealInputsByType = {};
  bool isLoadingMealInputs = true;

  int _calculateTotalCalories() {
    int total = 0;
    for (var list in mealInputsByType.values) {
      for (var item in list) {
        total += item.calories.toInt();
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchMealInputs();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      // Ambil dari API jika token tersedia
      if (token != null) {
        final response = await ApiService.getUserProfile(token);
        final user = UserModel.fromJson(response);

        // Simpan ulang ke SharedPreferences
        await prefs.setString('user', jsonEncode(user.toJson()));

        setState(() {
          _applyUserData(user);
        });
        return;
      }
    } catch (e) {
      debugPrint('Gagal fetch dari /user/profile, fallback ke cache');
    }

    // Fallback ke data yang ada di SharedPreferences
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      setState(() {
        _applyUserData(user);
      });
    }
  }

  void _applyUserData(UserModel user) {
    bmi = user.bmi;
    if (bmi != null) {
      if (bmi! < 18.5) {
        bmiCategory = 'Berat Badan Kurang';
        targetCalories = 2100;
      } else if (bmi! <= 22.9) {
        bmiCategory = 'Normal';
        targetCalories = 2500;
      } else {
        bmiCategory = 'Berat Badan Lebih';
        targetCalories = 1500;
      }
    }
  }

  Future<void> _fetchMealInputs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) return;

    try {
      final data = await ApiService.fetchMealInputs(token);

      Map<String, List<MealInputModel>> updatedMap = {};
      final today = DateTime.now();

      for (var input in data) {
        final inputDate = DateTime.parse(input.time).toLocal();
        final isSameDay =
            inputDate.year == today.year &&
            inputDate.month == today.month &&
            inputDate.day == today.day;

        if (!isSameDay) continue; // Lewati data bukan hari ini

        final type = input.mealType;
        if (!updatedMap.containsKey(type)) {
          updatedMap[type] = [];
        }
        updatedMap[type]!.add(input);
      }

      setState(() {
        mealInputsByType = updatedMap;
        isLoadingMealInputs = false;
      });
    } catch (e) {
      debugPrint('Error fetching meal inputs: $e');
      setState(() => isLoadingMealInputs = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Makanan & Kalori"),
        automaticallyImplyLeading: false,
      ),
      body:
          bmi == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchMealInputs,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _sectionCard(
                      title: "Tujuan Harian Anda",
                      subtitle:
                          "Berdasarkan BMI Anda ${bmi!.toStringAsFixed(1)} ($bmiCategory)",
                      value:
                          "${_calculateTotalCalories()} / ${targetCalories ?? 2000} kcal",
                      color: Colors.lightBlue[50],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Distribusi Paket Makanan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          _progressSegment(color: Colors.amber, value: 0.2),
                          _progressSegment(color: Colors.green, value: 0.1),
                          _progressSegment(color: Colors.orange, value: 0.3),
                          _progressSegment(color: Colors.purple, value: 0.1),
                          _progressSegment(color: Colors.blue, value: 0.25),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: const [
                        _ColorLabel(color: Colors.amber, label: "Sarapan"),
                        _ColorLabel(color: Colors.green, label: "Cemilan Pagi"),
                        _ColorLabel(color: Colors.orange, label: "Makan Siang"),
                        _ColorLabel(
                          color: Colors.purple,
                          label: "Cemilan Sore",
                        ),
                        _ColorLabel(color: Colors.blue, label: "Makan Malam"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Catat makanan anda",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _foodItem("Sarapan"),
                    _foodItem("Cemilan Pagi"),
                    _foodItem("Makan Siang"),
                    _foodItem("Cemilan Sore"),
                    _foodItem("Makan Malam"),
                  ],
                ),
              ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required String value,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _foodItem(String title) {
    final mapping = {
      'Sarapan': 'breakfast',
      'Cemilan Pagi': 'morning_snack',
      'Makan Siang': 'lunch',
      'Cemilan Sore': 'afternoon_snack',
      'Makan Malam': 'dinner',
    };

    final mealKey = mapping[title]!;
    final List<MealInputModel> items = mealInputsByType[mealKey] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty) const Text('Belum ada data'),
          ...items.map(
            (item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.manualName),
              subtitle: Text('${item.calories.toStringAsFixed(0)} kkal'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(item),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FoodListPage(mealType: title),
                  ),
                ).then((_) {
                  _fetchMealInputs().then((_) {
                    _updateKalori(); // ✅ Kalori diupdate setelah data makanan dimuat ulang
                  });
                  _loadUserData();
                });
              },
              child: Text(
                "Tambah",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateKalori() async {
    context.read<KaloriViewModel>().setKalori(
          _calculateTotalCalories(),
          targetCalories ?? 2500,
        );
  }

  void _showDeleteConfirmationDialog(MealInputModel meal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus ${meal.manualName}?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Hapus'),
            onPressed: () {
              Navigator.pop(ctx);
              _deleteMealInput(meal);
            },
          ),
        ],
      ),
    );
  }

  void _deleteMealInput(MealInputModel meal) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan')),
      );
      return;
    }

    final success = await ApiService.deleteMealInput(token, meal.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${meal.manualName} berhasil dihapus'),
        ),
      );
      await _fetchMealInputs();
      _updateKalori();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus makanan')),
      );
    }
  }
}

Widget _progressSegment({required Color color, required double value}) {
  return Flexible(
    flex: (value * 1000).toInt(), // total 1000
    child: Container(color: color),
  );
}

class _ColorLabel extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorLabel({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
