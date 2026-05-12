import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class ArticleService {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Map<String, dynamic>>> getArticles() async {
    final headers = await _buildHeaders();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/articles'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print('ARTIKEL PERTAMA: ${data.isNotEmpty ? data[0] : "kosong"}');
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil artikel (${response.statusCode})');
    }
  }

  static Future<Map<String, dynamic>?> getPopulerArticle() async {
    final articles = await getArticles();
    if (articles.isEmpty) return null;
    articles.sort((a, b) {
      final viewsA = (a['views'] ?? a['view_count'] ?? 0) as int;
      final viewsB = (b['views'] ?? b['view_count'] ?? 0) as int;
      return viewsB.compareTo(viewsA);
    });
    return articles.first;
  }

  static Future<Map<String, dynamic>> getTipsPageData() async {
    final results = await Future.wait([
      getArticles(),
      getPopulerArticle(),
    ]);
    return {
      'articles': results[0],
      'populer': results[1],
    };
  }

  static Future<Map<String, dynamic>> getArticle(int id) async {
    final headers = await _buildHeaders();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/articles/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Gagal mengambil artikel (${response.statusCode})');
    }
  }
}
