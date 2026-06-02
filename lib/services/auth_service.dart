import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/api.dart';
import '../services/session.dart';
import 'dart:io';

class AuthService {
  static Map<String, dynamic> _normalizeUser(
    Map<String, dynamic> user, [
    Map<String, dynamic>? fallback,
  ]) {
    return {
      ...user,
      'id': user['id'] ?? user['_id'] ?? fallback?['id'] ?? fallback?['_id'],
      'name': user['name'] ?? user['username'] ?? fallback?['name'] ?? fallback?['username'],
      'connection_code': user['connection_code'] ??
          user['anonymous_id'] ??
          fallback?['connection_code'] ??
          fallback?['anonymous_id'],
    };
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final token = await Session.getToken();

      final headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.post(
        Uri.parse("${Api.baseUrl}/auth/login"),
        headers: headers,
        body: jsonEncode({"email": email, "password": password}),
      );

      print("LOGIN URL: ${Api.baseUrl}/auth/login");
      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {
          "success": false,
          "message": "Response bukan JSON",
          "raw": response.body,
        };
      }

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          await Session.saveToken(data['token']);
        }
        if (data['user'] is Map<String, dynamic>) {
          final user = _normalizeUser(Map<String, dynamic>.from(data['user']));
          data['user'] = user;
          await Session.saveUser(user);
        }
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data['message'] ?? "Login gagal"};
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role, [
    String? connectionCode,
  ]) async {
    try {
      final body = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
        "role": role,
      };

      if (connectionCode != null && connectionCode.isNotEmpty) {
        body["connection_code"] = connectionCode;
      }

      final response = await http.post(
        Uri.parse("${Api.baseUrl}/auth/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
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
        if (data['data'] is Map<String, dynamic>) {
          final user = _normalizeUser(Map<String, dynamic>.from(data['data']));
          data['data'] = user;
          await Session.saveUser(user);
        }
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Register gagal",
        };
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
        Uri.parse("${Api.baseUrl}/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
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
        final cachedUser = await Session.getUser();
        final user = _normalizeUser(
          Map<String, dynamic>.from(data['data']),
          cachedUser,
        );
        await Session.saveUser(user);
        return {"success": true, "data": user};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Gagal ambil user",
        };
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
        return {
          "success": false,
          "message": data['message'] ?? "Gagal kirim email",
        };
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
        Uri.parse("${Api.baseUrl}/mother/connection-requests"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("KONEKSI STATUS: ${response.statusCode}");
      print("KONEKSI BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        final requests = data['data'] is List ? data['data'] as List : [];
        final pending = requests.isNotEmpty
            ? Map<String, dynamic>.from(requests.first as Map)
            : null;
        final activeConnection = data['active_connection'] is Map
            ? Map<String, dynamic>.from(data['active_connection'] as Map)
            : null;
        final cachedFather = pending == null ? await Session.getConnectedFather() : null;
        final connectedFather = activeConnection == null
            ? cachedFather
            : {
                "id": activeConnection['father_id'],
                "name": activeConnection['father_username'],
                "email": activeConnection['father_email'],
                "sejak": activeConnection['connected_at'],
              };

        return {
          "success": true,
          "data": {
            "pending_request": pending == null
                ? null
                : {
                    "id": pending['father_id'],
                    "name": pending['father_username'],
                    "email": pending['father_email'],
                    "requested_at": pending['requested_at'],
                  },
            "pasangan": connectedFather,
          },
        };
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Gagal ambil koneksi",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= UPDATE PROFIL =================
  static Future<Map<String, dynamic>> updateProfil({
    required String nama,
    required String email,
  }) async {
    try {
      final token = await Session.getToken();

      final response = await http.put(
        Uri.parse("${Api.baseUrl}/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"username": nama}),
      );

      print("UPDATE PROFIL STATUS: ${response.statusCode}");
      print("UPDATE PROFIL BODY: ${response.body}");

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
          "message": data['message'] ?? "Gagal update profil",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= UPDATE PHOTO =================
  static Future<Map<String, dynamic>> updatePhoto(XFile fotoFile) async {
    try {
      final token = await Session.getToken();

      print("UPDATE PHOTO: Memulai upload - ${fotoFile.path}");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${Api.baseUrl}/profile/photo"),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      // Pakai fromBytes agar support Flutter Web maupun Mobile
      final bytes = await fotoFile.readAsBytes();
      final fileName = fotoFile.name.isNotEmpty ? fotoFile.name : 'photo.jpg';
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          bytes,
          filename: fileName,
        ),
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print("UPDATE PHOTO STATUS: ${response.statusCode}");
      print("UPDATE PHOTO BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        // Update cached user dengan photo_url baru
        final photoUrl = data['data']?['photo_url'] ?? data['data']?['photo'];
        if (photoUrl != null) {
          final cachedUser = await Session.getUser() ?? {};
          cachedUser['photo'] = photoUrl;
          await Session.saveUser(cachedUser);
        }
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Gagal upload foto",
        };
      }
    } catch (e) {
      print("UPDATE PHOTO ERROR: $e");
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= LOGOUT =================
  static Future<Map<String, dynamic>> logout() async {
    try {
      await Session.saveToken('');
      return {"success": true};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= CHANGE PASSWORD =================
  static Future<Map<String, dynamic>> changePassword({
    required String passwordLama,
    required String passwordBaru,
  }) async {
    try {
      print("CHANGE PASSWORD SERVICE: Memulai");
      final token = await Session.getToken();
      print("CHANGE PASSWORD SERVICE: Token retrieved: ${token != null ? 'YES' : 'NO'}");

      final url = "${Api.baseUrl}/change-password";
      print("CHANGE PASSWORD SERVICE: URL: $url");

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "old_password": passwordLama,
          "new_password": passwordBaru,
          "new_password_confirmation": passwordBaru,
        }),
      );

      print("CHANGE PASSWORD SERVICE: Status: ${response.statusCode}");
      print("CHANGE PASSWORD SERVICE: Body: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        print("CHANGE PASSWORD SERVICE: Response bukan JSON");
        return {"success": false, "message": "Response bukan JSON"};
      }

      if (response.statusCode == 200) {
        print("CHANGE PASSWORD SERVICE: Success");
        return {"success": true, "data": data};
      } else {
        print("CHANGE PASSWORD SERVICE: Failed - ${data['message']}");
        return {
          "success": false,
          "message": data['message'] ?? "Gagal ubah sandi",
        };
      }
    } catch (e) {
      print("CHANGE PASSWORD SERVICE: Exception - $e");
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= TERIMA KONEKSI =================
  static Future<Map<String, dynamic>> terimaKoneksi(String fatherId) async {
    try {
      final token = await Session.getToken();

      final response = await http.patch(
        Uri.parse("${Api.baseUrl}/mother/father/accept"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"father_id": fatherId}),
      );

      print("TERIMA KONEKSI STATUS: ${response.statusCode}");
      print("TERIMA KONEKSI BODY: ${response.body}");

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
          "message": data['message'] ?? "Gagal terima koneksi",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= TOLAK KONEKSI =================
  static Future<Map<String, dynamic>> tolakKoneksi() async {
    return {"success": false, "message": "father_id tidak ditemukan"};
  }

  static Future<Map<String, dynamic>> tolakKoneksiByFatherId(String fatherId) async {
    try {
      final token = await Session.getToken();

      final response = await http.patch(
        Uri.parse("${Api.baseUrl}/mother/father/reject"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"father_id": fatherId}),
      );

      print("TOLAK KONEKSI STATUS: ${response.statusCode}");
      print("TOLAK KONEKSI BODY: ${response.body}");

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
          "message": data['message'] ?? "Gagal tolak koneksi",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ================= BLOCK KONEKSI AKTIF =================
  static Future<Map<String, dynamic>> blockKoneksiByFatherId(String fatherId) async {
    try {
      final token = await Session.getToken();

      final response = await http.patch(
        Uri.parse("${Api.baseUrl}/mother/father/block"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"father_id": fatherId}),
      );

      print("BLOCK KONEKSI STATUS: ${response.statusCode}");
      print("BLOCK KONEKSI BODY: ${response.body}");

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
          "message": data['message'] ?? "Gagal block koneksi",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}