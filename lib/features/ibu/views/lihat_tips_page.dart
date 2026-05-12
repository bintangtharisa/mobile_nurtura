import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../ibu/widgets/header.dart';
import '../../ibu/widgets/filter_tips.dart';
import '../../ibu/widgets/tips_populer.dart';
import '../../ibu/widgets/artikel_card.dart';
import '../services/article_service.dart';
import '../services/article_category_service.dart';

class LihatTipsPage extends StatefulWidget {
  const LihatTipsPage({super.key});

  @override
  State<LihatTipsPage> createState() => _LihatTipsPageState();
}

class _LihatTipsPageState extends State<LihatTipsPage> {
  int _selectedKategori = 0;

  late final Future<Map<String, dynamic>> _futureData;

  static const List<Map<String, dynamic>> _kategori = [
    {'label': 'Semua', 'display': 'Semua', 'icon': null},
    {'label': 'self-care', 'display': 'Self Care', 'icon': Icons.spa_outlined},
    {'label': 'mental_health', 'display': 'Mental Health', 'icon': Icons.psychology_outlined},
    {'label': 'nutrisi', 'display': 'Nutrisi', 'icon': Icons.restaurant_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _futureData = ArticleService.getTipsPageData();
  }

  List<Map<String, dynamic>> _filterArticles(List<Map<String, dynamic>> list) {
    if (_selectedKategori == 0) return list;
    final label = _kategori[_selectedKategori]['label'] as String;

    return list.where((a) {
      // category bisa berupa Map {'name': '...'} atau String langsung
      final raw = a['category'];
      final String categoryName;
      if (raw is Map) {
        categoryName = (raw['name'] ?? '').toString();
      } else {
        categoryName = (raw ?? '').toString();
      }
      return categoryName.toLowerCase() == label.toLowerCase();
    }).toList();
  }

  String _formatKategori(dynamic category) {
    final String name;
    if (category is Map) {
      name = (category['name'] ?? '').toString();
    } else {
      name = (category ?? '').toString();
    }

    switch (name.toLowerCase()) {
      case 'mental_health':
        return 'Mental Health';
      case 'nutrisi':
        return 'Nutrisi';
      case 'self-care':
        return 'Self Care';
      default:
        return name;
    }
  }

  String _getSubtitle(Map<String, dynamic> article) {
    // Coba field 'content' dulu, fallback ke 'excerpt'
    final text = (article['content'] ?? article['excerpt'] ?? '') as String;
    return text.length > 50 ? '${text.substring(0, 50)}...' : text;
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
              child: FutureBuilder<Map<String, dynamic>>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat data\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: WarnaUtama.text1),
                          ),
                        ],
                      ),
                    );
                  }

                  final data = snapshot.data!;

                  // key 'articles' sesuai ArticleService.getTipsPageData()
                  final articleList = (data['articles'] as List? ?? [])
                      .map((e) => e as Map<String, dynamic>)
                      .toList();

                  final populer = data['populer'] as Map<String, dynamic>?;

                  final populerSubtitle = () {
                    final text = (populer?['content'] ?? populer?['excerpt'] ??
                        'Temukan tips terbaik untuk ibu.') as String;
                    return text.length > 60 ? '${text.substring(0, 60)}...' : text;
                  }();

                  final populerImage = populer?['image'] ?? populer?['thumbnail'];

                  final filteredList = _filterArticles(articleList);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TipsPopuler(
                          title: populer?['title'] ?? 'Tips Populer',
                          subtitle: populerSubtitle,
                          image: populerImage != null
                              ? NetworkImage(populerImage)
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

                        filteredList.isEmpty
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
                                itemCount: filteredList.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final article = filteredList[index];
                                  return ArtikelCard(
                                    kategori: _formatKategori(article['category']),
                                    title: article['title'] ?? '',
                                    durasi: _getSubtitle(article),
                                    icon: Icons.tips_and_updates_outlined,
                                    onTap: () {},
                                  );
                                },
                              ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}