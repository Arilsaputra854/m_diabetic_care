import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // tambahin ini

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay splash

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    debugPrint("TOKEN: $token");

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(), // biar logo tetap di tengah
            Center(child: Image.asset("assets/logo/logo.png")),
            Padding(
              padding: EdgeInsets.only(bottom: 24.h), // pakai .h biar responsif
              child: Column(
                children: [
                  Text(
                    "Didukung oleh Tim Peneliti:",
                    style: TextStyle(
                      fontSize: 12.sp, // dinamis sesuai device
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "apt. Dewi Indah Kurniawati, M.Farm\n"
                    "apt. Gina Aulia, M.Farm\n"
                    "Intan Tsamrotul Fu’adah, S.Si, M.Farm",
                    style: TextStyle(
                      fontSize: 14.sp, // dinamis juga
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
