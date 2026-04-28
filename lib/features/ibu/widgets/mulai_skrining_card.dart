import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class MulaiSkriningCard extends StatelessWidget {
  final VoidCallback? onMulai;

  const MulaiSkriningCard({
    super.key,
    this.onMulai,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WarnaUtama.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Lingkaran dekoratif besar
          Positioned(
            right: -10,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WarnaUtama.text2.withOpacity(0.08),
              ),
            ),
          ),
          // Lingkaran dekoratif kecil
          Positioned(
            right: 50,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WarnaUtama.text2.withOpacity(0.06),
              ),
            ),
          ),

          // Konten
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mulai Skrining',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: WarnaUtama.text2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hanya butuh 5-10 menit untuk mengetahui kondisi emosional Bunda saat ini.',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: WarnaUtama.text2.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onMulai,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: WarnaUtama.text2,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 18,
                        color: WarnaUtama.text1,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mulai Sekarang',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: WarnaUtama.text1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}