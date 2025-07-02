import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPhoneLogin = false; // Toggle antara Email / No HP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masuk'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Silakan masuk untuk melanjutkan.'),
            const SizedBox(height: 24),

            // Toggle Login Type
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Email"),
                  selected: !isPhoneLogin,
                  onSelected: (_) {
                    setState(() => isPhoneLogin = false);
                  },
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text("No. HP"),
                  selected: isPhoneLogin,
                  onSelected: (_) {
                    setState(() => isPhoneLogin = true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Input Email / No HP
            TextField(
              controller: emailController,
              keyboardType:
                  isPhoneLogin ? TextInputType.phone : TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: isPhoneLogin ? 'No. HP' : 'Email',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // Lupa Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Nanti arahkan ke halaman lupa password
                },
                child: const Text('Lupa Password?'),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/home');
                },
                child: const Text('Masuk'),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol ke Daftar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Daftar Sekarang'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
