import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class ArticleServiceAyah {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch all articles from backend
  static Future<List<Map<String, dynamic>>> getArticles() async {
    try {
      debugPrint('🔍 [ArticleServiceAyah] Fetching articles...');
      
      final headers = await _buildHeaders();
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/articles'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [ArticleServiceAyah] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('✅ [ArticleServiceAyah] Success! Retrieved ${data.length} articles');
        return data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        debugPrint('❌ [ArticleServiceAyah] Unauthorized error');
        throw Exception('Unauthorized - silakan login ulang');
      } else {
        debugPrint('❌ [ArticleServiceAyah] HTTP error ${response.statusCode}');
        throw Exception('Failed to load articles (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ArticleServiceAyah] Exception caught: $e');
      rethrow;
    }
  }

  /// Format article data for horizontal card (edukasi)
  static Map<String, dynamic> formatForEdukasi(Map<String, dynamic> article) {
    final category = article['category'] as Map<String, dynamic>?;
    final categoryName = category?['name'] as String? ?? 'Umum';
    final categoryColor = category?['color'] as String? ?? '#A3B18A';
    
    return {
      'kategori': categoryName,
      'judul': article['title'] as String? ?? 'Tanpa Judul',
      'subjudul': article['description'] as String? ?? '',
      'warnaKategori': _parseColor(categoryColor),
      'gambar': article['thumbnail'] as String?,
      'id': (article['_id'] ?? article['id'])?.toString(),
      'description': article['description'] as String? ?? '',
      'thumbnail': article['thumbnail'] as String?,
    };
  }

  /// Format article data for vertical card (artikel list)
  static Map<String, dynamic> formatForArtikel(Map<String, dynamic> article) {
    final category = article['category'] as Map<String, dynamic>?;
    final categoryName = category?['name'] as String? ?? 'Umum';
    
    return {
      'kategori': categoryName,
      'title': article['title'] as String? ?? 'Tanpa Judul',
      'durasi': _estimateReadingTime(article['description'] as String? ?? ''),
      'icon': _getIconForCategory(categoryName),
      'id': (article['_id'] ?? article['id'])?.toString(),
      'description': article['description'] as String? ?? '',
      'thumbnail': article['thumbnail'] as String?,
    };
  }

  static Color _parseColor(String colorString) {
    try {
      final hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('0xFF$hexColor'));
      }
    } catch (e) {
      debugPrint('Error parsing color: $e');
    }
    return const Color(0xFFA3B18A);
  }

  static String _estimateReadingTime(String description) {
    final wordCount = description.split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return '$minutes menit baca';
  }

  static IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'self-care':
      case 'parenting tips':
        return Icons.self_improvement;
      case 'nutrisi':
      case 'nutrition':
        return Icons.restaurant_menu;
      case 'mental health':
      case 'child development':
        return Icons.favorite_border;
      default:
        return Icons.article;
    }
  }
}
