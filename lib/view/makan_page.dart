import 'package:flutter/material.dart';

class MakanPage extends StatelessWidget {
  const MakanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Makanan & Kalori"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            title: "Tujuan Harian Anda",
            subtitle: "Berdasarkan BMI Anda 24,5 (Normal)",
            value: "2,000 kcal",
            color: Colors.lightBlue[50],
          ),
          const SizedBox(height: 20),
          const Text(
            "Distribusi Paket Makanan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.7,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          const SizedBox(height: 24),
          const Text(
            "Catat makanan anda",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _foodItem("Sarapan", "Oatmeal, Pisang (350 kcal)", true),
          _foodItem("Makan Siang", "Ayam Panggang, Nasi (550 kcal)", true),
          _foodItem("Makan Malam", "Belum ada data", false, isEmpty: true),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required String subtitle, required String value, Color? color}) {
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
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _foodItem(String title, String desc, bool completed, {bool isEmpty = false}) {
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
        trailing: completed
            ? const Icon(Icons.check_circle, color: Colors.green)
            : isEmpty
                ? Text("Tambah", style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold))
                : null,
      ),
    );
  }
}
