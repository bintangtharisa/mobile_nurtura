import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class RekomendasiList extends StatelessWidget {
  final List<String> rekomendasi;
  final VoidCallback? onKembali;

  const RekomendasiList({
    super.key,
    required this.rekomendasi,
    this.onKembali,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.eco_outlined,
              size: 20,
              color: WarnaUtama.secondary,
            ),
            const SizedBox(width: 8),
            const Text(
              'Rekomendasi',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WarnaUtama.text1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rekomendasi.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: WarnaUtama.text2,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: WarnaUtama.secondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rekomendasi[index],
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: WarnaUtama.text1,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        GestureDetector(
          onTap: onKembali,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: WarnaUtama.secondary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Kembali ke Beranda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WarnaUtama.text2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}