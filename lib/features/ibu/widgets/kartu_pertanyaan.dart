import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class KartuPertanyaan extends StatelessWidget {
  final int nomorSoal;
  final int totalSoal;
  final String kategori;
  final String pertanyaan;
  final String subjudul;

  const KartuPertanyaan({
    super.key,
    required this.nomorSoal,
    required this.totalSoal,
    required this.kategori,
    required this.pertanyaan,
    required this.subjudul,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = nomorSoal / totalSoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pertanyaan ke $nomorSoal/$totalSoal',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: WarnaUtama.text1.withOpacity(0.6),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Selesai',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: WarnaUtama.secondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: WarnaUtama.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(WarnaUtama.secondary),
            minHeight: 6,
          ),
        ),

        const SizedBox(height: 20),

        // Kartu pertanyaan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WarnaUtama.form,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge kategori
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: WarnaUtama.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  kategori.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: WarnaUtama.secondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Teks pertanyaan
              Text(
                pertanyaan,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: WarnaUtama.text1,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 8),

              // Subjudul
              Text(
                subjudul,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: WarnaUtama.text1.withOpacity(0.5),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}