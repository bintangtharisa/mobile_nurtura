import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../services/session.dart';

class FatherService {
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final token = await Session.getToken();

      final response = await http.get(
        Uri.parse("${Api.baseUrl}/father/dashboard"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("FATHER DASHBOARD STATUS: ${response.statusCode}");
      print("FATHER DASHBOARD BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Gagal ambil dashboard",
        };
      }
    } catch (e) {
      print("FATHER DASHBOARD ERROR: $e");
      return {"success": false, "message": "Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getArticles() async {
    try {
      final response = await http.get(
        Uri.parse("${Api.baseUrl}/articles"),
        headers: {
          "Accept": "application/json",
        },
      );

      print("ARTICLES STATUS: ${response.statusCode}");
      print("ARTICLES BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Gagal ambil artikel",
        };
      }
    } catch (e) {
      print("ARTICLES ERROR: $e");
      return {"success": false, "message": "Error: $e"};
    }
  }
}
