import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoEdukasiPage extends StatefulWidget {
  const VideoEdukasiPage({super.key});

  @override
  State<VideoEdukasiPage> createState() => _VideoEdukasiPageState();
}

class _VideoEdukasiPageState extends State<VideoEdukasiPage> {
  String selectedType = 'Tipe 1';

  final Map<String, String> videoLinks = {
    'Tipe 1': 'https://www.youtube.com/watch?v=Tipe1VideoContoh',
    'Tipe 2': 'https://www.youtube.com/watch?v=Tipe2VideoContoh',
    'Gestasional': 'https://www.youtube.com/watch?v=GestasionalVideoContoh',
  };

  void _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Edukasi Diabetes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Pilih Jenis Diabetes',
                border: OutlineInputBorder(),
              ),
              items: videoLinks.keys.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _launchVideo(videoLinks[selectedType]!),
              icon: const Icon(Icons.play_circle_fill),
              label: const Text('Tonton Video Edukasi'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Video ini berisi edukasi mengenai:\n• Apa itu Diabetes\n• Pencegahan & Gaya Hidup Sehat\n• Pentingnya minum obat teratur\n• Efek samping umum dari obat diabetes',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
