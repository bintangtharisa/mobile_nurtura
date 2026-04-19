import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../services/session.dart';

class AuthService {

  static Future login(String email, String password) async {
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

    return jsonDecode(response.body);
  }

  static Future getUser() async {
    final token = await Session.getToken();

    final response = await http.get(
      Uri.parse("${Api.baseUrl}/user"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    return jsonDecode(response.body);
  }
}