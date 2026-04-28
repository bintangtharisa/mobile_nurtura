import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class DukunganCard extends StatelessWidget {
  final String title;
  final String deskripsi;
  final ImageProvider? image;

  const DukunganCard({
    super.key,
    required this.title,
    required this.deskripsi,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WarnaUtama.text2,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WarnaUtama.text1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  deskripsi,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: WarnaUtama.text1.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (image != null) ...[
            const SizedBox(width: 12),
            ClipOval(
              child: Image(
                image: image!,
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ],
      ),
    );
  }
}