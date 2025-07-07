import 'package:flutter/material.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final TextEditingController karboController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController lemakController = TextEditingController();

  double totalKalori = 0;

  void hitungKalori() {
    final double karbo = double.tryParse(karboController.text) ?? 0;
    final double protein = double.tryParse(proteinController.text) ?? 0;
    final double lemak = double.tryParse(lemakController.text) ?? 0;

    setState(() {
      totalKalori = (karbo * 4) + (protein * 4) + (lemak * 9);
    });
  }

  @override
  void dispose() {
    karboController.dispose();
    proteinController.dispose();
    lemakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Makanan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: karboController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Karbohidrat (gr)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Protein (gr)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lemakController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Lemak (gr)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: hitungKalori,
              child: const Text('Hitung Kalori'),
            ),
            const SizedBox(height: 24),
            Text(
              'Total Kalori: ${totalKalori.toStringAsFixed(2)} kkal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
