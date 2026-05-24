import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/artikel_card.dart';
import '../widgets/artikel_horizontal.dart';
import '../services/article_service.dart';

class PanduanDukunganPage extends StatefulWidget {
  final VoidCallback? onBack;

  const PanduanDukunganPage({super.key, this.onBack});

  @override
  State<PanduanDukunganPage> createState() => _PanduanDukunganPageState();
}

class _PanduanDukunganPageState extends State<PanduanDukunganPage> {
  List<Map<String, dynamic>> _edukasiList = [];
  List<Map<String, dynamic>> _artikelList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final articles = await ArticleServiceAyah.getArticles();
      
      setState(() {
        // Take first 3 articles for edukasi (horizontal scroll)
        _edukasiList = articles
            .take(3)
            .map((article) => ArticleServiceAyah.formatForEdukasi(article))
            .toList();
        
        // Take all articles for artikel list
        _artikelList = articles
            .map((article) => ArticleServiceAyah.formatForArtikel(article))
            .toList();
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

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
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat data',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 16,
                                    color: WarnaUtama.text1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadData,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
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
                                child: _edukasiList.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Tidak ada data edukasi',
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
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
                                child: _artikelList.isEmpty
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 40),
                                          child: Text(
                                            'Tidak ada artikel tersedia',
                                            style: TextStyle(
                                              fontFamily: 'Manrope',
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
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