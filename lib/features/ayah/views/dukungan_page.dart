import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class DukunganPage extends StatelessWidget {
  const DukunganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dukungan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tips dan cara mendukung istri pasca melahirkan",
                style: TextStyle(
                  fontSize: 14,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      size: 80,
                      color: WarnaUtama.secondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada konten dukungan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Konten dukungan akan segera hadir",
                      style: TextStyle(
                        fontSize: 14,
                        color: WarnaUtama.text1,
                      ),
                    ),
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