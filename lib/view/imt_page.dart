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
  Color? resultColor;

  void _calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) return;

    final heightInMeters = height / 100;
    final result = weight / (heightInMeters * heightInMeters);
    String label;
    String advice;
    Color color;

    if (result < 18.5) {
      label = "Berat Badan Kurang";
      advice =
          "Fokus pada makanan padat nutrisi. Tambahkan lemak sehat dan protein. Perbanyak zat besi dari lentil dan ayam.";
      color = Colors.lightBlue;
    } else if (result < 25) {
      label = "Berat Badan Sehat";
      advice =
          "Kamu hebat! Pertahankan pola makan seimbang dengan banyak buah, sayur, dan makanan kaya zat besi.";
      color = Colors.green;
    } else {
      label = "Berat Badan Obesitas";
      advice =
          "Sebaiknya bicara dengan dokter atau ahli gizi untuk membuat rencana mendukung kesehatanmu.";
      color = Colors.red;
    }

    setState(() {
      bmi = result;
      resultLabel = label;
      recommendation = advice;
      resultColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Tinggi dan Berat Badan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildField(
              label: 'Tinggi',
              controller: heightController,
              suffix: 'cm',
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'Berat',
              controller: weightController,
              suffix: 'kg',
            ),

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
                  children: [
                    Text(
                      bmi!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                    Text(
                      resultLabel!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Rekomendasi:\n$recommendation',
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Index IMT
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'IMT',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Untukmu',
          ),
        ],
        onTap: (index) {
          // Tambahkan navigasi ke halaman sesuai index jika diperlukan
        },
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
