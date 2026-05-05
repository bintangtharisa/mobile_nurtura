import 'package:flutter/material.dart';
import '../../ibu/widgets/aksi_card.dart';
import '../../ibu/widgets/tips_card.dart';
import '../../ibu/widgets/status_card.dart';
import '../../ibu/widgets/header_profil.dart';
import '../../../core/theme/warna_utama.dart';
import '../views/lihat_tips_page.dart';
import '../views/tahap_skrining.dart';
import '../../services/prediksi_service.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Map<String, dynamic>? _statusTerakhir;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final data = await PrediksiService.getHasilTerakhir();
      setState(() => _statusTerakhir = data);
    } catch (e) {
      // gagal load
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
                        Text(
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.none,
                  children: const [
                    SizedBox(
                      width: 155,
                      child: TipsCard(
                        title: "Latihan Meditasi untuk Ibu Baru",
                        duration: "5 min read",
                        icon: Icons.self_improvement,
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 155,
                      child: TipsCard(
                        title: "Tips untuk Kualitas Tidur Lebih Baik",
                        duration: "3 min read",
                        icon: Icons.nightlight_round,
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 155,
                      child: TipsCard(
                        title: "Mengelola Stres Pasca Melahirkan",
                        duration: "4 min read",
                        icon: Icons.spa_outlined,
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 155,
                      child: TipsCard(
                        title: "Nutrisi Penting untuk Ibu Menyusui",
                        duration: "6 min read",
                        icon: Icons.restaurant_outlined,
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 155,
                      child: TipsCard(
                        title: "Olahraga Ringan Setelah Melahirkan",
                        duration: "4 min read",
                        icon: Icons.directions_walk_outlined,
                      ),
                    ),
                  ],
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
                      onTap: () {
                        // TODO: navigasi ke koneksi
                      },
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