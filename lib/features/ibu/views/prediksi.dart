import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/prediksi_card.dart';
import '../widgets/hasil_terakhir_skrining_card.dart';
import '../widgets/mulai_skrining_card.dart';
import '../widgets/header.dart';
import '../views/tahap_skrining.dart';
import '../../services/prediksi_service.dart';

class PrediksiPage extends StatefulWidget {
  final VoidCallback? onBack;
  const PrediksiPage({super.key, this.onBack});

  @override
  State<PrediksiPage> createState() => _PrediksiPageState();
}

class _PrediksiPageState extends State<PrediksiPage> {
  Map<String, dynamic>? _hasilTerakhir;

  @override
  void initState() {
    super.initState();
    _loadHasilTerakhir();
  }

  Future<void> _loadHasilTerakhir() async {
    try {
      final hasil = await PrediksiService.getHasilTerakhir();
      setState(() => _hasilTerakhir = hasil);
    } catch (e) {
      // gagal load
    }
  }

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

                    _hasilTerakhir == null
                      ? const Text(
                          'Belum ada hasil skrining',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            color: WarnaUtama.text1,
                          ),
                        )
                      : HasilTerakhirCard(
                          statusLabel: _hasilTerakhir!['status'],
                          tanggal: _hasilTerakhir!['tanggal'],
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