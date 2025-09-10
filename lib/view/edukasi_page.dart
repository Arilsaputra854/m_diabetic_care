import 'package:flutter/material.dart';
import 'package:m_diabetic_care/view/edukasi_berita_page.dart';
import 'package:m_diabetic_care/view/edukasi_poster_page.dart';
import 'package:m_diabetic_care/view/edukasi_video_page.dart';

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
          _sectionTitle("Berita"),
          _cardItem(
            icon: Icons.newspaper,
            title: "Berita & Artikel Terkini",
            subtitle:
                "Dapatkan informasi terbaru seputar diabetes dari sumber tepercaya.",
            buttonLabel: "Baca",
            color: Colors.lightBlue.shade100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EdukasiBeritaPage()),
              );
            },
          ),

          _sectionTitle("Fakta & Mitos"),
          _cardItem(
            icon: Icons.question_mark,
            title: "Mitos",
            subtitle:
                "Ada banyak mitos dan fakta yang beredar seputar diabetes...",
            buttonLabel: "Mulai Kuis",
            color: Colors.pink.shade100,
            onTap: () {
              Navigator.pushNamed(context, '/fakta-mitos');
            },
          ),

          _sectionTitle("Video"),
          _cardItem(
            icon: Icons.play_circle,
            title: "Video",
            subtitle: "Video seputar diabetes yang menjelaskan...",
            buttonLabel: "Tonton",
            color: Colors.greenAccent.shade100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EdukasiVideoPage()),
              );
            },
          ),

          _sectionTitle("Poster"),
          _cardItem(
            icon: Icons.image,
            title: "Poster",
            subtitle:
                "Poster edukasi tentang mitos dan fakta seputar diabetes...",
            buttonLabel: "Lihat",
            color: Colors.amber.shade100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EdukasiPosterPage()),
              );
            },
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.teal[800]),
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
