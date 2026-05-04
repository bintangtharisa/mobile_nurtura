import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

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
                "Monitoring",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: WarnaUtama.text1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pantau kondisi istri kamu di sini",
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
                      Icons.monitor_heart_outlined,
                      size: 80,
                      color: WarnaUtama.secondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Belum ada data monitoring",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Data kondisi istri akan muncul di sini",
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