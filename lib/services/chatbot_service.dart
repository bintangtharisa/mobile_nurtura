import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class ChatbotService {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Kirim pesan ke chatbot
  /// [message] - pesan yang dikirim user
  /// [sessionId] - opsional, kalau null akan buat sesi baru
  static Future<Map<String, dynamic>> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    try {
      debugPrint('🔍 [ChatbotService] Sending message...');

      final headers = await _buildHeaders();
      final body = <String, dynamic>{'message': message};
      if (sessionId != null) body['session_id'] = sessionId;

      final response = await http
          .post(
            Uri.parse('${Api.baseUrl}/chatbot/message'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 30), // lebih lama karena AI
            onTimeout: () => throw Exception('Request timeout'),
          );

      debugPrint(
        '📡 [ChatbotService] Send message status: ${response.statusCode}',
      );
      print('BODY: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [ChatbotService] Message sent!');
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else if (response.statusCode == 403) {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Akses ditolak');
      } else if (response.statusCode == 422) {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Pesan tidak valid');
      } else {
        throw Exception('Gagal mengirim pesan (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ChatbotService] Exception: $e');
      rethrow;
    }
  }

  /// Ambil list semua sesi chatbot
  static Future<List<Map<String, dynamic>>> getSessions() async {
    try {
      debugPrint('🔍 [ChatbotService] Fetching sessions...');

      final headers = await _buildHeaders();
      final response = await http
          .get(Uri.parse('${Api.baseUrl}/chatbot/sessions'), headers: headers)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      debugPrint('📡 [ChatbotService] Sessions status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [ChatbotService] Sessions loaded!');
        return List<Map<String, dynamic>>.from(body['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else {
        throw Exception('Gagal memuat sesi (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ChatbotService] Exception: $e');
      rethrow;
    }
  }

  /// Ambil pesan dalam sesi tertentu
  static Future<Map<String, dynamic>> getMessages(String sessionId) async {
    try {
      debugPrint(
        '🔍 [ChatbotService] Fetching messages for session $sessionId...',
      );

      final headers = await _buildHeaders();
      final response = await http
          .get(
            Uri.parse('${Api.baseUrl}/chatbot/sessions/$sessionId/messages'),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      debugPrint('📡 [ChatbotService] Messages status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [ChatbotService] Messages loaded!');
        return {
          'session': body['session'],
          'messages': List<Map<String, dynamic>>.from(body['data']),
        };
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else if (response.statusCode == 404) {
        throw Exception('Sesi tidak ditemukan');
      } else {
        throw Exception('Gagal memuat pesan (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ChatbotService] Exception: $e');
      rethrow;
    }
  }

  /// Hapus sesi chatbot
  static Future<bool> deleteSession(String sessionId) async {
    try {
      debugPrint('🔍 [ChatbotService] Deleting session $sessionId...');

      final headers = await _buildHeaders();
      final response = await http
          .delete(
            Uri.parse('${Api.baseUrl}/chatbot/sessions/$sessionId'),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      debugPrint(
        '📡 [ChatbotService] Delete session status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [ChatbotService] Session deleted!');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else if (response.statusCode == 404) {
        throw Exception('Sesi tidak ditemukan');
      } else {
        throw Exception('Gagal menghapus sesi (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [ChatbotService] Exception: $e');
      rethrow;
    }
  }
}
