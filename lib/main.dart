import 'package:flutter/material.dart';
import 'package:m_diabetic_care/view/edukasi_berita_page.dart';
import 'package:m_diabetic_care/view/home_page.dart';
import 'package:m_diabetic_care/view/kalkulator_page.dart';
import 'package:m_diabetic_care/view/kalori_tracker_page.dart';
import 'package:m_diabetic_care/view/login_page.dart';
import 'package:m_diabetic_care/view/manajemen_luka_page.dart';
import 'package:m_diabetic_care/view/mitos_fakta_page.dart';
import 'package:m_diabetic_care/view/panduan_terapi_page.dart';
import 'package:m_diabetic_care/view/pengingat_olahraga_page.dart';
import 'package:m_diabetic_care/view/poster_page.dart';
import 'package:m_diabetic_care/view/register_page.dart';
import 'package:m_diabetic_care/view/reminder_obat_page.dart';
import 'package:m_diabetic_care/view/splash_screen_page.dart';
import 'package:m_diabetic_care/view/view_edukasi_page.dart';

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
        '/kalkulator': (context) => const KalkulatorPage(),
        '/olahraga': (context) => const PengingatOlahragaPage(),
        '/video-edukasi': (context) => const VideoEdukasiPage(),
        '/poster': (context) => const PosterPage(),
        '/mitos': (context) => const MitosFaktaPage(),
        '/berita': (context) => const EdukasiBeritaPage(),
        '/manajemen-luka': (context) => const ManajemenLukaPage(),
        '/panduan': (context) => const PanduanTerapiPage(),


      },
    );
  }
}
