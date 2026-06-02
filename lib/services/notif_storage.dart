import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotifStorage {
  static const key = "notif_history";
  static const fatherKey = "father_notif_history";

  static Future<void> save(String title, String body, {String? type}) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(key) ?? [];

    list.add(jsonEncode({
      "title": title,
      "body": body,
      "type": type ?? "skrining",
      "time": DateTime.now().toIso8601String(),
    }));

    await prefs.setStringList(key, list);
  }

  static Future<void> saveFather(
    String title,
    String body, {
    required String type,
    bool berisiko = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(fatherKey) ?? [];

    list.add(jsonEncode({
      "title": title,
      "body": body,
      "type": type,
      "berisiko": berisiko,
      "time": DateTime.now().toIso8601String(),
    }));

    await prefs.setStringList(fatherKey, list);
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(key) ?? [];

    return list
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getAllFather() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(fatherKey) ?? [];

    return list
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }
}
