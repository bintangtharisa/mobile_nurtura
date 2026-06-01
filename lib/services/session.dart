import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Session {

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("user");
    if (user == null || user.isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(user));
  }

  static Future<void> saveConnectedFather(Map<String, dynamic> father) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("connected_father", jsonEncode(father));
  }

  static Future<Map<String, dynamic>?> getConnectedFather() async {
    final prefs = await SharedPreferences.getInstance();
    final father = prefs.getString("connected_father");
    if (father == null || father.isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(father));
  }

  static Future<void> clearConnectedFather() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("connected_father");
  }
}
