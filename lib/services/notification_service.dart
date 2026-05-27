import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../../../services/session.dart';

class NotificationService {
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await Session.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch list notifikasi (dengan pagination)
  static Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      debugPrint('🔍 [NotificationService] Fetching notifications...');

      final headers = await _buildHeaders();
      final uri = Uri.parse('${Api.baseUrl}/notifications').replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      debugPrint('🌐 [NotificationService] Request URL: $uri');

      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [NotificationService] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ [NotificationService] Success!');
        return body['data'] as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else {
        throw Exception('Gagal memuat notifikasi (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [NotificationService] Exception: $e');
      rethrow;
    }
  }

  /// Ambil jumlah notifikasi yang belum dibaca
  static Future<int> getUnreadCount() async {
    try {
      debugPrint('🔍 [NotificationService] Fetching unread count...');

      final headers = await _buildHeaders();
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/notifications/unread-count'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [NotificationService] Unread count status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body['data']['count'] as int;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else {
        throw Exception('Gagal mengambil unread count (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [NotificationService] Exception: $e');
      rethrow;
    }
  }

  /// Tandai 1 notifikasi sebagai sudah dibaca
  static Future<bool> markAsRead(String id) async {
    try {
      debugPrint('🔍 [NotificationService] Marking notification $id as read...');

      final headers = await _buildHeaders();
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/notifications/$id/read'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [NotificationService] Mark as read status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('✅ [NotificationService] Marked as read!');
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Notifikasi tidak ditemukan');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else {
        throw Exception('Gagal menandai notifikasi (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [NotificationService] Exception: $e');
      rethrow;
    }
  }

  /// Tandai semua notifikasi sebagai sudah dibaca
  static Future<int> readAll() async {
    try {
      debugPrint('🔍 [NotificationService] Marking all notifications as read...');

      final headers = await _buildHeaders();
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/notifications/read-all'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      debugPrint('📡 [NotificationService] Read all status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final count = body['data']['updated_count'] as int;
        debugPrint('✅ [NotificationService] $count notifications marked as read!');
        return count;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - silakan login ulang');
      } else {
        throw Exception('Gagal menandai semua notifikasi (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 [NotificationService] Exception: $e');
      rethrow;
    }
  }
}