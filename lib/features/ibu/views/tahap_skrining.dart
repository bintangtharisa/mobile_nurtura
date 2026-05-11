import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/kartu_pertanyaan.dart';
import '../widgets/pilihan_jawaban.dart';
import '../widgets/tombol_navigasi_skrining.dart';
import 'hasil_skrining.dart';
import '../../../services/ml_service.dart';

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
      'pertanyaan':
          'Dalam 7 hari terakhir, saya sering merasakan sedih dan sering menangis',
      'subjudul':
          'Pilih jawaban yang paling sesuai dengan perasaan Anda akhir-akhir ini.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Kesejahteraan Emosional',
      'pertanyaan': 'Saya merasa cemas atau khawatir tanpa alasan yang jelas',
      'subjudul':
          'Pilih jawaban yang paling sesuai dengan perasaan Anda akhir-akhir ini.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Pola Tidur',
      'pertanyaan': 'Saya mengalami kesulitan tidur meskipun bayi sedang tidur',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Pola Tidur',
      'pertanyaan': 'Saya merasa sangat lelah meskipun sudah beristirahat',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Hubungan Sosial',
      'pertanyaan': 'Saya merasa sulit untuk terhubung dengan bayi saya',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Hubungan Sosial',
      'pertanyaan': 'Saya merasa tidak mendapat dukungan dari orang sekitar',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Kesehatan Fisik',
      'pertanyaan': 'Saya kehilangan nafsu makan atau makan berlebihan',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Kesehatan Fisik',
      'pertanyaan':
          'Saya sering merasakan sakit kepala atau nyeri tubuh tanpa sebab',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan kondisi Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },

    {
      'kategori': 'Kesejahteraan Emosional',
      'pertanyaan': 'Saya merasa tidak mampu menjadi ibu yang baik',
      'subjudul': 'Pilih jawaban yang paling sesuai dengan perasaan Anda.',
      'pilihan': ['Tidak', 'Jarang', 'Iya', 'Sering'],
    },
  ];

  late final List<int?> _jawaban = List.filled(_pertanyaanList.length, null);

  void _showKonfirmasiKeluar() {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: const Text(
          'Kembali ke Prediksi?',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: WarnaUtama.text1,
          ),
        ),

        content: const Text(
          'Semua jawaban yang sudah diisi akan dihapus. Yakin ingin keluar?',
          style: TextStyle(fontFamily: 'Manrope', color: WarnaUtama.text1),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: WarnaUtama.text1.withOpacity(0.5),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              decoration: BoxDecoration(
                color: WarnaUtama.secondary,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: WarnaUtama.text2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
      setState(() {
        _isLoading = true;
      });

      final hasilML = await MLService.predict(_jawaban);

      if (!mounted) return;

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              HasilSkriningPage(berisiko: hasilML.isRisk, jawaban: _jawaban),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim data: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),

              child: CardHeader(
                title: 'Tahap Skrining',

                leftIcon: Icons.chevron_left,

                onLeftTap: _showKonfirmasiKeluar,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  children: [
                    KartuPertanyaan(
                      nomorSoal: _currentIndex + 1,

                      totalSoal: _pertanyaanList.length,

                      kategori: soal['kategori'] as String,

                      pertanyaan: soal['pertanyaan'] as String,

                      subjudul: soal['subjudul'] as String,
                    ),

                    const SizedBox(height: 20),

                    PilihanJawaban(
                      pilihan: soal['pilihan'] as List<String>,

                      selectedIndex: _jawaban[_currentIndex] != null
                          ? _jawaban[_currentIndex]! - 1
                          : null,

                      onSelected: (index) {
                        setState(() {
                          _jawaban[_currentIndex] = index + 1;
                        });
                      },
                    ),

                    const SizedBox(height: 24),
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

              child: TombolNavigasiSkrining(
                isFirst: _currentIndex == 0,

                isLast: _currentIndex == _pertanyaanList.length - 1,

                onSebelumnya: _sebelumnya,

                onSelanjutnya: _isLoading ? null : _selanjutnya,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
