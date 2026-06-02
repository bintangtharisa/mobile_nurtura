import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class TipsPopuler extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider? image;
  final VoidCallback? onTap;

  const TipsPopuler({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: image != null
                    ? Image(
                        image: image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                ),
              ),
            ),

            // konten teks
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: WarnaUtama.secondary.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'POPULER',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: WarnaUtama.text2,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: WarnaUtama.text2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: WarnaUtama.text2.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: WarnaUtama.primary.withOpacity(0.35),
      child: const Center(
        child: Icon(
          Icons.article_outlined,
          size: 48,
          color: WarnaUtama.secondary,
        ),
      ),
    );
  }
}
