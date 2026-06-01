import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../widgets/kartu_pertanyaan.dart';
import '../widgets/pilihan_jawaban.dart';
import '../widgets/tombol_navigasi_skrining.dart';
import 'hasil_skrining.dart';
import '../../../services/laravel_service.dart';

class TahapSkriningPage extends StatefulWidget {
  const TahapSkriningPage({super.key});

  @override
  State<TahapSkriningPage> createState() => _TahapSkriningPageState();
}

class _TahapSkriningPageState extends State<TahapSkriningPage> {
  int _currentIndex = 0;
  bool _isLoading = false;

  static const List<Map<String, dynamic>> _pertanyaanList = [
    {
      'kategori': 'Kesejahteraan Emosional',
      'pertanyaan': 'Dalam 7 hari terakhir, saya sering merasakan sedih dan sering menangis',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda akhir-akhir ini.',
      'pilihan': ['Not at all', 'Sometimes', 'Yes'],
    },
    {
      'kategori': 'Kesejahteraan Emosional',
      'pertanyaan': 'Saya merasa cemas atau khawatir tanpa alasan yang jelas',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda akhir-akhir ini.',
      'pilihan': ['Not at all', 'Sometimes', 'Yes'],
    },
    {
      'kategori': 'Pola Tidur',
      'pertanyaan': 'Saya mengalami kesulitan tidur meskipun bayi sedang tidur',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Not at all', 'Often', 'Yes'],
    },
    {
      'kategori': 'Pola Tidur',
      'pertanyaan': 'Saya merasa sangat lelah meskipun sudah beristirahat',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Not at all', 'Often', 'Yes'],
    },
    {
      'kategori': 'Hubungan Sosial',
      'pertanyaan': 'Saya merasa sulit untuk terhubung dengan bayi saya',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda.',
      'pilihan': ['Not at all', 'Sometimes', 'Yes'],
    },
    {
      'kategori': 'Hubungan Sosial',
      'pertanyaan': 'Saya merasa tidak mendapat dukungan dari orang sekitar',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda.',
      'pilihan': ['Not at all', 'Sometimes', 'Yes'],
    },
    {
      'kategori': 'Kesehatan Fisik',
      'pertanyaan': 'Saya kehilangan nafsu makan atau makan berlebihan',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Not at all', 'Sometimes', 'Yes'],
    },
    {
      'kategori': 'Kesejahteraan Emosional',
      'pertanyaan': 'Saya merasa tidak mampu menjadi ibu yang baik',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda.',
      'pilihan': ['Not at all', 'Maybe', 'Yes'],
    },
    {
      'kategori': 'Kesejahteraan Emosional',
      'pertanyaan': 'Saya pernah berpikir menyakiti diri sendiri',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['No', 'Yes'],
    },
  ];

  late final List<int?> _jawaban =
      List.filled(_pertanyaanList.length, null);

  void _sebelumnya() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  Future<void> _selanjutnya() async {
    if (_jawaban[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih jawaban terlebih dahulu'),
          backgroundColor: WarnaUtama.secondary,
        ),
      );
      return;
    }

    if (_currentIndex < _pertanyaanList.length - 1) {
      setState(() {
        _currentIndex++;
      });
      return;
    }

    try {
      setState(() => _isLoading = true);

      final hasil =
          await LaravelService.saveScreening(jawaban: _jawaban);

      if (!mounted) return;

      final result = (hasil['result'] as String?) ?? '';
      final prediction =
          hasil['prediction'] as Map<String, dynamic>?;

      final cluster = prediction?['cluster'];

      debugPrint('🔍 RESULT: $result');
      debugPrint('🔍 CLUSTER: $cluster');

      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data hasil prediksi tidak ditemukan'),
          ),
        );
        return;
      }

      final recommendation =
          prediction?['recommendation'] as Map<String, dynamic>?;

      final List<String> rekomendasi = [];

      if (recommendation != null) {
        final emergencyNote =
            recommendation['emergency_note'] as String?;
        if (emergencyNote != null && emergencyNote.isNotEmpty) {
          rekomendasi.add('⚠️ $emergencyNote');
        }

        final summary = recommendation['summary'] as String?;
        if (summary != null && summary.isNotEmpty) {
          rekomendasi.add(summary);
        }

        final actionSteps =
            recommendation['action_steps'] as List<dynamic>?;
        if (actionSteps != null) {
          rekomendasi
              .addAll(actionSteps.map((e) => e.toString()));
        }

        final partnerSupport =
            recommendation['partner_support'] as List<dynamic>?;
        if (partnerSupport != null) {
          rekomendasi
              .addAll(partnerSupport.map((e) => e.toString()));
        }

        final professionalHelp =
            recommendation['professional_help'] as String?;
        if (professionalHelp != null &&
            professionalHelp.isNotEmpty) {
          rekomendasi.add(professionalHelp);
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HasilSkriningPage(
            result: result,
            cluster: cluster,
            jawaban: _jawaban,
            rekomendasi: rekomendasi,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showKonfirmasiKeluar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Kembali ke Prediksi?'),
        content: const Text(
          'Semua jawaban akan dihapus. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soal = _pertanyaanList[_currentIndex];

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CardHeader(
                title: 'Tahap Skrining',
                leftIcon: Icons.chevron_left,
                onLeftTap: _showKonfirmasiKeluar,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    KartuPertanyaan(
                      nomorSoal: _currentIndex + 1,
                      totalSoal: _pertanyaanList.length,
                      kategori: soal['kategori'],
                      pertanyaan: soal['pertanyaan'],
                      subjudul: soal['subjudul'],
                    ),
                    const SizedBox(height: 20),
                    PilihanJawaban(
                      pilihan: soal['pilihan'],
                      selectedIndex:
                          _jawaban[_currentIndex] != null
                              ? _jawaban[_currentIndex]! - 1
                              : null,
                      onSelected: (index) {
                        setState(() {
                          _jawaban[_currentIndex] =
                              index + 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TombolNavigasiSkrining(
                isFirst: _currentIndex == 0,
                isLast: _currentIndex ==
                    _pertanyaanList.length - 1,
                onSebelumnya: _sebelumnya,
                onSelanjutnya:
                    _isLoading ? null : _selanjutnya,
              ),
            ),
          ],
        ),
      ),
    );
  }
}