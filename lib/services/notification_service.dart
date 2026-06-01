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

  static Future<void> showFatherNotification({
  required String title,
  required String body,
  required String risk,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool('notif_enabled') ?? true;

  if (!enabled) return;

  // 🔥 FILTER LOGIKA AYAH
  final fatherMode = prefs.getString('father_notif_mode') ?? 'all';

  // hanya risiko tinggi
  if (fatherMode == 'risk_only' && risk != 'high') {
    return;
  }

  await plugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );

  await NotifStorage.save(title, body);
}
}