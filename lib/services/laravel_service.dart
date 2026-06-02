import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/session.dart';
import '../services/auth_service.dart';
import '../utils/api.dart';

class LaravelService {
  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static List<String> extractRecommendationItems(Map<String, dynamic> data) {
    final recommendation =
        _asMap(data['recommendation']) ??
        _asMap(_asMap(data['prediction'])?['recommendation']) ??
        _asMap(_asMap(data['data'])?['recommendation']);

    if (recommendation == null) return [];

    final items = <String>[];

    void addText(String label, dynamic value) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) items.add('$label: $text');
    }

    void addList(String label, dynamic value) {
      if (value is List) {
        for (final item in value) {
          if (item is Map) {
            final areaLabel = item['label']?.toString().trim();
            final answer = item['answer']?.toString().trim();
            if (areaLabel != null && areaLabel.isNotEmpty) {
              items.add(
                answer != null && answer.isNotEmpty
                    ? '$label: $areaLabel (jawaban: $answer)'
                    : '$label: $areaLabel',
              );
            }
          } else {
            addText(label, item);
          }
        }
      }
    }

    addText('Catatan darurat', recommendation['emergency_note']);
    addText('Ringkasan', recommendation['summary']);
    addList('Area perhatian', recommendation['focus_areas']);
    addList('Langkah ibu', recommendation['action_steps']);
    addList('Dukungan pasangan', recommendation['partner_support']);
    addText('Bantuan profesional', recommendation['professional_help']);
    addText('Catatan', recommendation['disclaimer']);

    return items.take(5).toList();
  }

  static Map<String, dynamic> _normalizeScreeningResponse(
    Map<String, dynamic> body,
  ) {
    final data = _asMap(body['data']) ?? body;
    final prediction = _asMap(data['prediction']) ?? _asMap(body['prediction']);

    final normalized = <String, dynamic>{
      ...body,
      ...data,
      if (prediction != null) 'prediction': prediction,
    };

    normalized['result'] =
        normalized['result'] ?? prediction?['result'] ?? data['hasil'];
    normalized['recommendation'] =
        _asMap(normalized['recommendation']) ??
        _asMap(prediction?['recommendation']) ??
        _asMap(data['recommendation']);
    normalized['recommendation_items'] = extractRecommendationItems(normalized);

    return normalized;
  }

  static Future<Map<String, dynamic>> saveScreening({
    required List<int?> jawaban,
  }) async {
    // ---------- Auth ----------
    final token = await Session.getToken();

    // ---------- Get user ----------
    final cachedUser = await Session.getUser();
    var motherId = cachedUser?['id'] ?? cachedUser?['_id'];

    if (motherId == null || motherId.toString().isEmpty) {
      final userRes = await AuthService.getUser();

      print('USER RESPONSE:');
      print(userRes);

      if (userRes['success'] != true) {
        throw Exception('Gagal mengambil data user');
      }

      final userData = userRes['data'];
      motherId = userData?['id'] ?? userData?['_id'] ?? userData?['data']?['id'];
    }

    if (motherId == null) {
      throw Exception('mother_id tidak ditemukan');
    }

    print('MOTHER ID FIXED: $motherId');
    print('RAW JAWABAN: $jawaban');

    // ----------------------------------------------------
    // PILIHAN
    const pilihanUmum = ['Not at all', 'Sometimes', 'Yes'];

    const pilihanTidurKonsentrasi = ['Not at all', 'Often', 'Yes'];

    const pilihanBersalah = ['Not at all', 'Maybe', 'Yes'];

    const pilihanBunuhDiri = ['No', 'Yes'];

    final payload = {
      'mother_id': motherId,

      // 1 - perasaan sedih
      'perasaan_sedih_atau_mudah_menangis':
          pilihanUmum[((jawaban[0] ?? 1).clamp(1, 3)) - 1],

      // 2 - cemas
      'merasa_cemas': pilihanUmum[((jawaban[1] ?? 1).clamp(1, 3)) - 1],

      // 3 - kesulitan tidur
      'kesulitan_tidur_di_malam_hari':
          pilihanTidurKonsentrasi[((jawaban[2] ?? 1).clamp(1, 3)) - 1],

      // 4 - lelah (pakai pilihanTidurKonsentrasi karena pilihan = Often)
      'kesulitan_konsentrasi_atau_mengambil_keputusan':
          pilihanTidurKonsentrasi[((jawaban[3] ?? 1).clamp(1, 3)) - 1],

      // 5 - ikatan dengan bayi
      'kesulitan_membangun_ikatan_dengan_bayi':
          pilihanUmum[((jawaban[4] ?? 1).clamp(1, 3)) - 1],

      // 6 - dukungan orang sekitar
      'mudah_marah_terhadap_bayi_dan_pasangan':
          pilihanUmum[((jawaban[5] ?? 1).clamp(1, 3)) - 1],

      // 7 - nafsu makan
      'makan_berlebihan_atau_kehilangan_nafsu_makan':
          pilihanUmum[((jawaban[6] ?? 1).clamp(1, 3)) - 1],

      // 8 - tidak mampu jadi ibu (pilihan = Maybe)
      'perasaan_bersalah': pilihanBersalah[((jawaban[7] ?? 1).clamp(1, 3)) - 1],

      // 9 - menyakiti diri sendiri
      'percobaan_bunuh_diri':
          pilihanBunuhDiri[((jawaban[8] ?? 1).clamp(1, 2)) - 1],
    };

    print('PAYLOAD FINAL:');
    print(payload);

    // ----------------------------------------------------
    // REQUEST
    final response = await http
        .post(
          Uri.parse('${Api.baseUrl}/mother/screening'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        )
        .timeout(
          const Duration(seconds: 45),
          onTimeout: () => throw Exception('Request timeout ke Laravel'),
        );

    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');

    final decoded = jsonDecode(response.body);
    final body = _asMap(decoded);

    if (body == null) {
      throw Exception('Response Laravel bukan object JSON');
    }

    if (response.statusCode != 200) {
      final message = body['message'] ?? body['error'] ?? response.body;

      throw Exception(
        'Gagal kirim ke Laravel: '
        '${response.statusCode} $message',
      );
    }

    return _normalizeScreeningResponse(body);
  }
}
