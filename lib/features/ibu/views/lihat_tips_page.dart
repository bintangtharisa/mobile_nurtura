import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../ibu/widgets/header.dart';
import '../../ibu/widgets/filter_tips.dart';
import '../../ibu/widgets/tips_populer.dart';
import '../../ibu/widgets/artikel_card.dart';
import '../../services/tips_service.dart';

class LihatTipsPage extends StatefulWidget {
  const LihatTipsPage({super.key});

  @override
  State<LihatTipsPage> createState() => _LihatTipsPageState();
}

class _LihatTipsPageState extends State<LihatTipsPage> {
  int _selectedKategori = 0;
  List<Map<String, dynamic>> _artikelList = [];
  Map<String, dynamic>? _tipsPopuler;
  bool _isLoading = true;

  static const List<Map<String, dynamic>> _kategori = [
    {'label': 'Semua', 'icon': null},
    {'label': 'Self-care', 'icon': Icons.spa_outlined},
    {'label': 'Mental Health', 'icon': Icons.psychology_outlined},
    {'label': 'Nutrisi', 'icon': Icons.restaurant_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    try {
      final data = await TipsService.getTips();
      final populer = await TipsService.getTipsPopuler();
      setState(() {
        _artikelList = data;
        _tipsPopuler = populer;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredArtikel {
    if (_selectedKategori == 0) return _artikelList;
    final label = _kategori[_selectedKategori]['label'] as String;
    return _artikelList
        .where((a) =>
            (a['kategori'] as String).toLowerCase() == label.toLowerCase())
        .toList();
  }

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
                title: 'Lihat Tips',
                leftIcon: Icons.chevron_left,
                rightIcon: Icons.notifications_none,
                onLeftTap: () => Navigator.pop(context),
                onRightTap: () {},
              ),
            ),

            FilterKategori(
              kategori: _kategori,
              onSelected: (index) {
                setState(() => _selectedKategori = index);
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       TipsPopuler(
                        title: _tipsPopuler?['judul'] ?? _tipsPopuler?['title'] ?? 'Membangun Bonding dengan Si Kecil',
                        subtitle: _tipsPopuler?['deskripsi'] ?? _tipsPopuler?['subtitle'] ?? 'Rahasia kedekatan emosional ibu dan bayi.',
                        image: _tipsPopuler?['image'] != null
                            ? NetworkImage(_tipsPopuler!['image'])
                            : const NetworkImage('https://picsum.photos/400/200'),
                      ),

                        const SizedBox(height: 24),

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

                        _filteredArtikel.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text(
                                  'Tidak ada artikel di kategori ini',
                                  style: TextStyle(
                                    color: WarnaUtama.text1,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredArtikel.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final artikel = _filteredArtikel[index];
                                return ArtikelCard(
                                kategori: artikel['kategori'] ?? '',
                                title: artikel['judul'] ?? artikel['title'] ?? '',
                                durasi: artikel['durasi'] ?? '',
                                icon: Icons.article_outlined,
                                onTap: () {},
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