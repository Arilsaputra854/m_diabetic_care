import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notifications.initialize(initSettings);

    final granted =
        await _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
    print("🔔 [DEBUG] Permission granted? $granted");
    _scheduleDailyMealReminders();
  }

  static Future<void> scheduleNotificationFromString({
    required int id,
    required String title,
    required String body,
    required String time, // format "HH:mm"
  }) async {
    try {
      print("🔔 [DEBUG] scheduleNotificationFromString dipanggil");

      print(
        "🔔 [DEBUG] Param -> id: $id, title: $title, body: $body, time: $time",
      );

      // Parsing string "HH:mm"
      final parts = time.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();

      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      if (scheduledDate.isBefore(now)) {
        print("🔔 [DEBUG] Waktu sudah lewat, geser ke besok");
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'diabetic_reminder_notification',
          'Reminder Diabetic',
          channelDescription: 'Channel untuk notifikasi reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // supaya daily
      );

      print("✅ [DEBUG] Notifikasi berhasil dijadwalkan");
      print(
        "🔔 [DEBUG] Jadwal notif di: ${tz.TZDateTime.from(scheduledDate, tz.local)}",
      );
    } catch (e) {
      print("❌ [ERROR] scheduleNotificationFromString gagal: $e");
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static void _scheduleDailyMealReminders() {
    NotificationService.scheduleNotificationFromString(
      id: 1,
      title: "Waktunya Sarapan",
      body: "Yuk isi energi pagi dengan sarapan sehat 🍞🥛",
      time: "07:00",
    );

    NotificationService.scheduleNotificationFromString(
      id: 2,
      title: "Waktunya Cemilan Pagi",
      body: "Jangan lupa cemilan sehat biar nggak lapar sebelum makan siang 🍎",
      time: "10:00",
    );

    NotificationService.scheduleNotificationFromString(
      id: 3,
      title: "Waktunya Makan Siang",
      body: "Saatnya makan siang! Pastikan porsinya sesuai kebutuhan 🍚🥗",
      time: "12:00",
    );

    NotificationService.scheduleNotificationFromString(
      id: 4,
      title: "Waktunya Cemilan Sore",
      body: "Yuk cemilan sehat biar tetap semangat sore ini 🍪☕",
      time: "16:00",
    );

    NotificationService.scheduleNotificationFromString(
      id: 5,
      title: "Waktunya Makan Malam",
      body: "Saatnya makan malam! Pilih makanan ringan biar tidur nyenyak 🍲",
      time: "19:00",
    );
  }
}
