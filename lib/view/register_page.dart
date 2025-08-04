import 'package:flutter/material.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:m_diabetic_care/viewmodel/register_viewmodel.dart';
import 'package:m_diabetic_care/widget/riwayat_dm_widget.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String gender = 'Laki-laki';
  bool hasDMFamily = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // tanpa bayangan
        automaticallyImplyLeading: true, // munculkan back button
        iconTheme: const IconThemeData(
          color: Color(0xff9098B1), // warna ikon back (optional)
        ),
      ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Logo
              Image.asset('assets/logo/logo.png', width: 250, height: 250),

              const SizedBox(height: 4),
              const Text(
                'Daftarkan Diri Anda!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Nama Lengkap
              _buildTextField(
                controller: nameController,
                hintText: 'Nama Lengkap',
                icon: Icons.person_outline,
              ),

              // Jenis Kelamin
              _buildGenderSelector(),

              // Email
              _buildTextField(
                controller: emailController,
                hintText: 'Email Anda',
                icon: Icons.email_outlined,
              ),

              // Tanggal Lahir
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        birthDateController.text =
                            pickedDate.toIso8601String().split(
                              'T',
                            )[0]; // Format: yyyy-MM-dd
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: birthDateController,
                      decoration: InputDecoration(
                        hintText: 'Tanggal Lahir Anda',
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: Color(0xff9098B1),
                        ),
                        hintStyle: const TextStyle(color: Color(0xff9098B1)),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEBF0FF),
                          ),
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
              ),

              // Nomor Telepon
              _buildTextField(
                controller: phoneController,
                hintText: 'Nomor Telepon',
                icon: Icons.phone_outlined,
              ),

              // Berat Badan
              _buildTextField(
                controller: weightController,
                hintText: 'Berat Badan',
                icon: Icons.monitor_weight_outlined,
              ),

              // Tinggi Badan
              _buildTextField(
                controller: heightController,
                hintText: 'Tinggi Badan',
                icon: Icons.height,
              ),

              // Riwayat DM Keluarga
              RiwayatDMKeluargaDropdown(
                onChanged: (value) => setState(() => hasDMFamily = value),
              ),
              const SizedBox(height: 10),

              // Kata Sandi
              _buildTextField(
                controller: passwordController,
                hintText: 'Kata Sandi',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              // Konfirmasi Sandi
              _buildTextField(
                controller: confirmPasswordController,
                hintText: 'Konfirmasi Kata Sandi',
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Tombol Daftar
              Consumer<RegisterViewModel>(
                builder: (context, vm, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          vm.isLoading
                              ? null
                              : () async {
                                final vm = context.read<RegisterViewModel>();

                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password tidak cocok'),
                                    ),
                                  );
                                  return;
                                }

                                final success = await vm.registerUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                  birthDate: birthDateController.text,
                                  gender: selectedGender,
                                  phone: phoneController.text,
                                  weight:
                                      int.tryParse(weightController.text) ?? 0,
                                  height:
                                      int.tryParse(heightController.text) ?? 0,
                                  familyDMHistory: hasDMFamily,
                                );

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Registrasi berhasil!'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Registrasi gagal.'),
                                    ),
                                  );
                                }
                              },

                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1D5C63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          vm.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                              : const Text(
                                'Daftar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Color(0xff9098B1)),
          suffixIcon:
              onToggleVisibility != null
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xff9098B1),
                    ),
                    onPressed: onToggleVisibility,
                  )
                  : null,
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

  String selectedGender = 'male';

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEBF0FF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _genderOption(label: 'Laki-Laki', icon: Icons.male, value: 'male'),
          _genderOption(
            label: 'Perempuan',
            icon: Icons.female,
            value: 'female',
          ),
        ],
      ),
    );
  }

  Widget _genderOption({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedGender = value);
      },
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
