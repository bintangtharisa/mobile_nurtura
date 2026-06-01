import 'dart:convert';
import 'package:flutter/foundation.dart';
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

  static Future<Map<String, dynamic>> getMonitoringData({
    String? chartPeriod,
    String? anonymousId,
    int? sinceDays,
  }) async {
    final headers = await _buildHeaders();

    final queryParams = <String, String>{};

    if (chartPeriod != null) queryParams['chart_period'] = chartPeriod;
    if (anonymousId != null && anonymousId.isNotEmpty) {
      queryParams['anonymous_id'] = anonymousId;
    }
    if (sinceDays != null && sinceDays > 0) {
      queryParams['since_days'] = sinceDays.toString();
    }

    final uri = Uri.parse('${Api.baseUrl}/father/monitoring')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: headers).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Request timeout'),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    return jsonDecode(response.body);
  }

  static List<double> formatChartData(Map<String, dynamic>? chartData) {
    if (chartData == null) return [];

    final values = chartData['values'] as List<dynamic>?;

    if (values == null) return [];

    return values.map((e) => (e as num).toDouble()).toList();
  }

  /// 🔥 SINGLE SOURCE OF TRUTH
  static bool isRisky(dynamic result, dynamic cluster) {
    if (cluster != null) {
      final c = int.tryParse(cluster.toString());
      if (c != null) return c == 0;
    }

    final r = result.toString().toLowerCase().trim();

    const risky = [
      'berisiko depresi',
      'high risk',
      'risiko tinggi',
    ];

    const safe = [
      'tidak berisiko depresi',
      'low risk',
      'aman',
    ];

    if (risky.contains(r)) return true;
    if (safe.contains(r)) return false;

    return false;
  }

  static List<Map<String, dynamic>> formatHistoryList(List<dynamic>? data) {
    if (data == null) return [];

    return data.map((item) {
      final map = item as Map<String, dynamic>;

      final result = map['result'] ?? '';
      final cluster = map['cluster'];

      return {
        'id': map['id']?.toString(),
        'tanggal': _formatDate(map['created_at']),
        'status': _formatStatus(result),
        'cluster': cluster,
        'berisiko': isRisky(result, cluster), // 🔥 ONLY SOURCE
      };
    }).toList();
  }

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';

    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  static String _formatStatus(dynamic result) {
    final r = result.toString().toLowerCase();

    if (r.contains('tidak berisiko')) return 'Tidak Berisiko Depresi';
    if (r.contains('berisiko')) return 'Berisiko Depresi';

    return result.toString();
  }
}