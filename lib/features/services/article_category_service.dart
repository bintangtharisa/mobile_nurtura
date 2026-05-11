import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class ArticleCategoryService {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final headers = await _buildHeaders();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/article-categories'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil kategori (${response.statusCode})');
    }
  }
}