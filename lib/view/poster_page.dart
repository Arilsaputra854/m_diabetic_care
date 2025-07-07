import 'package:flutter/material.dart';

class PosterPage extends StatelessWidget {
  const PosterPage({super.key});

  final List<Map<String, String>> posters = const [
    {
      'title': 'Apa Itu Diabetes',
      'image': 'assets/poster_dm1.png',
    },
    {
      'title': 'Pencegahan Diabetes',
      'image': 'assets/poster_dm2.png',
    },
    {
      'title': 'Pengobatan Diabetes',
      'image': 'assets/poster_dm3.png',
    },
  ];

  void _showFullImage(BuildContext context, String imagePath, String title) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poster Edukasi DM')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posters.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = posters[index];
          return GestureDetector(
            onTap: () => _showFullImage(context, item['image']!, item['title']!),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(item['title']!, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}
