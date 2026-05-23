import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class ArtikelHorizontal extends StatelessWidget {
  final String kategori;
  final String judul;
  final String subjudul;
  final Color warnaKategori;
  final ImageProvider? gambar;
  final VoidCallback? onTap;

  const ArtikelHorizontal({
    super.key,
    required this.kategori,
    required this.judul,
    required this.subjudul,
    this.warnaKategori = const Color(0xFFA3B18A),
    this.gambar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar + badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: gambar != null
                      ? Image(
                          image: gambar!,
                          width: 180,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 180,
                          height: 160,
                          decoration: BoxDecoration(
                            color: WarnaUtama.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: WarnaUtama.secondary,
                          ),
                        ),
                ),
                // Badge kategori
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: warnaKategori.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kategori,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Judul
            Text(
              judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: WarnaUtama.text1,
              ),
            ),

            const SizedBox(height: 4),

            // Subjudul
            Text(
              subjudul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: WarnaUtama.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}