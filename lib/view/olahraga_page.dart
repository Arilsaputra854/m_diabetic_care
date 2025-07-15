import 'package:flutter/material.dart';

class OlahragaPage extends StatelessWidget {
  const OlahragaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            title: "Aktivitas Mingguan",
            subtitle: "Tujuan Anda adalah 150 menit per minggu.",
            progressValue: 90,
            progressMax: 150,
          ),
          const SizedBox(height: 24),
          const Text("Aktivitas Hari Ini", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _activityItem("30 menit jalan pagi hari"),
          _activityItem("15 menit peregangan sore hari"),
          _activityItem("Tambah", isAdd: true),
          const SizedBox(height: 20),
          _tipsBox(),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required String subtitle, required int progressValue, required int progressMax}) {
    final double progress = progressValue / progressMax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            "$progressValue / $progressMax menit",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _activityItem(String text, {bool isAdd = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (_) {}),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
          if (!isAdd && text.toLowerCase().contains("pagi")) const Icon(Icons.emoji_objects_outlined, color: Colors.amber),
        ],
      ),
    );
  }

  Widget _tipsBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Selalu periksa kadar gula darah anda sebelum berolahraga. Jika kadarnya di bawah 100 mg/dL, makanlah cemilan kecil.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
