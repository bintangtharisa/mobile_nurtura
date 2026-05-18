import 'dart:convert';
import 'package:http/http.dart' as http;

class MLService {
  static const String _baseUrl = 'https://web-production-f1df64.up.railway.app';

  static Future<MLResult> predict(List<int?> jawaban) async {
    try {
      final payload = {
        "features": jawaban.map((e) => e ?? 0).toList(),
      };

      final response = await http
          .post(
            Uri.parse('$_baseUrl/predict'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10)); // ⏱️ anti hang

      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Unknown error');
      }

      return MLResult.fromJson(data);
    } catch (e) {
      throw Exception('Gagal request ke server: $e');
    }
  }

  static Future<bool> checkHealth() async {
    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

class MLResult {
  final int cluster;
  final String result;

  MLResult({
    required this.cluster,
    required this.result,
  });

  factory MLResult.fromJson(Map<String, dynamic> json) {
    return MLResult(
      cluster: json['cluster'] ?? -1,
      result: json['result'] ?? 'Tidak diketahui',
    );
  }

  bool get isRisk => cluster == 0;
}