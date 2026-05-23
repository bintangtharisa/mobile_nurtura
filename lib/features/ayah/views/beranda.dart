import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header_profil.dart';
import '../widgets/dukungan_card.dart';
import '../widgets/status_card.dart';
import '../../shared/widgets/artikel_card.dart';
import '../../../services/father_service.dart';

class BerandaAyahPage extends StatefulWidget {
  const BerandaAyahPage({super.key});

  @override
  State<BerandaAyahPage> createState() => _BerandaAyahPageState();
}

class _BerandaAyahPageState extends State<BerandaAyahPage> {
  Map<String, dynamic>? dashboardData;
  List<dynamic> articles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final dashboardResult = await FatherService.getDashboard();
      final articlesResult = await FatherService.getArticles();

      if (dashboardResult['success'] == true) {
        setState(() {
          dashboardData = dashboardResult['data'];
        });
      }

      if (articlesResult['success'] == true) {
        setState(() {
          articles = articlesResult['data'] is List
              ? articlesResult['data']
              : (articlesResult['data']['data'] ?? []);
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'panduan':
        return Icons.people_outline;
      case 'nutrisi':
        return Icons.restaurant_outlined;
      case 'psikologi':
        return Icons.psychology_outlined;
      case 'kesehatan':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.article_outlined;
    }
  }

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

                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                else ...[
                  DukunganCard(
                    title: 'Dukunganmu Berarti',
                    deskripsi: dashboardData != null &&
                            dashboardData!['is_connected'] == true
                        ? 'Kehadiran Ayah membuat Ibu merasa lebih tenang dan bahagia.'
                        : 'Hubungkan akun dengan pasangan untuk mulai memberikan dukungan.',
                    image: const NetworkImage('https://picsum.photos/id/64/200/200'),
                  ),

                  const SizedBox(height: 16),

                  StatusSkriningCard(
                    statusLabel: dashboardData?['statusRisiko'] ?? 'Belum Ada Data',
                    deskripsi: dashboardData != null &&
                            dashboardData!['is_connected'] == true
                        ? (dashboardData!['statusRisiko'] == 'Beresiko Depresi'
                            ? 'Kondisi istri memerlukan perhatian lebih. Tetap berikan dukungan!'
                            : 'Kondisi istri saat ini terpantau stabil. Tetap berikan dukungan yaaa!')
                        : 'Hubungkan akun dengan pasangan untuk melihat status screening.',
                    berisiko: dashboardData?['statusRisiko'] == 'Beresiko Depresi',
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

                  if (articles.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Belum ada artikel tersedia'),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length > 3 ? 3 : articles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final artikel = articles[index];
                        final category = artikel['category']?['name'] ?? 'Umum';
                        return ArtikelCard(
                          kategori: category,
                          title: artikel['title'] ?? 'Tanpa Judul',
                          durasi: '${artikel['description']?.length ?? 0} karakter',
                          icon: _getIconForCategory(category),
                          onTap: () {},
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}