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


class HomePageV2 extends StatelessWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Edukasi'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_weight), label: 'IMT'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Untukmu'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildCardGulaDarah(),
              const SizedBox(height: 12),
              _buildCardKalori(),
              const SizedBox(height: 12),
              _buildCardObat(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(radius: 24, backgroundImage: AssetImage('assets/user.png')),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, Kezia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Tetap semangat menjaga kesehatanmu!', style: TextStyle(fontSize: 12, color: Colors.grey))
          ],
        ),
      ],
    );
  }

  Widget _buildCardGulaDarah() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Gula Darah', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Cek terakhir: Belum ada data', style: TextStyle(fontSize: 12, color: Colors.grey))
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D5C63),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tambah Data'),
          )
        ],
      ),
    );
  }

  Widget _buildCardKalori() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Asupan Kalori Harian', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.45,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF1D5C63),
          ),
          const SizedBox(height: 4),
          const Text('900/2000 Kcal', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCardObat(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pengobatan selanjutnya', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.medication, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Metformin\nDosis selanjutnya : 13.00 WIB (sesudah makan siang)', style: TextStyle(fontSize: 12)),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Tambah Obat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBA54C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
