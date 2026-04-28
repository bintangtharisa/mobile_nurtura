import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../ibu/widgets/header.dart';
import '../../ibu/widgets/filter_tips.dart';
import '../../ibu/widgets/tips_populer.dart';
import '../../ibu/widgets/artikel_card.dart';
import '../views/beranda.dart';

class LihatTipsPage extends StatelessWidget {
  const LihatTipsPage({super.key});

  static const List<Map<String, dynamic>> _kategori = [
    {'label': 'Semua', 'icon': null},
    {'label': 'Self-care', 'icon': Icons.spa_outlined},
    {'label': 'Mental Health', 'icon': Icons.psychology_outlined},
    {'label': 'Nutrisi', 'icon': Icons.restaurant_outlined},
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
      backgroundColor: WarnaUtama.background, // sesuaikan dengan warna background app kamu
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Lihat Tips',
                leftIcon: Icons.chevron_left,
                rightIcon: Icons.notifications_none,
                onLeftTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BerandaPage()),
                ),
                onRightTap: () {
                  // handle notifikasi
                },
              ),
            ),

            // Filter Kategori
            FilterKategori(
              kategori: _kategori,
              onSelected: (index) {
                // handle filter berdasarkan index kategori
              },
            ),

            const SizedBox(height: 20),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Populer
                    TipsPopuler(
                      title: 'Membangun Bonding dengan Si Kecil',
                      subtitle: 'Rahasia kedekatan emosional ibu dan bayi.',
                      image: const NetworkImage('https://picsum.photos/400/200'),
                    ),

                    const SizedBox(height: 24),

                    // Section Header "Terbaru untuk Ibu"
                        const Text(
                          'Terbaru untuk Ibu',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: WarnaUtama.text1,
                          ),
                        ),

                    const SizedBox(height: 12),

                    // List Artikel
                    ListView.separated(
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
                          onTap: () {
                            // handle navigasi ke detail artikel
                          },
                        );
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