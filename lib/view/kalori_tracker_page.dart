import 'package:flutter/material.dart';
import 'dart:math';

class KaloriTrackerPage extends StatefulWidget {
  const KaloriTrackerPage({super.key});

  @override
  State<KaloriTrackerPage> createState() => _KaloriTrackerPageState();
}

class _KaloriTrackerPageState extends State<KaloriTrackerPage> {
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController beratController = TextEditingController();
  final TextEditingController usiaController = TextEditingController();

  double? imt;
  double? kebutuhanKalori;

  void _hitung() {
    final tinggi = double.tryParse(tinggiController.text);
    final berat = double.tryParse(beratController.text);
    final usia = int.tryParse(usiaController.text);

    if (tinggi != null && berat != null && usia != null) {
      final tinggiMeter = tinggi / 100;
      final hitungIMT = berat / pow(tinggiMeter, 2);
      final hitungKalori = 30 * berat; // asumsi rata-rata DM dewasa

      setState(() {
        imt = double.parse(hitungIMT.toStringAsFixed(1));
        kebutuhanKalori = double.parse(hitungKalori.toStringAsFixed(0));
      });
    }
  }

  Widget _buildKaloriDetail() {
    if (kebutuhanKalori == null) return const SizedBox();

    double pagi = kebutuhanKalori! * 0.20;
    double siang = kebutuhanKalori! * 0.30;
    double malam = kebutuhanKalori! * 0.25;
    double snack = kebutuhanKalori! * 0.25; // termasuk 2-3 camilan

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("IMT: $imt", style: const TextStyle(fontSize: 16)),
        Text("Total Kalori Harian: $kebutuhanKalori kkal",
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'Distribusi Kalori Harian:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("🍳 Makan Pagi (20%): ${pagi.toStringAsFixed(0)} kkal"),
        Text("🍛 Makan Siang (30%): ${siang.toStringAsFixed(0)} kkal"),
        Text("🍲 Makan Malam (25%): ${malam.toStringAsFixed(0)} kkal"),
        Text("🍎 Snack 2-3x (10-15%): ${snack.toStringAsFixed(0)} kkal"),
        const SizedBox(height: 16),
        const Text(
          'Contoh Jadwal Makan:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text("Makan Pagi: 06.00 – 09.00"),
        const Text("Camilan Pagi: 10.00 – 11.00"),
        const Text("Makan Siang: 12.00 – 15.00"),
        const Text("Camilan Sore: 16.00 – 17.00"),
        const Text("Makan Malam: 18.00 – 20.00"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalori Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: tinggiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tinggi Badan (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: beratController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Berat Badan (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usiaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Usia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hitung,
              child: const Text('Hitung Kalori Harian'),
            ),
            const SizedBox(height: 24),
            _buildKaloriDetail(),
          ],
        ),
      ),
    );
  }
}
