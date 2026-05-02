import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/status_skrining.dart';
import '../widgets/rekomendasi_list.dart';

class HasilSkriningPage extends StatelessWidget {
  final bool berisiko;
  final List<int?> jawaban;

  const HasilSkriningPage({
    super.key,
    required this.berisiko,
    required this.jawaban,
  });

  static const List<String> _rekomendasiBerisiko = [
    'Utamakan istirahat setiap kali bayi Anda tidur.',
    'Bicaralah secara terbuka kepada pasangan Anda tentang perasaan Anda.',
    'Tetap terhidrasi dan jaga keseimbangan nutrisi.',
  ];

  static const List<String> _rekomendasiAman = [
    'Utamakan istirahat setiap kali bayi Anda tidur.',
    'Bicaralah secara terbuka kepada pasangan Anda tentang perasaan Anda.',
    'Tetap terhidrasi dan jaga keseimbangan nutrisi.',
  ];

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
                onLeftTap: () => Navigator.popUntil(context, (route) => route.isFirst),
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
                      statusLabel: berisiko ? 'Berisiko Depresi' : 'Tidak Berisiko Depresi',
                      deskripsi: berisiko
                          ? 'Ada beberapa tanda yang perlu dipentingkan. Hasil ini bukan diagnosis medis, tetapi indikasi awal yang perlu ditindaklanjuti.'
                          : 'Kondisi anda saat ini stabil, tetap jaga kesehatan mental anda yaaa! 🤩',
                    ),

                    const SizedBox(height: 32),

                    // Rekomendasi + tombol
                    RekomendasiList(
                      rekomendasi: berisiko ? _rekomendasiBerisiko : _rekomendasiAman,
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