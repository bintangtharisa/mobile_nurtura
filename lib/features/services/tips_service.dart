import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class TipsService {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET /tips → List semua tips
  static Future<List<Map<String, dynamic>>> getTips() async {
    final headers = await _buildHeaders();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/tips'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil tips (${response.statusCode})');
    }
  }

  // GET /tips/populer → Tips dengan views tertinggi
  static Future<Map<String, dynamic>?> getTipsPopuler() async {
    final headers = await _buildHeaders();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/tips/populer'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) return null;
      return data as Map<String, dynamic>;
    } else {
      throw Exception('Gagal mengambil tips populer (${response.statusCode})');
    }
  }

  // Ambil semua sekaligus (paralel)
  static Future<Map<String, dynamic>> getAllTips() async {
    final results = await Future.wait([
      getTips(),
      getTipsPopuler(),
    ]);

    return {
      'tips': results[0],
      'populer': results[1],
    };
  }
}