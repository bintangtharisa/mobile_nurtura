import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../widgets/status_skrining.dart';
import '../widgets/rekomendasi_list.dart';

class HasilSkriningPage extends StatelessWidget {
  final String result;
  final List<int?> jawaban;
  final List<String> rekomendasi;

  const HasilSkriningPage({
    super.key,
    required this.result,
    required this.jawaban,
    this.rekomendasi = const [],
  });

  bool get berisiko {
    final normalized = result.toLowerCase();
    return !normalized.contains('tidak') &&
        (normalized.contains('beresiko') || normalized.contains('berisiko'));
  }

  List<String> get _rekomendasiTampil {
    if (rekomendasi.isNotEmpty) return rekomendasi;

    return [
      'Rekomendasi AI belum tersedia untuk hasil ini. Silakan coba ulangi skrining atau periksa koneksi ML API.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Hasil Skrining',
                leftIcon: Icons.chevron_left,
                onLeftTap: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ),

            // Konten
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Status visual
                    StatusSkrining(
                      berisiko: berisiko,
                      statusLabel: berisiko
                          ? 'Berisiko Depresi'
                          : 'Tidak Berisiko Depresi',
                      deskripsi: berisiko
                          ? 'Ada beberapa tanda yang perlu dipentingkan. Hasil ini bukan diagnosis medis, tetapi indikasi awal yang perlu ditindaklanjuti.'
                          : 'Kondisi anda saat ini stabil, tetap jaga kesehatan mental anda yaaa! 🤩',
                    ),

                    const SizedBox(height: 32),

                    // Rekomendasi + tombol
                    RekomendasiList(
                      rekomendasi: _rekomendasiTampil,
                      onKembali: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
