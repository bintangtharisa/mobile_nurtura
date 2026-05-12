import 'package:flutter/material.dart';
import '../../ibu/widgets/aksi_card.dart';
import '../../ibu/widgets/tips_card.dart';
import '../../ibu/widgets/status_card.dart';
import '../../ibu/widgets/header_profil.dart';
import '../../../core/theme/warna_utama.dart';
import '../views/lihat_tips_page.dart';
import '../views/tahap_skrining.dart';


class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Map<String, dynamic>? _statusTerakhir;
  List<Map<String, dynamic>> _tipsList = [];


  IconData _getIcon(String kategori) {
  switch (kategori.toLowerCase()) {
    case 'mental_health':
      return Icons.psychology_outlined;
    case 'nutrisi':
      return Icons.restaurant_outlined;
    case 'self-care':
      return Icons.spa_outlined;
    default:
      return Icons.tips_and_updates_outlined;
  }
}

String _formatKategori(String kategori) {
  switch (kategori.toLowerCase()) {
    case 'mental_health':
      return 'Mental Health';
    case 'nutrisi':
      return 'Nutrisi';
    case 'self-care':
      return 'Self Care';
    default:
      return kategori;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderProfil(),
                    const SizedBox(height: 20),
                    _statusTerakhir == null
                        ? const StatusCard(
                            status: 'Belum ada data',
                            tanggal: '-',
                            berisiko: false,
                          )
                        : StatusCard(
                            status: _statusTerakhir!['status'],
                            tanggal: _statusTerakhir!['tanggal'],
                            berisiko: _statusTerakhir!['berisiko'],
                          ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tips Harian",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: WarnaUtama.text1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LihatTipsPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: WarnaUtama.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 155,
                child: _tipsList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        clipBehavior: Clip.none,
                        itemCount: _tipsList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final tips = _tipsList[index];
                          return SizedBox(
                            width: 155,
                            child: TipsCard(
                              title: tips['judul'] ?? '',
                              duration: _formatKategori(tips['kategori'] ?? ''),
                              icon: _getIcon(tips['kategori'] ?? ''),
                            ),
                          );
                        },
                      ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    const Text(
                      "Aksi Cepat",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TahapSkriningPage(),
                                ),
                              );
                            },
                            child: AksiCard(
                              title: "Mulai Skrining",
                              icon: Icons.assignment_outlined,
                              color: WarnaUtama.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LihatTipsPage(),
                                ),
                              );
                            },
                            child: AksiCard(
                              title: "Lihat Tips",
                              icon: Icons.menu_book_outlined,
                              color: WarnaUtama.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: AksiCard(
                        title: "Koneksi",
                        icon: Icons.hub_outlined,
                        color: WarnaUtama.secondary,
                        fullWidth: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}