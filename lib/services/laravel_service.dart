import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/session.dart';
import '../services/auth_service.dart';

class LaravelService {
  static const String _baseUrl = 'http://192.168.0.108:8000/api';

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

    final motherId =
        userRes['data']['id'] ??
        userRes['data']['data']?['id'];

    if (motherId == null) {
      throw Exception('mother_id tidak ditemukan');
    }

    print('MOTHER ID FIXED: $motherId');
    print('RAW JAWABAN: $jawaban');

    // ----------------------------------------------------
    // PILIHAN
    const pilihanUmum = [
      'Not at all',
      'Sometimes',
      'Yes'
    ];

    const pilihanTidurKonsentrasi = [
      'Not at all',
      'Often',
      'Yes'
    ];

    const pilihanBersalah = [
      'Not at all',
      'Maybe',
      'Yes'
    ];

    const pilihanBunuhDiri = [
      'No',
      'Yes'
    ];

 
    final payload = {
      'mother_id': motherId,

      'perasaan_sedih_atau_mudah_menangis':
          pilihanUmum[((jawaban[0] ?? 1).clamp(1, 3)) - 1],

      'mudah_marah_terhadap_bayi_dan_pasangan':
          pilihanUmum[((jawaban[1] ?? 1).clamp(1, 3)) - 1],

      'kesulitan_tidur_di_malam_hari':
          pilihanTidurKonsentrasi[
              ((jawaban[2] ?? 1).clamp(1, 3)) - 1
          ],

      'kesulitan_konsentrasi_atau_mengambil_keputusan':
          pilihanTidurKonsentrasi[
              ((jawaban[3] ?? 1).clamp(1, 3)) - 1
          ],

      'makan_berlebihan_atau_kehilangan_nafsu_makan':
          pilihanUmum[
              ((jawaban[4] ?? 1).clamp(1, 3)) - 1
          ],

      'perasaan_bersalah':
          pilihanBersalah[
              ((jawaban[5] ?? 1).clamp(1, 3)) - 1
          ],

      'kesulitan_membangun_ikatan_dengan_bayi':
          pilihanUmum[
              ((jawaban[6] ?? 1).clamp(1, 3)) - 1
          ],

      'merasa_cemas':
          pilihanUmum[
              ((jawaban[7] ?? 1).clamp(1, 3)) - 1
          ],

      // SOAL KE-10 = INDEX 9
      'percobaan_bunuh_diri':
          pilihanBunuhDiri[
              ((jawaban[9] ?? 1).clamp(1, 2)) - 1
          ],
    };

    print('PAYLOAD FINAL:');
    print(payload);

    // ----------------------------------------------------
    // REQUEST
    final response = await http.post(
      Uri.parse('$_baseUrl/mother/screening'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal kirim ke Laravel: '
        '${response.statusCode} ${response.body}',
      );
    }

    return jsonDecode(response.body);
  }
}