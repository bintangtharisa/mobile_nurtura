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

  // GET /articles → List semua artikel
  static Future<List<Map<String, dynamic>>> getArticles() async {
    final headers = await _buildHeaders();
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/articles'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print('ARTIKEL PERTAMA: ${data.isNotEmpty ? data[0] : 'kosong'}');
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil artikel (${response.statusCode})');
    }
  }

  // Artikel populer → ambil semua lalu sort by views (client-side)
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

  // Ambil semua data yang dibutuhkan halaman Lihat Tips secara paralel
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

  // GET /articles/{article} → Detail satu artikel
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

  // POST /articles → Buat artikel baru (auth + admin)
  static Future<Map<String, dynamic>> storeArticle(
      Map<String, dynamic> payload) async {
    final headers = await _buildHeaders();
    final response = await http.post(
      Uri.parse('${Api.baseUrl}/articles'),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Gagal membuat artikel (${response.statusCode})');
    }
  }

  // PUT /articles/{article} → Update artikel (auth + admin)
  static Future<Map<String, dynamic>> updateArticle(
      int id, Map<String, dynamic> payload) async {
    final headers = await _buildHeaders();
    final response = await http.put(
      Uri.parse('${Api.baseUrl}/articles/$id'),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Gagal mengupdate artikel (${response.statusCode})');
    }
  }

  // DELETE /articles/{article} → Hapus artikel (auth + admin)
  static Future<void> deleteArticle(int id) async {
    final headers = await _buildHeaders();
    final response = await http.delete(
      Uri.parse('${Api.baseUrl}/articles/$id'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus artikel (${response.statusCode})');
    }
  }
}