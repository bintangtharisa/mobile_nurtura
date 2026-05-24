import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/grafik_skrining.dart';
import '../../shared/widgets/riwayat_card.dart';
import '../../shared/widgets/toggle_periode.dart';
import '../widgets/pengaturan_notifikasi.dart';
import '../services/monitoring_service.dart';

class MonitoringKondisiPage extends StatefulWidget {
  final VoidCallback? onBack;
  const MonitoringKondisiPage({super.key, this.onBack});

  @override
  State<MonitoringKondisiPage> createState() => _MonitoringKondisiPageState();
}

class _MonitoringKondisiPageState extends State<MonitoringKondisiPage> {
  int _periodeIndex = 0; // 0 = Mingguan, 1 = Bulanan
  
  List<double> _dataMingguan = [];
  List<double> _dataBulanan = [];
  List<Map<String, dynamic>> _riwayatList = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isConnected = false;
  String? _connectionMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Fetch mingguan data
      final mingguanData = await MonitoringServiceAyah.getMonitoringData(
        chartPeriod: 'mingguan',
      );

      // Fetch bulanan data
      final bulananData = await MonitoringServiceAyah.getMonitoringData(
        chartPeriod: 'bulanan',
      );

      setState(() {
        _isConnected = mingguanData['is_connected'] as bool? ?? false;
        _connectionMessage = mingguanData['message'] as String?;
        
        if (_isConnected) {
          _dataMingguan = MonitoringServiceAyah.formatChartData(
            mingguanData['chart'] as Map<String, dynamic>?,
          );
          _dataBulanan = MonitoringServiceAyah.formatChartData(
            bulananData['chart'] as Map<String, dynamic>?,
          );
          _riwayatList = MonitoringServiceAyah.formatHistoryList(
            mingguanData['data'] as List<dynamic>?,
          );
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

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
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat data',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 16,
                                    color: WarnaUtama.text1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadData,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : !_isConnected
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.link_off,
                                      size: 48,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _connectionMessage ?? 'Belum terhubung dengan akun ibu',
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 16,
                                        color: WarnaUtama.text1,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Silakan hubungkan akun Anda dengan akun ibu untuk melihat data monitoring.',
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
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

                                  const SizedBox(height: 20),

                                  // Grafik
                                  if (dataGrafik.every((v) => v == 0))
                                    const Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.assessment_outlined,
                                              size: 48,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Belum Ada Data Skrining',
                                              style: TextStyle(
                                                fontFamily: 'Manrope',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Data skrining istri akan muncul di sini setelah istri melakukan skrining.',
                                              style: TextStyle(
                                                fontFamily: 'Manrope',
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    GrafikSkrining(
                                      nilaiPerPeriode: dataGrafik,
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
                                  _riwayatList.isEmpty
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 40),
                                            child: Text(
                                              'Belum ada riwayat skrining',
                                              style: TextStyle(
                                                fontFamily: 'Manrope',
                                                color: Colors.grey,
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