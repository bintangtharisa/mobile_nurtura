import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header_profil.dart';
import '../widgets/dukungan_card.dart';
import '../widgets/status_card.dart';
import '../widgets/artikel_card.dart';

class BerandaAyahPage extends StatelessWidget {
  const BerandaAyahPage({super.key});

  static const List<Map<String, dynamic>> _artikelList = [
    {
      'kategori': 'Panduan',
      'title': '5 Menit Menjadi Suami Siaga',
      'durasi': '4 mnt baca',
      'icon': Icons.people_outline,
    },
    {
      'kategori': 'Nutrisi',
      'title': 'Nutrisi Penting untuk Ibu Menyusui',
      'durasi': '6 mnt baca',
      'icon': Icons.restaurant_outlined,
    },
    {
      'kategori': 'Psikologi',
      'title': 'Mengenali Gejala Baby Blues',
      'durasi': '8 mnt baca',
      'icon': Icons.psychology_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderProfil(),

                const SizedBox(height: 20),

                DukunganCard(
                  title: 'Dukunganmu Berarti',
                  deskripsi:
                      'Kehadiran Ayah membuat Ibu merasa lebih tenang dan bahagia.',
                  image: const NetworkImage('https://picsum.photos/id/64/200/200'),
                ),

                const SizedBox(height: 16),

                StatusSkriningCard(
                  statusLabel: 'Berisiko Depresi',
                  deskripsi:
                      'Kondisi istri saat ini terpantau stabil. Tetap berikan dukungan yaaa!',
                  berisiko: true,
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Artikel Terbaru',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: navigasi ke lihat semua artikel
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: WarnaUtama.secondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

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
                      onTap: () {},
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}