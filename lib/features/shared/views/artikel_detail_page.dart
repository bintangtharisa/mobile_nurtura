import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../../ibu/services/article_service.dart';
import '../../../utils/api.dart';

class ArtikelDetailPage extends StatelessWidget {
  final String artikelId;
  final String judul;
  final String kategori;
  final String durasi;
  final String? initialContent;
  final String? initialThumbnail;

  const ArtikelDetailPage({
    super.key,
    required this.artikelId,
    required this.judul,
    required this.kategori,
    required this.durasi,
    this.initialContent,
    this.initialThumbnail,
  });

  String _categoryName(dynamic category) {
    if (category is Map) return (category['name'] ?? kategori).toString();
    return (category ?? kategori).toString();
  }

  String _content(Map<String, dynamic>? article) {
    return (article?['content'] ??
            article?['description'] ??
            article?['excerpt'] ??
            initialContent ??
            'Konten artikel belum tersedia.')
        .toString();
  }

  String? _thumbnail(Map<String, dynamic>? article) {
    final raw = article?['thumbnail'] ?? article?['image'] ?? initialThumbnail;
    if (raw == null || raw.toString().isEmpty) return null;
    final value = raw.toString();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    final origin = Api.baseUrl.replaceFirst('/api', '');
    return value.startsWith('/') ? '$origin$value' : '$origin/storage/$value';
  }

  Future<Map<String, dynamic>?> _loadArticle() async {
    if (artikelId.isEmpty || artikelId == 'null') return null;
    return ArticleService.getArticle(artikelId);
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
                title: '',
                leftIcon: Icons.chevron_left,
                onLeftTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _loadArticle(),
                builder: (context, snapshot) {
                  final article = snapshot.data;
                  final title = (article?['title'] ?? judul).toString();
                  final category = _categoryName(article?['category']);
                  final content = _content(article);
                  final thumbnail = _thumbnail(article);
                  final readingTime = durasi.isNotEmpty
                      ? durasi
                      : '${(content.split(RegExp(r'\s+')).length / 200).ceil()} menit baca';

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      initialContent == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: thumbnail != null
                              ? Image.network(
                                  thumbnail,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _placeholder(),
                                )
                              : _placeholder(),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: WarnaUtama.secondary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: WarnaUtama.secondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: WarnaUtama.text1,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: WarnaUtama.text1.withOpacity(0.4),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              readingTime,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                color: WarnaUtama.text1.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(color: WarnaUtama.primary.withOpacity(0.3)),
                        const SizedBox(height: 20),
                        Text(
                          content,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 15,
                            color: WarnaUtama.text1,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 32),
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

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: WarnaUtama.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.article_outlined,
        size: 64,
        color: WarnaUtama.secondary.withOpacity(0.5),
      ),
    );
  }
}
