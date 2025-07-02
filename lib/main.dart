import 'package:flutter/material.dart';
import 'package:m_diabetic_care/view/home_page.dart';
import 'package:m_diabetic_care/view/kalori_tracker_page.dart';
import 'package:m_diabetic_care/view/login_page.dart';
import 'package:m_diabetic_care/view/register_page.dart';
import 'package:m_diabetic_care/view/reminder_obat_page.dart';
import 'package:m_diabetic_care/view/splash_screen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Diabetic Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/reminder': (context) => const ReminderObatPage(),
        '/kalori': (context) => const KaloriTrackerPage(),
      },
    );
  }
}
