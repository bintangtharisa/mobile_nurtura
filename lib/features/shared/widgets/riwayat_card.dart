import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class RiwayatCard extends StatelessWidget {
  final String tanggal;
  final String status;
  final bool berisiko;
  final VoidCallback? onTap;

  const RiwayatCard({
    super.key,
    required this.tanggal,
    required this.status,
    required this.berisiko,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color warnaBg = berisiko
        ? WarnaUtama.beresiko.withOpacity(0.6)
        : WarnaUtama.button;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: WarnaUtama.form,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: warnaBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                berisiko ? Icons.priority_high_rounded : Icons.health_and_safety_outlined,
                size: 22,
                color: WarnaUtama.text2,
              ),
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: WarnaUtama.text1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: WarnaUtama.text1.withOpacity(0.5),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}