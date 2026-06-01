import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/session.dart';
import '../services/auth_service.dart';
import '../utils/api.dart';

class LaravelService {
  static Future<Map<String, dynamic>> saveScreening({
    required List<int?> jawaban,
  }) async {
    // ---------- Auth ----------
    final token = await Session.getToken();

    // ---------- Get user ----------
    final userRes = await AuthService.getUser();

    print('USER RESPONSE:');
    print(userRes);

    if (userRes['success'] != true) {
      throw Exception('Gagal mengambil data user');
    }

    final motherId = userRes['data']['id'] ?? userRes['data']['data']?['id'];

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

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = body is Map<String, dynamic>
          ? body['message'] ?? body['error'] ?? response.body
          : response.body;

      throw Exception(
        'Gagal kirim ke Laravel: '
        '${response.statusCode} $message',
      );
    }

    final data = Map<String, dynamic>.from(body as Map);
    final prediction = data['prediction'];

    if (prediction is Map<String, dynamic>) {
      data['result'] = data['result'] ?? prediction['result'];
      data['recommendation'] = data['recommendation'] ?? prediction['recommendation'];
    }

    return data;
  }
}
