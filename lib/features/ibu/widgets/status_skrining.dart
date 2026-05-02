import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class StatusSkrining extends StatelessWidget {
  final bool berisiko;
  final String statusLabel;
  final String deskripsi;

  const StatusSkrining({
    super.key,
    required this.berisiko,
    required this.statusLabel,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    final Color warnaPrimary = berisiko ? const Color(0xFFF5A0A0) : WarnaUtama.secondary;
    final Color warnaIcon = berisiko ? const Color(0xFFE53935) : const Color(0xFF2E7D32);

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: warnaPrimary,
              width: 4,
            ),
            color: warnaPrimary.withOpacity(0.1),
          ),
          child: Icon(
            berisiko ? Icons.priority_high_rounded : Icons.health_and_safety_outlined,
            size: 52,
            color: warnaIcon,
          ),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: warnaPrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: warnaIcon,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          deskripsi,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: WarnaUtama.text1.withOpacity(0.6),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}