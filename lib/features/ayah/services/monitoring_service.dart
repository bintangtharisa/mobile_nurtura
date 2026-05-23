import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class MonitoringServiceAyah {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch monitoring data from backend
  static Future<Map<String, dynamic>> getMonitoringData({
    String? chartPeriod,
    String? anonymousId,
    int? sinceDays,
  }) async {
    try {
      debugPrint('🔍 [MonitoringServiceAyah] Fetching monitoring data...');
      
      final headers = await _buildHeaders();
      
      final queryParams = <String, String>{};
      if (chartPeriod != null) {
        queryParams['chart_period'] = chartPeriod;
      }
      if (anonymousId != null && anonymousId.isNotEmpty) {
        queryParams['anonymous_id'] = anonymousId;
      }
      if (sinceDays != null && sinceDays > 0) {
        queryParams['since_days'] = sinceDays.toString();
      }

      final uri = Uri.parse('${Api.baseUrl}/father/monitoring')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      
      debugPrint('🌐 [MonitoringServiceAyah] Request URL: $uri');

      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [MonitoringServiceAyah] Response status: ${response.statusCode}');
      debugPrint('📄 [MonitoringServiceAyah] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [MonitoringServiceAyah] Success!');
        debugPrint('🔗 [MonitoringServiceAyah] is_connected: ${data['is_connected']}');
        debugPrint('👥 [MonitoringServiceAyah] mothers count: ${data['mothers']?.length ?? 0}');
        if (data['mothers'] != null && data['mothers'].isNotEmpty) {
          debugPrint('👤 [MonitoringServiceAyah] First mother: ${data['mothers'][0]}');
        }
        return data;
      } else if (response.statusCode == 401) {
        debugPrint('❌ [MonitoringServiceAyah] Unauthorized error');
        throw Exception('Unauthorized - silakan login ulang');
      } else if (response.statusCode == 403) {
        debugPrint('❌ [MonitoringServiceAyah] Forbidden error');
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Forbidden - anda tidak memiliki akses');
      } else if (response.statusCode == 404) {
        debugPrint('❌ [MonitoringServiceAyah] Not found error');
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Data tidak ditemukan');
      } else {
        debugPrint('❌ [MonitoringServiceAyah] HTTP error ${response.statusCode}');
        throw Exception('Failed to load monitoring data (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [MonitoringServiceAyah] Exception caught: $e');
      rethrow;
    }
  }

  /// Format chart data for UI
  static List<double> formatChartData(Map<String, dynamic>? chartData) {
    if (chartData == null) return [];
    
    final values = chartData['values'] as List<dynamic>?;
    if (values == null) return [];
    
    return values.map((v) => (v as num).toDouble()).toList();
  }

  /// Format screening history for UI
  static List<Map<String, dynamic>> formatHistoryList(List<dynamic>? data) {
    if (data == null) return [];
    
    return data.map((item) {
      final itemMap = item as Map<String, dynamic>;
      final result = itemMap['result'] as String? ?? 'Tidak Diketahui';
      final createdAt = itemMap['created_at'] as String?;
      
      return {
        'tanggal': _formatDate(createdAt),
        'status': _formatStatus(result),
        'berisiko': _isRisky(result),
        'id': itemMap['id'] as String?,
      };
    }).toList();
  }

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  static String _formatStatus(String result) {
    switch (result.toLowerCase()) {
      case 'berisiko':
      case 'high risk':
        return 'Berisiko Depresi';
      case 'tidak berisiko':
      case 'low risk':
      case 'normal':
        return 'Tidak Berisiko Depresi';
      default:
        return result;
    }
  }

  static bool _isRisky(String result) {
    return result.toLowerCase().contains('berisiko') || 
           result.toLowerCase().contains('high risk');
  }
}
