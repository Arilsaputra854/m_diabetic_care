import 'package:flutter/material.dart';
import 'package:m_diabetic_care/view/change_password_setting.dart';
import 'package:m_diabetic_care/view/edukasi_berita_page.dart';
import 'package:m_diabetic_care/view/fakta_mitos_page.dart';
import 'package:m_diabetic_care/view/forgot_password.dart';
import 'package:m_diabetic_care/view/home_page.dart';
import 'package:m_diabetic_care/view/input_makanan_page.dart';
import 'package:m_diabetic_care/view/kalkulator_page.dart';
import 'package:m_diabetic_care/view/kalori_tracker_page.dart';
import 'package:m_diabetic_care/view/login_page.dart';
import 'package:m_diabetic_care/view/manajemen_luka_page.dart';
import 'package:m_diabetic_care/view/obat_page.dart';
import 'package:m_diabetic_care/view/otp_verification_page.dart';
import 'package:m_diabetic_care/view/panduan_terapi_page.dart';
import 'package:m_diabetic_care/view/pengingat_olahraga_page.dart';
import 'package:m_diabetic_care/view/poster_page.dart';
import 'package:m_diabetic_care/view/profile_page.dart';
import 'package:m_diabetic_care/view/register_page.dart';
import 'package:m_diabetic_care/view/reminder_obat_page.dart';
import 'package:m_diabetic_care/view/reset_password_page.dart';
import 'package:m_diabetic_care/view/setting_page.dart';
import 'package:m_diabetic_care/view/splash_screen_page.dart';
import 'package:m_diabetic_care/view/view_edukasi_page.dart';
import 'package:m_diabetic_care/viewmodel/login_viewmodel.dart';
import 'package:m_diabetic_care/viewmodel/myths_facts_view_model.dart';
import 'package:m_diabetic_care/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewmodel()),
        ChangeNotifierProvider(create: (_) => MythsFactsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/home': (context) => const HomePageV2(),
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
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/otp-verification': (context) => const OtpVerificationPage(),
        '/change-password-setting': (context) => const ChangePasswordSetting(),
        '/setting' : (context) => const SettingPage(),
        '/profile' : (context) => const ProfilePage(),
        '/fakta-mitos' : (context) => const MitosFaktaPage(),    
        '/input-makanan': (context) => const InputMakananPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
