import 'package:flutter/material.dart';

class ChangePasswordSetting extends StatelessWidget {
  const ChangePasswordSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final _currentController = TextEditingController();
    final _newController = TextEditingController();
    final _confirmController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPasswordField('Kata sandi sekarang', _currentController),
            const SizedBox(height: 12),
            _buildPasswordField('Kata sandi baru', _newController),
            const SizedBox(height: 12),
            _buildPasswordField('Konfirmasi kata sandi baru', _confirmController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Simpan'),
                onPressed: () {
                  // simpan logic
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

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
