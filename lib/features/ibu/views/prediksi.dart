import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../widgets/prediksi_card.dart';
import '../widgets/mulai_skrining_card.dart';
import '../../shared/widgets/header.dart';
import '../views/tahap_skrining.dart';

class PrediksiPage extends StatefulWidget {
  final VoidCallback? onBack;
  const PrediksiPage({super.key, this.onBack});

  @override
  State<PrediksiPage> createState() => _PrediksiPageState();
}

class _PrediksiPageState extends State<PrediksiPage> {
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
                onLeftTap: () => widget.onBack?.call(),
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