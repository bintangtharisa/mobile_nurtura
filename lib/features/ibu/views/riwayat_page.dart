import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

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
                "Riwayat",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Riwayat hasil skrining kamu",
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
                      Icons.history,
                      size: 80,
                      color: WarnaUtama.secondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada riwayat",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Riwayat skriningmu akan muncul di sini",
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