import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/grafik_skrining.dart';
import '../../shared/widgets/riwayat_card.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchScreeningHistory();
  }

  Future<void> _fetchScreeningHistory() async {
    try {
      debugPrint('🔄 Fetching screening history...');

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final screenings = await ScreeningService.getScreeningHistory();

      debugPrint('📊 Data received: ${screenings.length}');

      // ❗ JANGAN FORMAT ULANG LAGI (sudah diformat di service)
      setState(() {
        _riwayatList = screenings;
        _isLoading = false;
      });

      debugPrint('✅ Loaded: ${_riwayatList.length}');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      debugPrint('❌ Error: $e');
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

                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Gagal memuat riwayat\n$_errorMessage',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchScreeningHistory,
                                child: const Text('Coba Lagi'),
                              )
                            ],
                          ),
                        )

                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_riwayatList.isNotEmpty)
                                GrafikSkrining(
                                  nilaiPerMinggu: _riwayatList
                                      .reversed
                                      .map((e) => (e['berisiko'] == true ? 1.0 : 0.0))
                                      .toList(),
                                ),

                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Skrining Sebelumnya',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _fetchScreeningHistory,
                                    child: const Text(
                                      'Refresh',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              _riwayatList.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Center(
                                        child: Text('Belum ada riwayat skrining'),
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
                                          tanggal: item['tanggal'] ?? '-',
                                          status: item['status'] ?? '-',
                                          berisiko: item['berisiko'] ?? false,
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