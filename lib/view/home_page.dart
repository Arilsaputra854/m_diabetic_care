import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<_HomeMenuItem> menuItems = const [
    _HomeMenuItem('Pengingat Obat', Icons.alarm),
    _HomeMenuItem('Kalori Tracker', Icons.local_fire_department),
    _HomeMenuItem('Kalkulator Makanan', Icons.restaurant_menu),
    _HomeMenuItem('Pengingat Olahraga', Icons.directions_run),
    _HomeMenuItem('Video Edukasi', Icons.play_circle_fill),
    _HomeMenuItem('Poster DM', Icons.image),
    _HomeMenuItem('Mitos/Fakta', Icons.question_answer),
    _HomeMenuItem('Berita DM', Icons.article),
    _HomeMenuItem('Panduan Terapi', Icons.menu_book),
    _HomeMenuItem('Manajemen Luka', Icons.healing),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('M-DIABETIC CARE'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                if (item.title == 'Pengingat Obat') {
                  Navigator.pushNamed(context, '/reminder');
                }
                if (item.title == 'Kalori Tracker') {
                  Navigator.pushNamed(context, '/kalori');
                }
                if (item.title == 'Kalkulator Makanan') {
                  Navigator.pushNamed(context, '/kalkulator');
                }
                if (item.title == 'Pengingat Olahraga') {
                  Navigator.pushNamed(context, '/olahraga');
                }
                if (item.title == 'Video Edukasi') {
                  Navigator.pushNamed(context, '/video-edukasi');
                }
                if (item.title == 'Poster DM') {
                  Navigator.pushNamed(context, '/poster');
                }
                if (item.title == 'Mitos/Fakta') {
                  Navigator.pushNamed(context, '/mitos');
                }
                if (item.title == 'Berita DM') {
                  Navigator.pushNamed(context, '/berita');
                }
                if (item.title == 'Manajemen Luka') {
                  Navigator.pushNamed(context, '/manajemen-luka');
                }
                if (item.title == 'Panduan Terapi') {
                  Navigator.pushNamed(context, '/panduan');
                }
              },

              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 48, color: Colors.teal),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeMenuItem {
  final String title;
  final IconData icon;
  const _HomeMenuItem(this.title, this.icon);
}
