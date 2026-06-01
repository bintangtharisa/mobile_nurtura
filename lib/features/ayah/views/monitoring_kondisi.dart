import 'package:flutter/material.dart';

import '../../../core/theme/warna_utama.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/grafik_skrining.dart';
import '../../shared/widgets/riwayat_card.dart';
import '../../shared/widgets/toggle_periode.dart';
import '../widgets/pengaturan_notifikasi.dart';
import '../services/monitoring_service.dart';

class MonitoringKondisiPage extends StatefulWidget {
  const MonitoringKondisiPage({super.key});

  @override
  State<MonitoringKondisiPage> createState() =>
      _MonitoringKondisiPageState();
}

class _MonitoringKondisiPageState extends State<MonitoringKondisiPage> {
  int _periodeIndex = 0;

  List<double> _mingguan = [];
  List<double> _bulanan = [];
  List<Map<String, dynamic>> _riwayat = [];

  bool _loading = true;
  String? _error;
  bool _connected = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final mingguan = await MonitoringServiceAyah.getMonitoringData(
        chartPeriod: 'mingguan',
      );

      final bulanan = await MonitoringServiceAyah.getMonitoringData(
        chartPeriod: 'bulanan',
      );

      setState(() {
        _connected = mingguan['is_connected'] ?? false;
        _message = mingguan['message'];

        if (_connected) {
          _mingguan =
              MonitoringServiceAyah.formatChartData(mingguan['chart']);

          _bulanan =
              MonitoringServiceAyah.formatChartData(bulanan['chart']);

          _riwayat =
              MonitoringServiceAyah.formatHistoryList(mingguan['data']);
        }

        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        _periodeIndex == 0 ? _mingguan : _bulanan;

    return Scaffold(
      backgroundColor: WarnaUtama.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: CardHeader(title: 'Monitoring Kondisi'),
            ),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : !_connected
                          ? Center(child: Text(_message ?? '-'))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TogglePeriode(
                                    selectedIndex: _periodeIndex,
                                    onSelected: (i) {
                                      setState(() => _periodeIndex = i);
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GrafikSkrining(
                                    nilaiPerPeriode: data,
                                    periode: _periodeIndex == 0
                                        ? 'minggu'
                                        : 'bulan',
                                  ),

                                  const SizedBox(height: 24),

                                  const PengaturanNotifikasi(),

                                  const SizedBox(height: 24),

                                  const Text(
                                    'Riwayat Skrining',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  _riwayat.isEmpty
                                      ? const Center(
                                          child: Text('Belum ada riwayat'),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: _riwayat.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, i) {
                                            final item = _riwayat[i];

                                            return RiwayatCard(
                                              tanggal: item['tanggal'] ?? '-',
                                              status: item['status'] ?? '-',
                                              berisiko:
                                                  item['berisiko'] ?? false,
                                              onTap: () {},
                                            );
                                          },
                                        ),
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