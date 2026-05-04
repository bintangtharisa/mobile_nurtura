import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class HasilTerakhirCard extends StatelessWidget {
  final String statusLabel;
  final String tanggal;
  final VoidCallback? onLihatDetail;

  const HasilTerakhirCard({
    super.key,
    required this.statusLabel,
    required this.tanggal,
    this.onLihatDetail,
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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusLabel,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WarnaUtama.text1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Diperbarui pada $tanggal',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: WarnaUtama.text1.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onLihatDetail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: WarnaUtama.form,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: WarnaUtama.text1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: WarnaUtama.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bar_chart_outlined,
              size: 26,
              color: WarnaUtama.secondary,
            ),
          ),
        ],
      ),
    );
  }
}