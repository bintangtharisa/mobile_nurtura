import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header_profil.dart';
import '../widgets/status_card.dart';
import '../../shared/widgets/artikel_card.dart';
import '../../../services/father_service.dart';
import '../../shared/widgets/chatbot_card.dart';
import '../../shared/views/lihat_artikel_page.dart';
import 'notifikasi_ayah_page.dart';
import '../../shared/views/chatbot_page.dart';
import '../../shared/views/artikel_detail_page.dart';

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
                HeaderProfil(
                  onNotifikasiTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const NotifikasiAyahPage()),
                    ),
                ),
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

                const SizedBox(height: 16),

                ChatbotCard(
                  namaBot: 'Nurtura AI',
                  pesanAwal: 'Halo Ayah! 👋 Ada yang bisa aku bantu hari ini?',
                  onOpenChat: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChatbotPage(
                        pesanAwal: 'Halo Ayah! 👋 Ada yang bisa aku bantu hari ini?',
                        quickReplies: ['Saya merasa lelah', 'Tips menyusui', 'Jadwal imunisasi'],
                      ),
                    ),
                  ),
                  onKirimPesan: (teks) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatbotPage(
                        pesanAwal: 'Halo Ayah! 👋 Ada yang bisa aku bantu hari ini?',
                        quickReplies: ['Tips menangani mood swings', 'Cara mengatasi stres', 'Rekomendasi aktivitas bersama anak'],
                        pesanPertama: teks,
                      ),
                    ),
                  ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LihatTipsPage(),
                            ),
                          );
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
                    const Center(
                      child: Text(
                        'Belum ada artikel tersedia',
                        style: TextStyle(
                          color: WarnaUtama.text1,
                          fontSize: 14,
                        ),
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
                        final articleId =
                            (artikel['_id'] ?? artikel['id'] ?? '').toString();
                        final description =
                            (artikel['description'] ?? artikel['content'] ?? '')
                                .toString();
                        return ArtikelCard(
                          kategori: category,
                          title: artikel['title'] ?? 'Tanpa Judul',
                          durasi:
                              '${(description.split(RegExp(r'\s+')).length / 200).ceil()} menit baca',
                          icon: _getIconForCategory(category),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArtikelDetailPage(
                                artikelId: articleId,
                                judul: artikel['title'] ?? 'Tanpa Judul',
                                kategori: category,
                                durasi:
                                    '${(description.split(RegExp(r'\s+')).length / 200).ceil()} menit baca',
                                initialContent: description,
                                initialThumbnail:
                                    (artikel['thumbnail'] ?? artikel['image'])
                                        ?.toString(),
                              ),
                            ),
                          ),
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
