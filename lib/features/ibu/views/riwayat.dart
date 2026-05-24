import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/grafik_skrining.dart';
import '../../shared/widgets/riwayat_card.dart';
import '../../shared/widgets/toggle_periode.dart';
import '../services/screening_service.dart';

class RiwayatPage extends StatefulWidget {
  final VoidCallback? onBack;
  const RiwayatPage({super.key, this.onBack});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> _riwayatList = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _periodeIndex = 0; // 0 = mingguan, 1 = bulanan

  @override
  void initState() {
    super.initState();
    _fetchScreeningHistory();
  }

  Future<void> _fetchScreeningHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final screenings = await ScreeningService.getScreeningHistory();
      final formattedList = screenings
          .map((screening) => ScreeningService.formatScreening(screening))
          .toList();

      setState(() {
        _riwayatList = formattedList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Hitung frekuensi skrining per hari dalam seminggu (index 0-6 = Sen-Min)
  List<double> _hitungDataMingguan() {
    final List<double> data = List.filled(7, 0);
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (final item in _riwayatList) {
      final tanggal = item['tanggalRaw'] as DateTime?;
      if (tanggal == null) continue;
      if (tanggal.isAfter(startOfWeek.subtract(const Duration(days: 1)))) {
        final dayIndex = tanggal.weekday - 1;
        data[dayIndex]++;
      }
    }
    return data;
  }

  // Hitung frekuensi skrining per minggu dalam sebulan (minggu 1-4)
  List<double> _hitungDataBulanan() {
    final List<double> data = List.filled(4, 0);
    final now = DateTime.now();

    for (final item in _riwayatList) {
      final tanggal = item['tanggalRaw'] as DateTime?;
      if (tanggal == null) continue;
      if (tanggal.month == now.month && tanggal.year == now.year) {
        final weekIndex = ((tanggal.day - 1) / 7).floor().clamp(0, 3);
        data[weekIndex]++;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final dataGrafik = _periodeIndex == 0
        ? _hitungDataMingguan()
        : _hitungDataBulanan();

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Riwayat Skrining',
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: WarnaUtama.beresiko, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Gagal memuat riwayat\n$_errorMessage',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: WarnaUtama.text1),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _fetchScreeningHistory,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
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

                              const SizedBox(height: 16),

                              // Grafik
                              GrafikSkrining(
                                nilaiPerPeriode: dataGrafik,
                                periode: _periodeIndex == 0 ? 'minggu' : 'bulan',
                              ),

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
                                    onTap: _fetchScreeningHistory,
                                    child: const Text(
                                      'Refresh',
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

                              _riwayatList.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Center(
                                        child: Text(
                                          'Belum ada riwayat skrining',
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            color: WarnaUtama.text1,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _riwayatList.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 10),
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