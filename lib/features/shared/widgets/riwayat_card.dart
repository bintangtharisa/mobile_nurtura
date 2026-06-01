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
    final Color baseColor =
        berisiko ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: baseColor.withOpacity(0.05), // background card
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: baseColor.withOpacity(0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                berisiko
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                color: baseColor,
              ),
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanggal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
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