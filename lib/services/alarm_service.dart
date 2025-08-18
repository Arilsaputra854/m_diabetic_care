import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermission {
  /// Cek apakah izin exact alarm sudah diberikan
  static Future<bool> hasExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      return status.isGranted;
    }
    return true; // iOS tidak perlu
  }

  /// Minta izin dengan membuka halaman pengaturan khusus
  static Future<void> requestExactAlarmPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      if (!status.isGranted) {
        final result = await Permission.scheduleExactAlarm.request();
        if (!result.isGranted) {
          // Kalau user tetap nolak, arahkan manual ke settings
          openAppSettings();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Izin alarm presisi dibutuhkan agar pengingat berjalan tepat waktu. Aktifkan di Settings → Alarms & reminders.'),
            ),
          );
        }
      }
    }
  }
}
