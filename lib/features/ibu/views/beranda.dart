import 'package:flutter/material.dart';
import '../../ibu/widgets/aksi_card.dart';
import '../../ibu/widgets/tips_card.dart';
import '../../ibu/widgets/status_card.dart';
import '../../ibu/widgets/header_profil.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/views/lihat_tips_page.dart';
import '../views/tahap_skrining.dart';
import '../services/article_service.dart';
import '../../shared/widgets/chatbot_card.dart';
import '../../ibu/views/profil.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Map<String, dynamic>? _statusTerakhir;
  List<Map<String, dynamic>> _tipsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTips();
  }

  Future<void> _fetchTips() async {
    try {
      final articles = await ArticleService.getArticles();
      
      setState(() {
        _tipsList = articles
            .map((article) => {
                  'id': article['_id'] ?? article['id'] ?? '',
                  'judul': article['title'] ?? '',
                  'kategori': article['category'] is Map 
                      ? (article['category']['name'] ?? 'general')
                      : 'general',
                  'deskripsi': article['description'] ?? '',
                  'thumbnail': article['thumbnail'] ?? '',
                })
            .take(5)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _tipsList = [];
      });
      debugPrint('Error fetching tips: $e');
    }
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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
                    const SizedBox(height: 16),
                    ChatbotCard(
                      namaBot: 'Nurtura AI',
                      pesanAwal: 'Halo Bunda! 👋 Bagaimana perasaanmu hari ini? Aku siap mendengarkan.',
                      onOpenChat: () {
                        // TODO: navigasi ke halaman chatbot
                      },
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _tipsList.isEmpty
                        ? const Center(
                            child: Text(
                              'Belum ada tips tersedia',
                              style: TextStyle(
                                color: WarnaUtama.text2,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            clipBehavior: Clip.hardEdge,
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
                                  builder: (context) =>
                                      const TahapSkriningPage(),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilPage(),
                          ),
                        );
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
