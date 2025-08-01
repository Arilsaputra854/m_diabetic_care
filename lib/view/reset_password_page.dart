import 'package:flutter/material.dart';
import 'package:m_diabetic_care/services/api_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ChangePasswordSettingState();
}

class _ChangePasswordSettingState extends State<ResetPasswordPage> {
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  late String email;
  late String resetToken;

  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    email = args['email'];
    resetToken = args['reset_token'];
  }

  @override
  void dispose() {
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganti Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPasswordField(
              'Kata sandi baru',
              _newController,
              _isNewPasswordHidden,
              () {
                setState(() {
                  _isNewPasswordHidden = !_isNewPasswordHidden;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPasswordField(
              'Konfirmasi kata sandi baru',
              _confirmController,
              _isConfirmPasswordHidden,
              () {
                setState(() {
                  _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Simpan'),
                onPressed: () async {
                  final password = _newController.text.trim();
                  final confirmPassword = _confirmController.text.trim();

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    _showSnackBar('Semua kolom wajib diisi');
                    return;
                  }

                  if (password != confirmPassword) {
                    _showSnackBar('Konfirmasi password tidak cocok');
                    return;
                  }

                  final success = await ApiService.resetPassword(
                    resetToken: resetToken,
                    password: password,
                    passwordConfirmation: confirmPassword,
                  );

                  if (success) {
                    _showSnackBar(
                      'Password berhasil diubah. Silakan login kembali.',
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  } else {
                    _showSnackBar('Gagal mengubah password. Coba lagi.');
                  }
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

  Widget _buildPasswordField(
    String hint,
    TextEditingController controller,
    bool isObscured,
    VoidCallback toggleVisibility,
  ) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
