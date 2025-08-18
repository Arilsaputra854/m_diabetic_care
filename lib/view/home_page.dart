import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/obat.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:m_diabetic_care/viewmodel/calori_viewmodel.dart'
    show KaloriViewModel;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  UserModel? currentUser;
  List<Obat> _jadwalObat = [];

  List<Map<String, dynamic>> obatList = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    loadJadwalObat();

    Future.microtask(() {
      final kaloriVM = context.read<KaloriViewModel>();
      kaloriVM.loadFromPrefs();
    });
  }

  Future<void> loadJadwalObat() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final reminders = await ApiService.getMedicationReminders(token);

    _jadwalObat = reminders;

    setState(() {});
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    setState(() {
      if (userJson != null) {
        currentUser = UserModel.fromJson(jsonDecode(userJson));
      }
    });
  }

  void _goToPengobatan() => setState(() => _selectedIndex = 5);
  void _goToTambahObat() => setState(() => _selectedIndex = 6);
  void _goToHomeContent() => setState(() => _selectedIndex = 0);

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = HomeContent(
          user: currentUser,
          onTambahObat: _goToPengobatan,
          daftarObat: _jadwalObat,
        );
        break;
      case 1:
        bodyContent = const EdukasiPage();
        break;
      case 2:
        bodyContent = const IMTPage();
        break;
      case 3:
        bodyContent = const MakanPage();
        break;
      case 4:
        bodyContent = const OlahragaPage();
        break;
      case 5:
        bodyContent = PengobatanPage(
          onTambahObat: _goToTambahObat,
          onBack: _goToHomeContent,
          onDelete: (index) => setState(() => obatList.removeAt(index)),
          onDataChanged: () async {
            await loadJadwalObat();
          },
        );
        break;
      case 6:
        bodyContent = TambahObatPage(
          onBack: _goToPengobatan,
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
              _selectedIndex = 5;
            });
          },
        );
        break;
      default:
        bodyContent = HomeContent(
          user: currentUser,
          onTambahObat: _goToPengobatan,
          daftarObat: _jadwalObat,
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: bodyContent),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_sharp),
            label: 'Makanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics),
            label: 'Latihan',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onTambahObat;
  final List<Obat> daftarObat;

  const HomeContent({
    super.key,
    required this.user,
    required this.onTambahObat,
    required this.daftarObat,
  });

  @override
  Widget build(BuildContext context) {
    final kaloriVM = context.watch<KaloriViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildCardGulaDarah(),
          const SizedBox(height: 12),
          _buildCardKalori(kaloriVM.totalCalories, kaloriVM.targetCalories),
          const SizedBox(height: 12),
          _buildCardObat(daftarObat),
          const SizedBox(height: 12),
          _buildQuickMenu(context), // grid menu + tombol lebar
        ],
      ),
    );
  }

  Widget _buildCardKalori(int totalCalories, int targetCalories) {
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
            value: targetCalories == 0
                ? 0
                : (totalCalories / targetCalories).clamp(0, 1),
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF1D5C63),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalCalories / $targetCalories Kcal',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user?.fullname ?? 'User'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Tetap semangat menjaga kesehatanmu!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardGulaDarah() {
    final gula =
        user?.glucoseLevel != null ? '${user!.glucoseLevel} mg/dL' : '-';
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
              children: [
                const Text(
                  'Gula Darah',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  gula,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cek terakhir: -',
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

  Obat? getNextMedication(List<Obat> daftarObat) {
    final now = TimeOfDay.now();

    // Filter obat dengan jadwal setelah sekarang
    List<Obat> upcoming = daftarObat.where((obat) {
      final parts = obat.jadwal.split(":");
      if (parts.length != 2) return false;

      final jam = int.tryParse(parts[0]);
      final menit = int.tryParse(parts[1]);
      if (jam == null || menit == null) return false;

      final time = TimeOfDay(hour: jam, minute: menit);

      return time.hour > now.hour ||
          (time.hour == now.hour && time.minute > now.minute);
    }).toList();

    // Urutkan berdasarkan waktu terdekat
    upcoming.sort((a, b) {
      final aTime = TimeOfDay(
        hour: int.parse(a.jadwal.split(":")[0]),
        minute: int.parse(a.jadwal.split(":")[1]),
      );
      final bTime = TimeOfDay(
        hour: int.parse(b.jadwal.split(":")[0]),
        minute: int.parse(b.jadwal.split(":")[1]),
      );

      final aMinutes = aTime.hour * 60 + aTime.minute;
      final bMinutes = bTime.hour * 60 + bTime.minute;

      return aMinutes.compareTo(bMinutes);
    });

    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  Widget _buildCardObat(List<Obat> daftarObat) {
    final obatSelanjutnya = getNextMedication(daftarObat);

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
            'Pengobatan Selanjutnya',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (obatSelanjutnya != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2E3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    obatSelanjutnya.tipe == 'oral'
                        ? Icons.medication
                        : Icons.vaccines,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${obatSelanjutnya.nama} (${obatSelanjutnya.dosage}x)\n'
                      'Jam: ${obatSelanjutnya.jadwal} WIB\n'
                      '${obatSelanjutnya.keterangan}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          else
            const Text("Tidak ada jadwal obat yang tersisa hari ini."),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onTambahObat,
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

  Widget _buildQuickMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.25,
          children: [
            _MenuTile(
              icon: Icons.school,
              label: 'Edukasi',
              onTap: () => Navigator.pushNamed(context, '/edukasi'),
            ),
            _MenuTile(
              icon: Icons.fastfood_sharp,
              label: 'Makanan',
              onTap: () => Navigator.pushNamed(context, '/food'),
            ),
            _MenuTile(
              icon: Icons.monitor_weight,
              label: 'Index Masa Tubuh',
              onTap: () => Navigator.pushNamed(context, '/imt'),
            ),
            _MenuTile(
              icon: Icons.article,
              label: 'Berita',
              onTap: () => Navigator.pushNamed(context, '/berita'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, '/fakta-mitos'),
            icon: const Icon(Icons.videogame_asset),
            label: const Text('Game Mitos & Fakta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D5C63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF1D5C63)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
