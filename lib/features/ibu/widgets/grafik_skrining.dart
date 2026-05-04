import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/warna_utama.dart';

class GrafikSkrining extends StatelessWidget {
  final List<double> nilaiPerMinggu;

  const GrafikSkrining({
    super.key,
    required this.nilaiPerMinggu,
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
            'Berdasarkan ${nilaiPerMinggu.length} kali hasil skrining milikmu',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12,
              color: WarnaUtama.text1.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= nilaiPerMinggu.length) return const SizedBox();
                        return Text(
                          'Minggu ${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            color: WarnaUtama.text1.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      nilaiPerMinggu.length,
                      (i) => FlSpot(i.toDouble(), nilaiPerMinggu[i]),
                    ),
                    isCurved: true,
                    color: WarnaUtama.secondary,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                        radius: 5,
                        color: WarnaUtama.text2,
                        strokeWidth: 2.5,
                        strokeColor: WarnaUtama.secondary,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: WarnaUtama.secondary.withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}