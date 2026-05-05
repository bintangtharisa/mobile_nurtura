import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class TipsService {
  static Future<List<Map<String, dynamic>>> getTips() async {
    final token = await Session.getToken();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/tips'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil tips');
    }
  }

  static Future<Map<String, dynamic>> getTipsPopuler() async {
    final token = await Session.getToken();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/tips/populer'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil tips populer');
    }
  }
}