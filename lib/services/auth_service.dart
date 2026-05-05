import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../services/session.dart';

class AuthService {

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/auth/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          await Session.saveToken(data['token']);
        }
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Login gagal"};
      }

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/auth/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password,
          "role": role,
        }),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Register gagal"};
      }

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= GET USER =================
  static Future<Map<String, dynamic>> getUser() async {
    try {
      final token = await Session.getToken();

      final response = await http.get(
        Uri.parse("${Api.baseUrl}/user"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      print("USER STATUS: ${response.statusCode}");
      print("USER BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Gagal ambil user"};
      }

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= FORGOT PASSWORD =================
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/password/forgot"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": email}),
      );

      print("FORGOT STATUS: ${response.statusCode}");
      print("FORGOT BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Gagal kirim email"};
      }

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= RESET PASSWORD =================
  static Future<Map<String, dynamic>> resetPassword(
    String email,
    String token,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/password/reset"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "token": token,
          "password": password,
        }),
      );

      print("RESET STATUS: ${response.statusCode}");
      print("RESET BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Reset gagal"};
      }

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= GET KONEKSI =================
  static Future<Map<String, dynamic>> getKoneksi() async {
    try {
      final token = await Session.getToken();

      final response = await http.get(
        Uri.parse("${Api.baseUrl}/koneksi"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Gagal ambil koneksi"};
      }

    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}