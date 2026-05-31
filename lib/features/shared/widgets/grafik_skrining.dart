import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/warna_utama.dart';

class GrafikSkrining extends StatelessWidget {
  final List<double> nilaiPerPeriode;
  final String periode;
  final List<String>? labels;

  const GrafikSkrining({
    super.key,
    required this.nilaiPerPeriode,
    this.periode = 'minggu',
    this.labels,
  });

  String _formatTanggal(String raw) {
    final cleaned = raw.replaceAll('\n', '').trim();

    final date = DateTime.tryParse(cleaned);
    if (date == null) return cleaned;

    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return '${date.day} ${bulan[date.month - 1]}';
  }

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
          const SizedBox(height: 20),

          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),

                maxY: (nilaiPerPeriode.isNotEmpty
                    ? nilaiPerPeriode.reduce((a, b) => a > b ? a : b) + 1
                    : 1),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: WarnaUtama.primary.withOpacity(0.08),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),

                barGroups: List.generate(
                  nilaiPerPeriode.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: nilaiPerPeriode[i],
                        color: i == nilaiPerPeriode.length - 1
                            ? WarnaUtama.secondary
                            : WarnaUtama.secondary.withOpacity(0.55),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
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

                        if (index < 0 ||
                            index >= nilaiPerPeriode.length) {
                          return const SizedBox();
                        }

                        final rawLabel = (labels != null &&
                                index < labels!.length)
                            ? labels![index]
                            : '';

                        if (rawLabel.isEmpty) {
                          return const SizedBox();
                        }

                        final label = _formatTanggal(rawLabel);

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              color: WarnaUtama.text1.withOpacity(0.45),
                            ),
                          ),
                        );
                      },
                    ),
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