import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class StatusSkriningCard extends StatelessWidget {
  final String statusLabel;
  final String deskripsi;
  final bool berisiko;

  const StatusSkriningCard({
    super.key,
    required this.statusLabel,
    required this.deskripsi,
    this.berisiko = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WarnaUtama.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                'Status Skrining Terakhir Istri',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: WarnaUtama.text2.withOpacity(0.85),
                ),
              ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: WarnaUtama.text2.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: WarnaUtama.text2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Status label
          Row(
            children: [
              if (berisiko)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.error,
                    size: 20,
                    color: Colors.red.shade300,
                  ),
                ),
              Text(
                statusLabel,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: WarnaUtama.text2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: null,
              backgroundColor: WarnaUtama.text2.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(WarnaUtama.text2),
              minHeight: 5,
            ),
          ),

          const SizedBox(height: 12),
          
          // Divider
          Divider(
            color: WarnaUtama.text2.withOpacity(0.3),
            thickness: 0.8,
          ),

          const SizedBox(height: 10),

          // Deskripsi
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: WarnaUtama.text2.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  deskripsi,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: WarnaUtama.text2.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}