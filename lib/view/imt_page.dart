import 'package:flutter/material.dart';

class IMTPage extends StatefulWidget {
  const IMTPage({super.key});

  @override
  State<IMTPage> createState() => _IMTPageState();
}

class _IMTPageState extends State<IMTPage> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double? bmi;
  String? resultLabel;
  String? recommendation;
  String? calorieInfo;
  String? mealSchedule;
  Color? resultColor;

  void _calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) return;

    final heightInMeters = height / 100;
    final result = weight / (heightInMeters * heightInMeters);
    String label;
    String advice;
    double dailyCalories = 0;
    String caloriesNote;
    String scheduleNote;
    Color color;

    if (result < 18.5) {
      label = "Berat Badan Kurang";
      advice = "Fokus pada makanan padat nutrisi. Tambahkan lemak sehat dan protein.";
      dailyCalories = 2100;
      color = Colors.lightBlue;
    } else if (result <= 22.9) {
      label = "Berat Badan Normal";
      advice = "Pertahankan pola makan seimbang dengan banyak sayur dan buah.";
      dailyCalories = 2500;
      color = Colors.green;
    } else {
      label = "Kelebihan Berat Badan";
      advice = "Perhatikan pola makan dan olahraga rutin. Konsultasi dengan ahli gizi.";
      dailyCalories = 1500;
      color = Colors.red;
    }

    caloriesNote = 'Kebutuhan kalori harianmu: ${dailyCalories.toInt()} kkal';
    scheduleNote = '''
Distribusi Jadwal Makan:
- Makan Pagi (20%): ${dailyCalories * 0.2} kkal (06.00 - 09.00)
- Camilan Pagi (10%): ${dailyCalories * 0.1} kkal (10.00 - 11.00)
- Makan Siang (30%): ${dailyCalories * 0.3} kkal (12.00 - 15.00)
- Camilan Sore (10%): ${dailyCalories * 0.1} kkal (16.00 - 17.00)
- Makan Malam (25%): ${dailyCalories * 0.25} kkal (18.00 - 20.00)
''';

    setState(() {
      bmi = result;
      resultLabel = label;
      recommendation = advice;
      resultColor = color;
      calorieInfo = caloriesNote;
      mealSchedule = scheduleNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Indeks Massa Tubuh (IMT)',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 24,left: 24,top: 24),
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Tinggi dan Berat Badan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildField(label: 'Tinggi', controller: heightController, suffix: 'cm'),
            const SizedBox(height: 16),
            _buildField(label: 'Berat', controller: weightController, suffix: 'kg'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1D5C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _calculateBMI,
                child: const Text('Hitung IMT'),
              ),
            ),
            const SizedBox(height: 24),
            if (bmi != null) ...[
              const Text(
                'Hasilmu:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: resultColor!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        bmi!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: resultColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        resultLabel!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: resultColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Rekomendasi:\n$recommendation',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      calorieInfo!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mealSchedule!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),)
      ),
      
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFEBF0FF)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFB4C2F8), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
