import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotifStorage {
  static const key = "notif_history";

  static Future<void> save(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(key) ?? [];

    list.add(jsonEncode({
      "title": title,
      "body": body,
      "time": DateTime.now().toIso8601String(),
    }));

    await prefs.setStringList(key, list);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(key) ?? [];

    return list
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }
}