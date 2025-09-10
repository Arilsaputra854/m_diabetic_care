import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:m_diabetic_care/model/obat.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:m_diabetic_care/viewmodel/calori_viewmodel.dart'
    show KaloriViewModel;
import 'package:m_diabetic_care/viewmodel/obat_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_diabetic_care/view/edukasi_page.dart';
import 'package:m_diabetic_care/view/imt_page.dart';
import 'package:m_diabetic_care/view/makan_page.dart';
import 'package:m_diabetic_care/view/obat_page.dart';
import 'package:m_diabetic_care/view/olahraga_page.dart';
import 'package:m_diabetic_care/view/tambah_obat_page.dart';

import 'package:m_diabetic_care/viewmodel/calori_viewmodel.dart';
import 'package:m_diabetic_care/viewmodel/user_viewmodel.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // load user dari prefs lewat UserViewModel
    final userVM = context.read<UserViewModel>();
    await userVM.loadUserFromPrefs();

    // load kalori dari prefs
    final kaloriVM = context.read<KaloriViewModel>();
    await kaloriVM.loadFromPrefs();

    // load jadwal obat via ObatViewModel
    final obatVM = context.read<ObatViewModel>();
    await obatVM.fetchObat();
  }

  void _goToPengobatan() => setState(() => _selectedIndex = 5);
  void _goToTambahObat() => setState(() => _selectedIndex = 6);
  void _goToHomeContent() => setState(() => _selectedIndex = 0);

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final obatVM = context.watch<ObatViewModel>();

    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = HomeContent(
          user: userVM.user,
          onTambahObat: _goToPengobatan,
          daftarObat: obatVM.obatList, // dari VM
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
        );
        break;
      case 6:
        bodyContent = TambahObatPage(
          onBack: _goToPengobatan,
        );
        break;
      default:
        bodyContent = HomeContent(
          user: userVM.user,
          onTambahObat: _goToPengobatan,
          daftarObat: obatVM.obatList,
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
    final userVM = context.watch<UserViewModel>(); // ✅ ambil dari provider
    final kaloriVM = context.watch<KaloriViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildCardGulaDarah(userVM, context),
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
           Text(
            'Asupan Kalori Harian',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value:
                targetCalories == 0
                    ? 0
                    : (totalCalories / targetCalories).clamp(0, 1),
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF1D5C63),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalCalories / $targetCalories Kcal',
            style:  TextStyle(fontSize: 12.sp),
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
              'Hai, ${user?.fullname ?? 'User'}',
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

  Widget _buildCardGulaDarah(UserViewModel userVM, BuildContext context) {
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
                  style:  TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                 Text(
                  'Cek terakhir: ${user?.glucoseLevelUpdatedAt != null ?  DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(user!.glucoseLevelUpdatedAt!)) : "-"}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showGlucoseUpdateDialog(context, userVM, user!);
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D5C63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:  Text('Tambah Data', style: TextStyle(fontSize: 16.sp),),
          ),
        ],
      ),
    );
  }

  void _showGlucoseUpdateDialog(
    BuildContext context,
    UserViewModel userVM,
    UserModel user,
  ) {
    final TextEditingController glucoseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Perbarui Gula Darah'),
          content: TextField(
            controller: glucoseController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Gula Darah (mg/dL)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final input = glucoseController.text;
                final glucose = double.tryParse(input);

                if (glucose == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Masukkan angka yang valid')),
                  );
                  return;
                }

                final updatedUser = {
                  "glucose_level": glucose,
                  "glucose_level_updated_at": DateTime.now().toIso8601String(),
                };

                final success = await ApiService.updateUserProfile(updatedUser);

                if (success) {
                  Navigator.pop(context); // Close dialog
                  await userVM.fetchUserProfile(); // Refresh user data
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal memperbarui data')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Obat? getNextMedication(List<Obat> daftarObat) {
    final now = TimeOfDay.now();

    // Filter obat dengan jadwal setelah sekarang
    List<Obat> upcoming =
        daftarObat.where((obat) {
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
           Text(
            'Pengobatan Selanjutnya',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
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
                      style:  TextStyle(fontSize: 14.sp),
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
              label:  Text('Tambah Obat',style: TextStyle(fontSize: 16.sp),),
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
              color: Color(0xff3399E1), 
              icon: Icons.school,
              label: 'Edukasi',
              onTap: () => Navigator.pushNamed(context, '/edukasi'),
            ),
            _MenuTile(
              color: Colors.orangeAccent, 
              icon: Icons.fastfood_sharp,
              label: 'Makanan',
              onTap: () => Navigator.pushNamed(context, '/food'),
            ),
            _MenuTile(
              color: const Color(0xff33A1A1), 
              icon: Icons.monitor_weight,
              label: 'Index Masa Tubuh',
              onTap: () => Navigator.pushNamed(context, '/imt'),
            ),
            _MenuTile(
              color: Color(0xff9B59B6), 
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
            onPressed: () => Navigator.pushNamed(context, '/fakta-mitos'),
            icon: const Icon(Icons.videogame_asset),
            label:  Text('Game Mitos & Fakta',style: TextStyle(fontSize: 16.sp),),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3B4350),
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
  final Color color; // Tambahkan warna background

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color, // tambahkan di constructor
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color, // pakai warna yang dikirim
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
              Icon(icon, size: 28, color: Colors.white), // ikon putih biar kontras
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.white, // teks putih
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

