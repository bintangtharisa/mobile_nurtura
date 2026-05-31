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
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final screenings = await ScreeningService.getScreeningHistory();

      setState(() {
        _riwayatList = screenings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  /// 🔥 SAFE GROUPING (ANTI ERROR + CLEAN DATA)
  Map<String, int> _getGrafikPerTanggal() {
    final Map<String, int> map = {};

    for (final item in _riwayatList) {
      final raw = item['tanggal']?.toString() ?? '';

      final cleaned = raw.replaceAll('\n', '').replaceAll('\r', '').trim();

      final parsed = DateTime.tryParse(cleaned);

      final key = parsed != null
          ? parsed.toIso8601String().substring(0, 10)
          : (cleaned.length >= 10 ? cleaned.substring(0, 10) : cleaned);

      map[key] = (map[key] ?? 0) + 1;
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grafikData = _getGrafikPerTanggal();

    final sorted = grafikData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final limited = sorted.length > 7
        ? sorted.sublist(sorted.length - 7)
        : sorted;

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: CardHeader(title: 'Riwayat Skrining'),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat riwayat\n$_errorMessage',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchScreeningHistory,
                            child: const Text('Coba Lagi'),
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

                              key: UniqueKey(),
                              nilaiPerPeriode: limited
                                  .map((e) => e.value.toDouble())
                                  .toList(),

                              labels: limited.map((e) {
                                final date = DateTime.tryParse(e.key);

                                if (date == null) return e.key;

                                const bulan = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'Mei',
                                  'Jun',
                                  'Jul',
                                  'Agu',
                                  'Sep',
                                  'Okt',
                                  'Nov',
                                  'Des',
                                ];

                                return '${date.day} ${bulan[date.month - 1]}';
                              }).toList(),
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
                                  style: TextStyle(color: WarnaUtama.secondary),
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
