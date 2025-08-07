import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:m_diabetic_care/view/update_bmi_page.dart';
import 'package:m_diabetic_care/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    userProvider.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),

            const SizedBox(height: 12),
            Text(
              user!.fullname,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(user!.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildInfoItem('Umur', '${user!.age} Tahun'),
            _buildInfoItem('IMT', '${user!.bmi?.toStringAsFixed(1)}'),
            _buildInfoItem(
              'Riwayat Diabetes',
              user!.familyHistory == 'yes' ? 'Ada' : 'Tidak Ada',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UpdateBmiPage(),
                        ),
                      );
                      await userVM.fetchUserProfile();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6DC5B2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Perbarui BMI'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showGlucoseUpdateDialog(context, userVM, user!);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6DC5B2),

                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Perbarui Gula Darah'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan Akun'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('access_token');
                  await prefs.remove('user');

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1D5C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                  "fullname": user.fullname,
                  "phone_number": user.phoneNumber ?? "",
                  "gender": user.gender ?? "male",
                  "family_history": user.familyHistory ?? "",
                  "height": user.height ?? 0,
                  "weight": user.weight ?? 0,
                  "birth_date": user.birthDate ?? "1990-01-01",
                  "diabetes_type": user.diabetesType ?? "",
                  "glucose_level": glucose,
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

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
