import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';

class ArtikelDetailPage extends StatelessWidget {
  final String artikelId;
  final String judul;
  final String kategori;
  final String durasi;

  const ArtikelDetailPage({
    super.key,
    required this.artikelId,
    required this.judul,
    required this.kategori,
    required this.durasi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: '',
                leftIcon: Icons.chevron_left,
                onLeftTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: WarnaUtama.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: WarnaUtama.secondary.withOpacity(0.5),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Badge kategori
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: WarnaUtama.secondary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        kategori.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: WarnaUtama.secondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Judul
                    Text(
                      judul,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: WarnaUtama.text1,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Durasi baca
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: WarnaUtama.text1.withOpacity(0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          durasi,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            color: WarnaUtama.text1.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Divider(color: WarnaUtama.primary.withOpacity(0.3)),

                    const SizedBox(height: 20),

                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis.',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        color: WarnaUtama.text1,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 32),
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