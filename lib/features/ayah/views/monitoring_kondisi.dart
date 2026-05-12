import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../ibu/widgets/header.dart';
import '../../ibu/widgets/grafik_skrining.dart';
import '../../ibu/widgets/riwayat_card.dart';
import '../widgets/toggle_periode.dart';
import '../widgets/pengaturan_notifikasi.dart';

class MonitoringKondisiPage extends StatefulWidget {
  final VoidCallback? onBack;
  const MonitoringKondisiPage({super.key, this.onBack});

  @override
  State<MonitoringKondisiPage> createState() => _MonitoringKondisiPageState();
}

class _MonitoringKondisiPageState extends State<MonitoringKondisiPage> {
  int _periodeIndex = 0; // 0 = Mingguan, 1 = Bulanan

  // Data mingguan
  static const List<double> _dataMingguan = [2.0, 3.5, 7.0, 4.0, 2.5];

  // Data bulanan
  static const List<double> _dataBulanan = [3.0, 5.0, 6.5, 4.5, 3.0, 2.0];

  static const List<Map<String, dynamic>> _riwayatList = [
    {
      'tanggal': '4 Mei 2025',
      'status': 'Tidak Berisiko Depresi',
      'berisiko': false,
    },
    {
      'tanggal': '28 April 2025',
      'status': 'Berisiko Depresi',
      'berisiko': true,
    },
    {
      'tanggal': '1 April 2025',
      'status': 'Tidak Berisiko Depresi',
      'berisiko': false,
    },
    {
      'tanggal': '19 Maret 2025',
      'status': 'Tidak Berisiko Depresi',
      'berisiko': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dataGrafik = _periodeIndex == 0 ? _dataMingguan : _dataBulanan;

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Monitoring Kondisi',
                leftIcon: Icons.chevron_left,
                rightIcon: Icons.calendar_today_outlined,
                onLeftTap: () => widget.onBack?.call(),
                onRightTap: () {},
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle Mingguan/Bulanan
                    TogglePeriode(
                      selectedIndex: _periodeIndex,
                      onSelected: (index) {
                        setState(() => _periodeIndex = index);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Grafik
                    GrafikSkrining(
                      nilaiPerMinggu: dataGrafik,
                      periode: _periodeIndex == 0 ? 'minggu' : 'bulan',
                    ),

                    const SizedBox(height: 24),

                    // Pengaturan Notifikasi
                    const PengaturanNotifikasi(),

                    const SizedBox(height: 24),

                    // Section header Riwayat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Riwayat Skrining',
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