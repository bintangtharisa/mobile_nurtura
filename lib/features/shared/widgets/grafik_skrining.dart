import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/warna_utama.dart';

class GrafikSkrining extends StatelessWidget {
  final List<double> nilaiPerPeriode;
  final String periode;

  const GrafikSkrining({
    super.key,
    required this.nilaiPerPeriode,
    this.periode = 'minggu',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WarnaUtama.text2,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pemantauan Skrining Mental',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: WarnaUtama.text1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Frekuensi skrining ${periode == 'minggu' ? 'per hari' : 'per minggu'}',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12,
              color: WarnaUtama.text1.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          nilaiPerPeriode.isEmpty
              ? Container(
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: WarnaUtama.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 40,
                        color: WarnaUtama.secondary.withOpacity(0.4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada data skrining',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          color: WarnaUtama.text1.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (nilaiPerPeriode.reduce((a, b) => a > b ? a : b) + 1),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toInt()} skrining',
                              const TextStyle(
                                fontFamily: 'Manrope',
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= nilaiPerPeriode.length) {
                                return const SizedBox();
                              }
                              final label = periode == 'minggu'
                                  ? 'Sen ${index + 1}'
                                  : 'Minggu ${index + 1}';
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 10,
                                    color: WarnaUtama.text1.withOpacity(0.5),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: WarnaUtama.primary.withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        nilaiPerPeriode.length,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: nilaiPerPeriode[i],
                              color: nilaiPerPeriode[i] > 0
                                  ? WarnaUtama.secondary
                                  : WarnaUtama.primary.withOpacity(0.3),
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}