import 'package:flutter/material.dart';
import '../../../core/theme/warna_utama.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: WarnaUtama.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status Skrining Terakhir",
                    style: TextStyle(
                      color: WarnaUtama.text2,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "! ",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Berisiko Depresi",
                    style: TextStyle(
                      color: WarnaUtama.text2,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  backgroundColor: WarnaUtama.text1.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 5,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Berdasarkan hasil skrining terakhir 24 November 2026",
                style: TextStyle(
                  color: WarnaUtama.text2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}