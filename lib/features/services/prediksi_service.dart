import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';

class PrediksiService {
  static Future<Map<String, dynamic>> kirimJawaban(List<int?> jawaban) async {
    final response = await http.post(
      Uri.parse('${Api.baseUrl}/prediksi'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jawaban': jawaban}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengirim jawaban');
    }
  }

  static Future<Map<String, dynamic>> getHasilTerakhir() async {
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/prediksi/terakhir'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil hasil terakhir');
    }
  }

  static Future<List<Map<String, dynamic>>> getRiwayat() async {
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/prediksi/riwayat'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil riwayat');
    }
  }
}