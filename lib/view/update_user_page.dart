import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/user.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:m_diabetic_care/widget/riwayat_dm_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String selectedGender = 'male';
  bool hasDMFamily = false;
  String selectedFamilyHistory = 'Diabetes Melitus';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token tidak ditemukan')));
      return;
    }

    try {
      final data = await ApiService.getUserProfile(token);
      final user = UserModel.fromJson(data);

      setState(() {
        nameController.text = user.fullname;
        emailController.text = user.email;
        birthDateController.text = user.birthDate;
        phoneController.text = user.phoneNumber;
        weightController.text = user.weight?.toString() ?? '';
        heightController.text = user.height?.toString() ?? '';
        selectedGender = user.gender;

        hasDMFamily = user.familyHistory.toLowerCase() != 'no';
        selectedFamilyHistory = hasDMFamily ? 'Diabetes Melitus' : 'Tidak Ada';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

void _updateUser() async {
  final data = {
    'fullname': nameController.text,
    'email': emailController.text,
    'birth_date': birthDateController.text,
    'gender': selectedGender,
    'phone_number': phoneController.text,
    'height': int.tryParse(heightController.text),
    'weight': int.tryParse(weightController.text),
    'family_history':
        selectedFamilyHistory == 'Tidak Ada' ? 'no' : selectedFamilyHistory,
  };

  final success = await ApiService.updateUserProfile(data);

  if (success) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil diperbarui')),
    );
    Navigator.pop(context);
  } else {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gagal memperbarui data')),
    );
  }
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Data Pengguna')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(
              nameController,
              'Nama Lengkap',
              Icons.person_outline,
            ),
            _buildGenderSelector(),
            _buildTextField(emailController, 'Email', Icons.email_outlined),
            _buildBirthDatePicker(),
            RiwayatDMKeluargaDropdown(
              initialValue: selectedFamilyHistory,
              onChanged: (hasDM) {
                setState(() {
                  selectedFamilyHistory =
                      hasDM ? 'Diabetes Melitus' : 'Tidak Ada';
                });
              },
            ),
            const SizedBox(height: 10),
            _buildTextField(
              phoneController,
              'Nomor Telepon',
              Icons.phone_outlined,
            ),
            _buildTextField(
              weightController,
              'Berat Badan',
              Icons.monitor_weight_outlined,
            ),
            _buildTextField(heightController, 'Tinggi Badan', Icons.height),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: const Color(0xff9098B1)),
          hintStyle: const TextStyle(color: Color(0xff9098B1)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEBF0FF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB4C2F8), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildBirthDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate:
                DateTime.tryParse(birthDateController.text) ??
                DateTime(2000, 1, 1),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              birthDateController.text =
                  pickedDate.toIso8601String().split('T')[0];
            });
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: birthDateController,
            decoration: InputDecoration(
              hintText: 'Tanggal Lahir',
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: Color(0xff9098B1),
              ),
              hintStyle: const TextStyle(color: Color(0xff9098B1)),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFEBF0FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFB4C2F8),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEBF0FF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _genderOption('Laki-Laki', Icons.male, 'male'),
          _genderOption('Perempuan', Icons.female, 'female'),
        ],
      ),
    );
  }

  Widget _genderOption(String label, IconData icon, String value) {
    final isSelected = selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = value),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: const Color(0xFF9098B1),
            size: 20,
          ),
          const SizedBox(width: 4),
          Icon(icon, color: const Color(0xFF9098B1), size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9098B1),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
