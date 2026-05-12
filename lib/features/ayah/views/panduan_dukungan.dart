import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/artikel_card.dart';
import '../widgets/artikel_horizontal.dart';

class PanduanDukunganPage extends StatelessWidget {
  final VoidCallback? onBack;

  const PanduanDukunganPage({super.key, this.onBack});

  static const List<Map<String, dynamic>> _edukasiList = [
    {
      'kategori': 'Psikologi',
      'judul': 'Memahami Hormon Pascapersalinan',
      'subjudul': 'Estimasi 5 menit baca',
      'warnaKategori': Color(0xFFA3B18A),
      'gambar': null,
    },
    {
      'kategori': 'Peran Ayah',
      'judul': 'Pentingnya Kehadiran Ayah',
      'subjudul': 'Kurikulum Singkat',
      'warnaKategori': Color(0xFFDDBEA9),
      'gambar': null,
    },
    {
      'kategori': 'Komunikasi',
      'judul': 'Cara Bicara dengan Pasangan yang Lelah',
      'subjudul': 'Estimasi 7 menit baca',
      'warnaKategori': Color(0xFFA3B18A),
      'gambar': null,
    },
  ];

  static const List<Map<String, dynamic>> _artikelList = [
    {
      'kategori': 'Self-Care',
      'title': '5 Menit Meditasi untuk Ibu yang Sibuk',
      'durasi': '5 menit baca',
      'icon': Icons.self_improvement,
    },
    {
      'kategori': 'Nutrisi',
      'title': 'Menu Bergizi untuk Pemulihan Pasca Melahirkan',
      'durasi': '8 menit baca',
      'icon': Icons.restaurant_menu,
    },
    {
      'kategori': 'Mental Health',
      'title': 'Menghadapi Baby Blues dengan Tenang',
      'durasi': '12 menit baca',
      'icon': Icons.favorite_border,
    },
    {
      'kategori': 'Mental Health',
      'title': 'Menghadapi Baby Blues dengan Tenang',
      'durasi': '12 menit baca',
      'icon': Icons.favorite_border,
    },
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
                title: 'Panduan & Dukungan',
                leftIcon: Icons.chevron_left,
                rightIcon: Icons.calendar_today_outlined,
                onLeftTap: () => onBack?.call(),
                onRightTap: () {},
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Edukasi untuk Suami
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'Edukasi untuk Suami',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: WarnaUtama.text1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Horizontal scroll edukasi
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        clipBehavior: Clip.none,
                        itemCount: _edukasiList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final item = _edukasiList[index];
                          return ArtikelHorizontal(
                            kategori: item['kategori'] as String,
                            judul: item['judul'] as String,
                            subjudul: item['subjudul'] as String,
                            warnaKategori: item['warnaKategori'] as Color,
                            onTap: () {},
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Terbaru untuk Ayah
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Terbaru untuk Ayah',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: WarnaUtama.text1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: WarnaUtama.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // List artikel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _artikelList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final artikel = _artikelList[index];
                          return ArtikelCard(
                            kategori: artikel['kategori'] as String,
                            title: artikel['title'] as String,
                            durasi: artikel['durasi'] as String,
                            icon: artikel['icon'] as IconData,
                            onTap: () {},
                          );
                        },
                      ),
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