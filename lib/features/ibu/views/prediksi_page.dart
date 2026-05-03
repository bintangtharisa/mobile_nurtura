import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class PrediksiPage extends StatelessWidget {
  const PrediksiPage({super.key});

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
                "Prediksi",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Lakukan skrining untuk mengetahui kondisi mentalmu",
                style: TextStyle(
                  fontSize: 14,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 80,
                      color: WarnaUtama.secondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Belum ada skrining",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Mulai skrining pertamamu sekarang",
                      style: TextStyle(
                        fontSize: 14,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WarnaUtama.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // TODO: navigasi ke form skrining
                        },
                        child: const Text(
                          "Mulai Skrining",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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