import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class ArtikelCard extends StatelessWidget {
  final String kategori;
  final String title;
  final String durasi;
  final IconData icon;
  final VoidCallback? onTap;

  const ArtikelCard({
    super.key,
    required this.kategori,
    required this.title,
    required this.durasi,
    required this.icon,
    this.onTap,
  });

  Color _warnaKategori() {
    switch (kategori.toUpperCase()) {
      case 'PANDUAN':
        return WarnaUtama.secondary;
      case 'NUTRISI':
        return Colors.orange;
      case 'PSIKOLOGI':
        return Colors.teal;
      default:
        return WarnaUtama.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: WarnaUtama.text2,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // thumbnail
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: WarnaUtama.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: WarnaUtama.secondary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: _warnaKategori(),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: WarnaUtama.text1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: WarnaUtama.text1.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        durasi,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.normal,
                          color: WarnaUtama.text1.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}