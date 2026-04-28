import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class BannerPrediksiCard extends StatelessWidget {
  final String title;

  const BannerPrediksiCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: WarnaUtama.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: WarnaUtama.text2,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.volunteer_activism_outlined,
              size: 36,
              color: WarnaUtama.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: WarnaUtama.text2,
            ),
          ),
        ],
      ),
    );
  }
}