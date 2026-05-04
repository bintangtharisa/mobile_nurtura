import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/grafik_skrining.dart';
import '../widgets/riwayat_card.dart';

class RiwayatPage extends StatelessWidget {
  final VoidCallback? onBack;
  const RiwayatPage({super.key, this.onBack});

  static const List<Map<String, dynamic>> _riwayatList = [
    {
      'tanggal': '4 Mei 2025',
      'status': 'Tidak Berisiko Depresi',
      'berisiko': false,
      'nilai': 2.0,
    },
    {
      'tanggal': '28 April 2025',
      'status': 'Berisiko Depresi',
      'berisiko': true,
      'nilai': 7.0,
    },
    {
      'tanggal': '1 April 2025',
      'status': 'Tidak Berisiko Depresi',
      'berisiko': false,
      'nilai': 3.0,
    },
    {
      'tanggal': '19 Maret 2025',
      'status': 'Tidak Berisiko Depresi',
      'berisiko': false,
      'nilai': 2.5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final nilaiGrafik = _riwayatList
        .reversed
        .map((e) => e['nilai'] as double)
        .toList();

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Riwayat Skrining',
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
                    // Grafik
                    GrafikSkrining(nilaiPerMinggu: nilaiGrafik),

                    const SizedBox(height: 24),

                    // Section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Skrining Sebelumnya',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: WarnaUtama.text1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: WarnaUtama.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // List riwayat
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _riwayatList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _riwayatList[index];
                        return RiwayatCard(
                          tanggal: item['tanggal'] as String,
                          status: item['status'] as String,
                          berisiko: item['berisiko'] as bool,
                          onTap: () {},
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