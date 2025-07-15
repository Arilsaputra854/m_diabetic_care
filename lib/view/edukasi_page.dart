import 'package:flutter/material.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pusat Eduksi"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Memahami Diabetes"),
          _cardItem(
            icon: Icons.lightbulb_outline,
            title: "Apa itu Diabetes Tipe 2 ?",
            subtitle:
                "Ini adalah kondisi di mana tubuh anda tidak menggunakan insulin dengan benar.",
            buttonLabel: "Baca",
            onTap: () {},
          ),
          _sectionTitle("Fakta & Mitos"),
          _cardItem(
            icon: Icons.question_mark,
            title: "Mitos",
            subtitle:
                "Ada banyak mitos dan fakta yang beredar seputar diabetes...",
            buttonLabel: "Mulai Kuis",
            onTap: () {
              Navigator.pushNamed(context, '/fakta-mitos');
            },
          ),
          _sectionTitle("Video"),
          _cardItem(
            icon: Icons.play_circle,
            title: "Video",
            subtitle: "Video seputar diabetes yang menjelaskandiabetes...",
            buttonLabel: "Tonton",
            onTap: () {},
          ),
          _sectionTitle("Poster"),
          _cardItem(
            icon: Icons.image,
            title: "Poster",
            subtitle:
                "Poster edukasi tentang mitos dan fakta seputar diabetes...",
            buttonLabel: "Lihat",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _cardItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.lightBlue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.teal[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[800],
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
