import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../widgets/status_skrining.dart';
import '../widgets/rekomendasi_list.dart';

class HasilSkriningPage extends StatelessWidget {
  final String result;
  final int? cluster; // 🔥 PENTING: dari backend ML
  final List<int?> jawaban;
  final List<String> rekomendasi;

  const HasilSkriningPage({
    super.key,
    required this.result,
    required this.cluster,
    required this.jawaban,
    this.rekomendasi = const [],
  });

  // 🔥 FIX UTAMA: tidak pakai string sama sekali
  bool get berisiko => cluster == 0;

  List<String> get _rekomendasiTampil {
    if (rekomendasi.isNotEmpty) return rekomendasi;

    return [
      'Rekomendasi AI belum tersedia untuk hasil ini. Silakan ulangi skrining atau cek koneksi server.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Hasil Skrining',
                leftIcon: Icons.chevron_left,
                onLeftTap: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ),

            // BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // STATUS
                    StatusSkrining(
                      berisiko: berisiko,
                      statusLabel: berisiko
                          ? 'Berisiko Depresi'
                          : 'Tidak Berisiko Depresi',
                      deskripsi: berisiko
                          ? 'Ada beberapa tanda yang perlu diperhatikan. Ini bukan diagnosis medis, hanya skrining awal.'
                          : 'Kondisi Anda saat ini stabil. Tetap jaga kesehatan mental Anda.',
                    ),

                    const SizedBox(height: 32),

                    // REKOMENDASI
                    RekomendasiList(
                      rekomendasi: _rekomendasiTampil,
                      onKembali: () {
                        Navigator.popUntil(
                            context, (route) => route.isFirst);
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