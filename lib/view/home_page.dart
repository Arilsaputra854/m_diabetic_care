import 'package:flutter/material.dart';
import 'package:m_diabetic_care/view/edukasi_page.dart';
import 'package:m_diabetic_care/view/imt_page.dart';
import 'package:m_diabetic_care/view/makan_page.dart';
import 'package:m_diabetic_care/view/obat_page.dart';
import 'package:m_diabetic_care/view/olahraga_page.dart';
import 'package:m_diabetic_care/view/tambah_obat_page.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> obatList = [
    {
      'nama': 'Gliclazide',
      'waktu': '08:00 WIB - Sebelum sarapan',
      'status': 'Selesai',
      'warna': Colors.green[100],
      'icon': Icons.check_circle,
      'labelColor': Colors.grey,
      'textColor': Colors.grey,
    },
    {
      'nama': 'Metformin',
      'waktu': '13:00 WIB - Setelah Makan Siang',
      'status': 'Minum',
      'warna': Colors.orange[50],
      'icon': Icons.access_time,
      'labelColor': Colors.orange[200],
      'textColor': Colors.orange[800],
    },
    {
      'nama': 'Insulin',
      'waktu': '21:00 WIB - Sebelum tidur',
      'status': '',
      'warna': Colors.grey[100],
      'icon': Icons.schedule,
      'labelColor': null,
      'textColor': Colors.grey,
    },
  ];

  void _goToPengobatan() {
    setState(() {
      _selectedIndex = 5;
    });
  }

  void _goToTambahObat() {
    setState(() {
      _selectedIndex = 6;
    });
  }

  void _goToHomeContent() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (_selectedIndex) {
      case 0:
        bodyContent = HomeContent(onTambahObat: _goToPengobatan);
        break;
      case 1:
        bodyContent = const EdukasiPage();
        break;
      case 2:
        bodyContent = const IMTPage();
        break;
      case 3:
        bodyContent = const MakanPage(); // bisa diganti
        break;
      case 4:
        bodyContent = const OlahragaPage(); // bisa diganti
        break;
      case 5:
        bodyContent = PengobatanPage(
          obatList: obatList,
          onTambahObat: _goToTambahObat,
          onBack: _goToHomeContent,
          onDelete: (index) {
            setState(() {
              obatList.removeAt(index);
            });
          },
        );

        break;
      case 6:
        bodyContent = TambahObatPage(
          onBack: () => setState(() => _selectedIndex = 1),
          onSimpan: (nama, waktu) {
            setState(() {
              obatList.add({
                'nama': nama,
                'waktu': waktu,
                'status': '',
                'warna': Colors.grey[100],
                'icon': Icons.schedule,
                'labelColor': null,
                'textColor': Colors.grey,
              });
              _selectedIndex = 1; // kembali ke pengobatan
            });
          },
        );

        break;
      default:
        bodyContent = HomeContent(onTambahObat: _goToPengobatan);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: bodyContent),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex, // reset ke Home
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'IMT',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Untukmu'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onTambahObat;

  const HomeContent({super.key, required this.onTambahObat});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildCardGulaDarah(),
          const SizedBox(height: 12),
          _buildCardKalori(),
          const SizedBox(height: 12),
          _buildCardObat(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/user.png'),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Kezia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tetap semangat menjaga kesehatanmu!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gula Darah',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '-',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Cek terakhir: Belum ada data',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D5C63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Tambah Data'),
          ),
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
          const Text(
            'Asupan Kalori Harian',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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

  Widget _buildCardObat() {
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
          const Text(
            'Pengobatan selanjutnya',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                  child: Text(
                    'Metformin\nDosis selanjutnya : 13.00 WIB (sesudah makan siang)',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onTambahObat, // ← diperbaiki
              icon: const Icon(Icons.add),
              label: const Text('Tambah Obat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBA54C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
