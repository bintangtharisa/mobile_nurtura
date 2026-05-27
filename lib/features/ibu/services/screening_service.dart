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
          'tanggal': date != null ? '${date.day}/${date.month}/${date.year}' : '-',
          'jam': date != null
              ? '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
              : '--:--',
          'berisiko': result == 'Beresiko Depresi',
          'status': result == 'Beresiko Depresi' ? 'Berisiko Tinggi' : 'Rendah Risiko',
        };
      }).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>> submitScreening(
      Map<String, dynamic> answers) async {
    try {
      debugPrint('🔍 [ScreeningService] Submitting screening...');

      final headers = await _buildHeaders();
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/mother/screening'),
        headers: headers,
        body: jsonEncode(answers),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [ScreeningService] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [ScreeningService] Screening success!');
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else if (response.statusCode == 403) {
        throw Exception('Hanya mother yang bisa screening');
      } else {
        throw Exception('Gagal screening (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ScreeningService] Exception: $e');
      rethrow;
    }
  }

  static List<String> extractRekomendasi(Map<String, dynamic> screeningResult) {
    final recommendation =
        screeningResult['recommendation'] as Map<String, dynamic>?;

    if (recommendation == null) return [];

    final List<String> rekomendasi = [];

    // Emergency note — taruh paling atas kalau ada
    final emergencyNote = recommendation['emergency_note'] as String?;
    if (emergencyNote != null && emergencyNote.isNotEmpty) {
      rekomendasi.add('⚠️ $emergencyNote');
    }

    // Summary
    final summary = recommendation['summary'] as String?;
    if (summary != null && summary.isNotEmpty) rekomendasi.add(summary);

    // Action steps
    final actionSteps = recommendation['action_steps'] as List<dynamic>?;
    if (actionSteps != null) {
      rekomendasi.addAll(actionSteps.map((e) => e.toString()));
    }

    // Partner support
    final partnerSupport = recommendation['partner_support'] as List<dynamic>?;
    if (partnerSupport != null) {
      rekomendasi.addAll(partnerSupport.map((e) => e.toString()));
    }

    // Professional help
    final professionalHelp = recommendation['professional_help'] as String?;
    if (professionalHelp != null && professionalHelp.isNotEmpty) {
      rekomendasi.add(professionalHelp);
    }

    return rekomendasi;
  }
}