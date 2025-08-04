import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/view/food_list_page.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final user = UserModel.fromJson(jsonDecode(userJson));

      setState(() {
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
      });
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
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _sectionCard(
                    title: "Tujuan Harian Anda",
                    subtitle:
                        "Berdasarkan BMI Anda ${bmi!.toStringAsFixed(1)} ($bmiCategory)",
                    value: "${targetCalories ?? 2000} kcal",
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
                      _ColorLabel(color: Colors.purple, label: "Cemilan Sore"),
                      _ColorLabel(color: Colors.blue, label: "Makan Malam"),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Catat makanan anda",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _foodItem("Sarapan", "Belum ada data", false, isEmpty: true),
                  _foodItem(
                    "Cemilan Pagi",
                    "Belum ada data",
                    false,
                    isEmpty: true,
                  ),
                  _foodItem(
                    "Makan Siang",
                    "Belum ada data",
                    false,
                    isEmpty: true,
                  ),
                  _foodItem(
                    "Cemilan Sore",
                    "Belum ada data",
                    false,
                    isEmpty: true,
                  ),
                  _foodItem(
                    "Makan Malam",
                    "Belum ada data",
                    false,
                    isEmpty: true,
                  ),
                ],
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

  Widget _foodItem(
    String title,
    String desc,
    bool completed, {
    bool isEmpty = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing:
            completed
                ? const Icon(Icons.check_circle, color: Colors.green)
                : isEmpty
                ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodListPage(mealType: title),
                      ),
                    );
                  },
                  child: Text(
                    "Tambah",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
  
}

Widget _progressSegment({required Color color, required double value}) {
  return Flexible(
    flex: (value * 1000).toInt(), // total 1000
    child: Container(
      color: color,
    ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

