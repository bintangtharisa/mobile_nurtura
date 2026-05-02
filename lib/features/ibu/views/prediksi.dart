import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/prediksi_card.dart';
import '../widgets/hasil_terakhir_skrining_card.dart';
import '../widgets/mulai_skrining_card.dart';
import '../widgets/header.dart';
import '../views/tahap_skrining.dart';

class PrediksiPage extends StatelessWidget {
    final VoidCallback? onBack;
    const PrediksiPage({super.key, this.onBack});

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
                title: 'Prediksi',
                leftIcon: Icons.chevron_left,
                rightIcon: Icons.calendar_today_outlined,
                onLeftTap: () => onBack?.call(),
                onRightTap: () {},
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BannerPrediksiCard(title: 'Mari pantau kondisi Ibu'),

                    const SizedBox(height: 24),

                    const Text(
                      'Hasil Terakhir',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: WarnaUtama.text1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    HasilTerakhirCard(
                      statusLabel: 'Berisiko Depresi',
                      tanggal: '4 Mei 2025',
                      onLihatDetail: () {},
                    ),

                    const SizedBox(height: 16),

                    MulaiSkriningCard(
                      onMulai: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TahapSkriningPage(),
                          ),
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