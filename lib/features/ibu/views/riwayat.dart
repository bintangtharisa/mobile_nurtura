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
      debugPrint('🔄 [RiwayatPage] Starting to fetch screening history...');
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      debugPrint('⏳ [RiwayatPage] Loading state set to true');

      final screenings = await ScreeningService.getScreeningHistory();
      debugPrint('📊 [RiwayatPage] Received ${screenings.length} raw screening records');
      
      final formattedList = screenings
          .map((screening) => ScreeningService.formatScreening(screening))
          .toList();
      
      debugPrint('✨ [RiwayatPage] Formatted ${formattedList.length} screening records for display');

      setState(() {
        _riwayatList = formattedList;
        _isLoading = false;
      });
      debugPrint('✅ [RiwayatPage] Successfully loaded ${_riwayatList.length} records');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      debugPrint('❌ [RiwayatPage] Error fetching screening history: $e');
      debugPrint('❌ [RiwayatPage] Error message displayed: $_errorMessage');
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
                        if (_riwayatList.isNotEmpty)
                          GrafikSkrining(
                            nilaiPerMinggu: _riwayatList
                                .reversed
                                .map((e) => (e['berisiko'] ? 1.0 : 0.0))
                                .toList(),
                          ),

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