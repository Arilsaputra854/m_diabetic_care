import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PengingatOlahragaPage extends StatefulWidget {
  const PengingatOlahragaPage({super.key});

  @override
  State<PengingatOlahragaPage> createState() => _PengingatOlahragaPageState();
}

class _PengingatOlahragaPageState extends State<PengingatOlahragaPage> {
  final List<TimeOfDay> _jadwalLatihan = [];

  Future<void> _tambahPengingat() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _jadwalLatihan.add(picked);
      });
    }
  }

  void _hapusPengingat(int index) {
    setState(() {
      _jadwalLatihan.removeAt(index);
    });
  }

  void _bukaYoutubeVideo() async {
    const url = 'https://www.youtube.com/results?search_query=senam+diabetes';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka video')),
      );
    }
  }

  String _formatWaktu(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengingat Olahraga')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _tambahPengingat,
              icon: const Icon(Icons.fitness_center),
              label: const Text('Tambah Waktu Latihan'),
            ),
            const SizedBox(height: 16),
            _jadwalLatihan.isEmpty
                ? const Text('Belum ada pengingat latihan.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _jadwalLatihan.length,
                      itemBuilder: (context, index) {
                        final waktu = _jadwalLatihan[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.timer),
                            title: Text('Latihan jam ${_formatWaktu(waktu)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _hapusPengingat(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _bukaYoutubeVideo,
              icon: const Icon(Icons.play_circle_fill),
              label: const Text('Lihat Video Senam Ringan'),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
💡 *Tips Latihan Fisik untuk Pasien Diabetes* (Perkeni, 2021):
- Latihan 3–5 hari/minggu, total 150 menit/minggu
- Jenis: aerobik sedang seperti jalan cepat, bersepeda santai, jogging
- Glukosa darah < 100 mg/dL: konsumsi karbohidrat dulu
- Glukosa > 250 mg/dL: tunda latihan dulu
- Tidak perlu pemeriksaan medis jika intensitas ringan
- Pastikan jeda antar latihan tidak lebih dari 2 hari

🧠 Tujuan: menurunkan berat badan, meningkatkan sensitivitas insulin, menjaga kebugaran
                  ''',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
