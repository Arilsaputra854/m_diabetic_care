import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ubah Kata Sandi'),
            onTap: () {
              Navigator.pushNamed(context, '/change-password-setting');
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Update Data Pengguna'),
            onTap: () {
              Navigator.pushNamed(context, '/update-user');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus Akun'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
