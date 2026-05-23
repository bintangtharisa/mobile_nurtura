import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class ScreeningService {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch riwayat screening dari /api/mother/screening-history
  static Future<List<Map<String, dynamic>>> getScreeningHistory({
    String? result,
    int? sinceDays,
  }) async {
    try {
      debugPrint('🔍 [ScreeningService] Starting getScreeningHistory...');
      
      final headers = await _buildHeaders();
      debugPrint('🔑 [ScreeningService] Headers: ${headers.keys.join(', ')}');
      debugPrint('🔑 [ScreeningService] Has token: ${headers.containsKey('Authorization')}');
      
      final queryParams = <String, String>{};
      if (result != null && result.isNotEmpty) {
        queryParams['result'] = result;
      }
      if (sinceDays != null && sinceDays > 0) {
        queryParams['since_days'] = sinceDays.toString();
      }

      final uri = Uri.parse('${Api.baseUrl}/mother/screening-history')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      
      debugPrint('🌐 [ScreeningService] Request URL: $uri');
      debugPrint('🌐 [ScreeningService] Query params: $queryParams');

      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [ScreeningService] Response status: ${response.statusCode}');
      debugPrint('📡 [ScreeningService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];
        debugPrint('✅ [ScreeningService] Success! Retrieved ${data.length} screening records');
        return data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        debugPrint('❌ [ScreeningService] Unauthorized error');
        throw Exception('Unauthorized - silakan login ulang');
      } else if (response.statusCode == 403) {
        debugPrint('❌ [ScreeningService] Forbidden error');
        throw Exception('Forbidden - anda tidak memiliki akses');
      } else {
        debugPrint('❌ [ScreeningService] HTTP error ${response.statusCode}');
        throw Exception('Failed to load screening history (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ScreeningService] Exception caught: $e');
      rethrow;
    }
  }

  /// Format screening data untuk ditampilkan di UI
  static Map<String, dynamic> formatScreening(
    Map<String, dynamic> screening,
  ) {
    final createdAt = screening['created_at'] as String?;
    final riskCategory = screening['risk_category'] as String? ?? 'Tidak Diketahui';
    final anonymousId = screening['anonymous_id'] as String? ?? 'Unknown';
    final result = screening['result'] as String? ?? 'Tidak tersedia';

    return {
      'anonymous_id': anonymousId,
      'result': result,
      'risk_category': riskCategory,
      'berisiko': riskCategory.toLowerCase() == 'tinggi',
      'tanggal': _formatDate(createdAt),
      'jam': _formatTime(createdAt),
      'status': _getStatus(riskCategory),
      'created_at': createdAt,
    };
  }

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  static String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '--:--';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  static String _getStatus(String riskCategory) {
    switch (riskCategory.toLowerCase()) {
      case 'tinggi':
        return 'Berisiko Tinggi';
      case 'rendah':
        return 'Rendah Risiko';
      default:
        return 'Tidak Diketahui';
    }
  }
}
