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

  static Future<List<Map<String, dynamic>>> getScreeningHistory() async {
    try {
      final headers = await _buildHeaders();

      final uri = Uri.parse('${Api.baseUrl}/mother/screening-history');

      final response = await http.get(uri, headers: headers);

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed: ${response.statusCode}');
      }

      final json = jsonDecode(response.body);
      final List data = json['data'] ?? [];

      return data.map<Map<String, dynamic>>((item) {
        final result = item['result'] ?? '';

        final createdAt = item['created_at'];

        DateTime? date;
        try {
          date = DateTime.parse(createdAt.toString());
        } catch (_) {
          date = null;
        }

        return {
          'result': result,
          'tanggal': date != null
              ? '${date.day}/${date.month}/${date.year}'
              : '-',
          'jam': date != null
              ? '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
              : '--:--',
          'berisiko': result == 'Beresiko Depresi',
          'status': result == 'Beresiko Depresi'
              ? 'Berisiko Tinggi'
              : 'Rendah Risiko',
        };
      }).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}