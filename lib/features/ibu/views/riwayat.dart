import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/header.dart';
import '../widgets/grafik_skrining.dart';
import '../widgets/riwayat_card.dart';
import '../../services/prediksi_service.dart';

class RiwayatPage extends StatefulWidget {
  final VoidCallback? onBack;
  const RiwayatPage({super.key, this.onBack});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> _riwayatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    try {
      final data = await PrediksiService.getRiwayat();
      setState(() {
        _riwayatList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nilaiGrafik = _riwayatList
        .reversed
        .map((e) => (e['nilai'] as num).toDouble())
        .toList();

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(
                title: 'Riwayat Skrining',
                leftIcon: Icons.chevron_left,
                rightIcon: Icons.calendar_today_outlined,
                onLeftTap: () => widget.onBack?.call(),
                onRightTap: () {},
              ),
            ),

            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GrafikSkrining(nilaiPerMinggu: nilaiGrafik),

                        const SizedBox(height: 24),

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

                        _riwayatList.isEmpty
                          ? const Text(
                              'Belum ada riwayat skrining',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                color: WarnaUtama.text1,
                              ),
                            )
                          : ListView.separated(
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