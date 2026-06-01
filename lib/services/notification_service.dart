import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/api.dart';
import 'session.dart';
import 'notif_storage.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();
  static bool _firebaseReady = false;

  static FirebaseMessaging? get _messaging {
    if (!_firebaseReady || Firebase.apps.isEmpty) return null;
    return FirebaseMessaging.instance;
  }

  static const fatherRiskOnlyKey = 'father_notif_risk_only';
  static const fatherAllChangesKey = 'father_notif_all_changes';
  static const fatherLastScreeningKey = 'father_last_screening_notif_id';

  static Future<void> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _firebaseReady = true;

      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      }
    } catch (_) {
      _firebaseReady = false;
      // Firebase config belum tersedia. Local notifications tetap berjalan.
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidInit);

    await plugin.initialize(settings);

    await _requestPermissions();
    _listenForegroundMessages();
    _listenTokenRefresh();
  }

  static Future<void> _requestPermissions() async {
    try {
      final messaging = _messaging;
      if (messaging == null) return;

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  static void _listenForegroundMessages() {
    if (_messaging == null) return;

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      final title = notification?.title ?? message.data['title'] ?? 'Nurtura';
      final body = notification?.body ?? message.data['body'] ?? '';

      await plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'nurtura_push_channel',
            'Nurtura Push Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });
  }

  static void _listenTokenRefresh() {
    final messaging = _messaging;
    if (messaging == null) return;

    messaging.onTokenRefresh.listen((token) {
      syncFcmToken(token: token);
    });
  }

  static Future<void> syncFcmToken({String? token}) async {
    try {
      final bearerToken = await Session.getToken();
      if (bearerToken == null || bearerToken.isEmpty) return;

      final messaging = _messaging;
      if (messaging == null) return;

      final fcmToken = token ?? await messaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      await http.post(
        Uri.parse('${Api.baseUrl}/notifications/device-token'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcm_token': fcmToken,
          'platform': 'android',
        }),
      );
    } catch (_) {}
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

  static Future<void> triggerFatherMonitoringNotification({
    required String screeningId,
    required String status,
    required bool berisiko,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allChanges = prefs.getBool(fatherAllChangesKey) ?? true;
    final riskOnly = prefs.getBool(fatherRiskOnlyKey) ?? false;
    final lastScreeningId = prefs.getString(fatherLastScreeningKey);

    if (screeningId.isEmpty || lastScreeningId == screeningId) return;

    final shouldNotify = allChanges || (riskOnly && berisiko);
    if (!shouldNotify) {
      await prefs.setString(fatherLastScreeningKey, screeningId);
      return;
    }

    final title = berisiko
        ? 'Kondisi Istri Berisiko Depresi'
        : 'Kondisi Istri Terpantau Stabil';
    final body = berisiko
        ? 'Hasil skrining terbaru membutuhkan perhatian dan dukungan Anda.'
        : 'Hasil skrining terbaru menunjukkan kondisi ibu stabil.';

    await plugin.show(
      berisiko ? 101 : 102,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          berisiko ? 'father_risk_channel' : 'father_change_channel',
          berisiko ? 'Notifikasi Risiko Father' : 'Notifikasi Perubahan Father',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    await NotifStorage.saveFather(
      title,
      body,
      type: berisiko ? 'peringatan' : 'stabil',
      berisiko: berisiko,
    );

    await prefs.setString(fatherLastScreeningKey, screeningId);
  }
}
