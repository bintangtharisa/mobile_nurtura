import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notif_storage.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidInit);

    await plugin.initialize(settings);
  }

  /// 🔥 NOTIF MANUAL (TRIGGER)
  static Future<void> triggerReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notif_enabled') ?? true;

    if (!enabled) return; // ❌ kalau OFF, stop

    await plugin.show(
      0,
      'Waktunya Skrining',
      'Jangan lupa lakukan skrining hari ini',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    await NotifStorage.save(
      'Waktunya Skrining',
      'Jangan lupa lakukan skrining hari ini',
    );
  }
}